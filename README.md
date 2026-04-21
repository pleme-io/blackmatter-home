# blackmatter-home

Home-level flake.nix provisioning — writes a minimal `~/flake.nix` that
`home-manager switch` can resolve, enabling per-user system management apps
without needing a checkout of the `nix` config repo.

## Usage

```nix
{
  inputs.blackmatter-home.url = "github:pleme-io/blackmatter-home";

  outputs = { blackmatter-home, ... }: {
    homeConfigurations.you = home-manager.lib.homeManagerConfiguration {
      modules = [
        blackmatter-home.homeManagerModules.default
        ({ ... }: {
          blackmatter.components.home.enable = true;
        })
      ];
    };
  };
}
```

## License

MIT
