_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.base = with config._module.args.pkgs; [
        git
        git-lfs
        gh
        lazygit
        curl
        wget
        btop
        bat
        ripgrep
        fd
        fzf
        jq
        just
        tmux
        luaPackages.luacheck
        markdownlint-cli
        (writeShellScriptBin "update-ai-packages" ''
          set -euo pipefail

          repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
          cd "$repo_root"

          echo "Updating opencode source pin..."
          nix flake update opencode-src

          echo "Updating codex release pin..."
          latest_tag=$(curl -s https://api.github.com/repos/openai/codex/releases/latest | jq -r .tag_name)
          version=''${latest_tag#rust-v}
          url="https://github.com/openai/codex/releases/download/''${latest_tag}/codex-x86_64-unknown-linux-gnu.tar.gz"
          hash=$(nix store prefetch-file --json "$url" | jq -r .hash)

          codex_file="$repo_root/modules/features/ai/codex.nix"
          sed -i "s/version = \".*\";/version = \"''${version}\";/" "$codex_file"
          sed -i "s|url = \".*codex-x86_64-unknown-linux-gnu.tar.gz\";|url = \"''${url}\";|" "$codex_file"
          sed -i "s/hash = \"sha256-[^\"]*\";/hash = \"''${hash}\";/" "$codex_file"

          echo "codex updated to ''${version}"
        '')
      ];
    };
}
