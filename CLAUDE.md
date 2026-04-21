# blackmatter-home — Claude Orientation

One-sentence purpose: home-manager module that writes a tiny `~/flake.nix`
so users can run `home-manager switch --flake ~` without checking out the
`nix` config repo.

## Classification

- **Archetype:** `blackmatter-component-hm-only`
- **Flake shape:** `substrate/lib/blackmatter-component-flake.nix`
- **Option namespace:** `blackmatter.components.home`

## What NOT to do

- Don't bake user-specific paths or identity into the generated flake body.
  The module renders a template; concrete data comes from the consumer.
