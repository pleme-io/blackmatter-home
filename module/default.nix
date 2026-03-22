# Home-level management module
#
# Declares flake fragments for ~/ with system management apps.
# Note: git init at ~ is skipped — nix-place writes flake.nix without git tracking.
{ lib, config, ... }:
with lib;
let
  cfg = config.blackmatter.components.home;
in {
  options.blackmatter.components.home = {
    enable = mkEnableOption "Home-level flake.nix with system management apps";

    nixRepoPath = mkOption {
      type = types.str;
      default = "~/code/github/pleme-io/nix";
      description = "Path to the nix configuration repo (for rebuild and secrets-edit apps)";
    };

    managedFlakeDirs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Directories containing managed flake.nix files to validate in flake-health.
        Populated automatically from blackmatter.flakeFragments keys.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Auto-populate managed flake dirs from the fragment registry
    blackmatter.components.home.managedFlakeDirs = let
      homeDir = config.home.homeDirectory;
      fragmentKeys = attrNames config.blackmatter.flakeFragments;
    in map (key: if key == "" then homeDir else "${homeDir}/${key}") fragmentKeys;

    blackmatter.flakeFragments."" = [
      {
        id = "home-management";
        apps = {
          rebuild = {
            description = "Rebuild darwin system from nix repo";
            script = ''
              echo "Rebuilding darwin system..."
              cd ${cfg.nixRepoPath}
              nix run .#darwin-rebuild
            '';
          };
          rebuild-dry = {
            description = "Dry-run rebuild";
            script = ''
              echo "Dry-run rebuild..."
              cd ${cfg.nixRepoPath}
              nix run .#darwin-rebuild -- --dry-run
            '';
          };
          secrets-edit = {
            description = "Edit SOPS secrets";
            script = ''
              cd ${cfg.nixRepoPath}
              sops secrets.yaml
            '';
          };
          system-status = {
            description = "Host, nix version, disk, uptime";
            script = ''
              echo "System status:"
              echo "--------------------------------------------"
              printf "  Host:       %s\n" "$(hostname)"
              printf "  Nix:        %s\n" "$(nix --version)"
              printf "  Uptime:    %s\n" "$(uptime | sed 's/.*up /  /' | sed 's/,.*//')"
              printf "  Disk:      %s\n" "$(df -h / | tail -1 | awk '{print $4 " free of " $2}')"
              printf "  Nix store: %s\n" "$(du -sh /nix/store 2>/dev/null | cut -f1)"
            '';
          };
          tend-status = {
            description = "All workspace sync status (via tend)";
            script = "tend status";
          };
          flake-health = {
            description = "Verify all managed flake.nix files parse";
            script = let
              checks = concatMapStringsSep "\n" (dir: ''
                if [ -f "${dir}/flake.nix" ]; then
                  if nix flake show "${dir}" --no-write-lock-file >/dev/null 2>&1; then
                    printf "  %-50s OK\n" "${dir}"
                  else
                    printf "  %-50s FAIL\n" "${dir}"
                    failed=$((failed + 1))
                  fi
                fi
              '') cfg.managedFlakeDirs;
            in ''
              echo "Flake health check:"
              echo "--------------------------------------------"
              failed=0
              ${checks}
              [ $failed -eq 0 ] && echo "All flakes healthy." || { echo "$failed flake(s) failed."; exit 1; }
            '';
          };
        };
      }
    ];
  };
}
