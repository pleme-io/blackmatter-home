# Home

macOS developer workstation managed by nix-darwin + home-manager.

## Workspace Structure

All source code lives under `~/code/` following a strict directory convention:

```
~/code/${git-service}/${org-or-user}/${repo}
```

Each level has its own `CLAUDE.md` with progressively more specific guidance.
Managed `flake.nix` files at each level provide `nix run .#<app>` commands.

## Key Commands

| Command | Where | What |
|---------|-------|------|
| `nix run .#rebuild` | `~/` | Rebuild darwin system |
| `nix run .#tend-status` | any level | Repo sync status |
| `nix run .#sync-all` | `~/code/` | Sync all workspaces |
| `tend status` | anywhere | All workspace status |
| `tend sync` | anywhere | Clone missing repos |

## System Management

- **Nix config:** `~/code/github/pleme-io/nix` (private, SOPS-encrypted secrets)
- **Rebuild:** `cd ~/code/github/pleme-io/nix && nix run .#rebuild`
- **Secrets:** `cd ~/code/github/pleme-io/nix && sops secrets.yaml`
- **Blackmatter:** Modular HM/darwin framework, profiles select components

## Tool Stack

| Tool | Purpose |
|------|---------|
| `tend` | Workspace repo sync, flake updates, version watch |
| `zoekt-mcp` | Trigram code search (MCP) |
| `codesearch` | Semantic code search (MCP) |
| `nix-place` | Managed flake.nix composition |
