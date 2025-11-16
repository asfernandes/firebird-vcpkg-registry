# Firebird vcpkg custom registry

This repository packages the upstream Firebird client library as a standalone
custom registry for [vcpkg](https://github.com/microsoft/vcpkg). It exposes a
single port, `firebird`, that can be consumed alongside the official vcpkg
ports from Microsoft.

## Using the registry

1. Clone this repository somewhere accessible to your vcpkg checkout (or host
   it in a git location of your choice) and record the commit you want to pin:
   ```bash
   git clone https://github.com/asfernandes/firebird-vcpkg-registry.git
   cd firebird-vcpkg-registry
   git rev-parse HEAD
   ```
2. In your vcpkg or project root create or update `vcpkg-configuration.json`
   so vcpkg knows about the registry. Replace `<registry-path>` with either the
   git URL or local path you are using and `<baseline>` with the commit hash
   from the previous step.
   ```json
   {
     "default-registry": {
       "kind": "git",
       "repository": "https://github.com/microsoft/vcpkg",
       "baseline": "<official-vcpkg-baseline>"
     },
     "registries": [
       {
         "kind": "git",
         "repository": "https://github.com/asfernandes/firebird-vcpkg-registry.git",
         "baseline": "<baseline>",
         "packages": [ "firebird" ]
       }
     ]
   }
   ```
3. Install the Firebird client library through vcpkg as usual:
   ```bash
   ./vcpkg install firebird
   ```

vcpkg will pull the port definition from this registry and build the Firebird
client for the current triplet.
