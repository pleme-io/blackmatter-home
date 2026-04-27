# blackmatter-home — Claude Orientation

> **★★★ CSE / Knowable Construction.** This repo operates under **Constructive Substrate Engineering** — canonical specification at [`pleme-io/theory/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md`](https://github.com/pleme-io/theory/blob/main/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md). The Compounding Directive (operational rules: solve once, load-bearing fixes only, idiom-first, models stay current, direction beats velocity) is in the org-level pleme-io/CLAUDE.md ★★★ section. Read both before non-trivial changes.


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
