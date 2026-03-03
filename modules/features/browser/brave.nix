_: {
  flake.modules.nixos.browser-brave =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.brave
      ];

      environment.etc."brave/policies/managed/workstation-browser.json".text = builtins.toJSON {
        PasswordManagerEnabled = false;
        MetricsReportingEnabled = false;
        HomepageIsNewTabPage = true;
        RestoreOnStartup = 4;
        ExtensionInstallForcelist = [
          "ghmbeldphafepmbegfdlkpapadhbakde;https://clients2.google.com/service/update2/crx"
          "ophjlpahpchlmihnnnihgmmeilfjmjjc;https://clients2.google.com/service/update2/crx"
          "hfjbmagddngcpeloejdejnfgbamkjaeg;https://clients2.google.com/service/update2/crx"
        ];
        ExtensionSettings = {
          bnaffjbjpgiagpondjlnneblepbdchol = {
            installation_mode = "blocked";
          };
        };
      };
    };

  flake.modules.homeManager.browser-brave =
    {
      lib,
      ...
    }:
    {
      programs.chromium = {
        enable = true;
      };

      home.activation.braveDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              prefs_file="$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences"

              if [ ! -f "$prefs_file" ]; then
                exit 0
              fi

              tmp_file="$(mktemp)"

              python3 - "$prefs_file" "$tmp_file" <<'PY'
        import json
        import sys

        prefs_file = sys.argv[1]
        tmp_file = sys.argv[2]

        with open(prefs_file, "r", encoding="utf-8") as f:
            prefs = json.load(f)

        prefs.setdefault("brave", {}).setdefault("tabs", {})["vertical_tabs_enabled"] = True
        prefs["brave"]["tabs"]["vertical_tabs_collapsed"] = False

        account_values = prefs.setdefault("account_values", {})

        toolbar = account_values.setdefault("toolbar", {})
        toolbar["pinned_actions"] = [
            "kActionShowDownloads",
            "kActionCopyUrl",
            "kActionTabSearch",
            "kActionSendTabToSelf",
            "kActionDevTools",
        ]

        extensions = account_values.setdefault("extensions", {})
        extensions["pinned_extensions"] = [
            "ghmbeldphafepmbegfdlkpapadhbakde",  # Proton Pass
            "ophjlpahpchlmihnnnihgmmeilfjmjjc",  # LINE
            "hfjbmagddngcpeloejdejnfgbamkjaeg",  # Vimium C
        ]

        with open(tmp_file, "w", encoding="utf-8") as f:
            json.dump(prefs, f, separators=(",", ":"))
        PY

              mv "$tmp_file" "$prefs_file"
      '';
    };
}
