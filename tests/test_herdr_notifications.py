import importlib.util
from pathlib import Path
import unittest

source = Path(__file__).resolve().parents[1] / "modules/features/terminal/herdr-notifications.py"
spec = importlib.util.spec_from_file_location("herdr_notifications", source)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class NotificationTests(unittest.TestCase):
    def setUp(self):
        self.sent = []
        self.listener = module.Notifications(lambda *args: self.sent.append(args))
        self.record = {
            "address": "t1", "status": {"state": "working", "app": "codex"},
            "labels": {"herdr.space": "space1", "where": "repo / Agent"},
            "title": "Fix <bug>",
        }
        self.listener.accept({"terminals": [self.record]})

    def status(self, state):
        self.listener.accept({"method": "event", "params": {
            "type": "status", "terminal": "t1",
            "data": {"status": {"state": state, "app": "codex"}},
        }})

    def test_completion_and_duplicates(self):
        self.status("done")
        self.status("done")
        self.status("idle")
        self.assertEqual(self.sent, [("Codex finished", "repo / Agent\nFix &lt;bug&gt;")])

    def test_idle_can_complete_a_turn(self):
        self.status("idle")
        self.assertEqual(len(self.sent), 1)

    def test_attention_and_recovery(self):
        self.status("blocked")
        self.status("blocked")
        self.status("error")
        self.status("working")
        self.status("blocked")
        self.assertEqual([n[0] for n in self.sent], ["Codex needs you"] * 2)

    def test_error(self):
        self.status("error")
        self.assertEqual(self.sent[0][0], "Codex reported an error")

    def test_initial_and_missed_snapshots_do_not_notify(self):
        self.record["status"] = {"state": "blocked"}
        self.listener.accept({"method": "missed", "params": {"terminals": [self.record]}})
        self.status("blocked")
        self.assertEqual(self.sent, [])

    def test_unlabelled_terminal_does_not_notify(self):
        self.record["labels"] = {}
        self.status("done")
        self.assertEqual(self.sent, [])

    def test_shell_exit_is_not_agent_completion(self):
        self.listener.accept({"method": "event", "params": {
            "type": "finished", "terminal": "t1", "data": {"exit_code": 0},
        }})
        self.assertEqual(self.sent, [])


if __name__ == "__main__":
    unittest.main()
