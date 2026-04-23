{
  description = "Python development environment with aiohttp";

  inputs = {
    # Using the stable nixpkgs branch
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems to support
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for each system
      nixpkgsFor = forAllSystems (system: import nixpkgs { 
        inherit system; 
        config = { allowUnfree = true; };
      });
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          
          # Define your Python environment
          pythonEnv = pkgs.python3.withPackages (ps: with ps; [
            aiohttp
            ipykernel
            # You can add more packages here, e.g.,
            # requests
            # pytest
          ]);
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pythonEnv
              pkgs.ngrok
            ];

            # Optional: Shell commands to run upon entering the environment
            shellHook = ''
              echo "🐍 Python dev shell"
              python --version
            '';
          };
        });
    };
}