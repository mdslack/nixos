"""Forward new Herdr Desktop agent attention events to the desktop notification bus."""

import html
import json
import subprocess
import sys


class Notifications:
    def __init__(self, send):
        self.records = {}
        self.send = send

    def accept(self, message):
        params = message.get("params", message)
        # Initial connection and missed-event recovery establish a baseline;
        # neither should replay notifications for old agent states.
        if "terminals" in params:
            self.records = {r["address"]: r for r in params["terminals"]}
            return
        if message.get("method") != "event":
            return
        address = params.get("terminal")
        kind = params.get("type")
        if not address:
            return
        if kind == "removed":
            self.records.pop(address, None)
            return
        data = params.get("data") or {}
        if kind in ("created", "restarted"):
            self.records[address] = data
            return
        record = self.records.setdefault(address, {})
        previous = (record.get("status") or {}).get("state")
        record.update(data.get("record", {}))
        record.update({k: v for k, v in data.items() if k != "record"})
        if kind != "status" or not record.get("labels", {}).get("herdr.space"):
            return
        status = record.get("status") or {}
        state = status.get("state")
        if state == previous:
            return
        busy = ("working", "blocked", "error")
        if state in ("blocked", "error") and previous not in ("blocked", "error"):
            action = "needs you" if state == "blocked" else "reported an error"
        elif state in ("done", "idle") and previous in busy:
            # Codex can finish a turn by reporting idle rather than done.
            action = "finished"
        else:
            return
        name = status.get("app") or record.get("name") or "Agent"
        name = {"codex": "Codex", "claude": "Claude"}.get(name, name)
        place = record.get("labels", {}).get("where") or record.get("cwd") or address
        title = status.get("title") or record.get("title") or ""
        body = "\n".join(html.escape(str(s)) for s in (place, title) if s)
        self.send(f"{name} {action}", body)


def send_notification(title, body):
    subprocess.run(
        [
            "notify-send", "--app-name=Herdr", "--icon=herdr-app",
            "--urgency=normal", "--expire-time=8000", "--", title, body,
        ],
        check=True,
        timeout=10,
    )


def main():
    listener = Notifications(send_notification)
    with subprocess.Popen(["hc", "events", "--json"], stdout=subprocess.PIPE, text=True) as core:
        for line in core.stdout:
            try:
                listener.accept(json.loads(line))
            except (ValueError, subprocess.SubprocessError) as error:
                print(f"Herdr notification: {error}", file=sys.stderr, flush=True)
        raise SystemExit(core.wait() or 1)


if __name__ == "__main__":
    main()
