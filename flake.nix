{
  description = "My personal website";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      shell = pkgs.mkShell {
        buildInputs = [
          pkgs.pandoc
        ];
      };
    in
      {
        devShell = shell;
        packages.x86_64-linux.cxandru_ee = shell;
        defaultPackage.x86_64-linux = self.packages.x86_64-linux.cxandru_ee;
      };
}
