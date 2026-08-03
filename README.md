# Firebird vcpkg custom registry

This repository acts as a standalone Firebird-focused custom registry for
[vcpkg](https://github.com/microsoft/vcpkg). Besides the upstream `firebird` client port, it can host additional
third-party Firebird-related libraries so they can be consumed alongside the official vcpkg ports from Microsoft.

## Using the registry

1. Clone this repository somewhere accessible to your vcpkg checkout (or host it in a git location of your choice) and
   record the commit you want to pin:
   ```bash
   git clone https://github.com/asfernandes/firebird-vcpkg-registry.git
   cd firebird-vcpkg-registry
   git rev-parse HEAD
   ```
2. In your vcpkg or project root create or update `vcpkg-configuration.json` so vcpkg knows about the registry.
   Replace `<registry-path>` with either the git URL or local path you are using and `<baseline>` with the commit hash
   from the previous step.
   ```json
   {
     "default-registry": {
       "kind": "builtin",
       "baseline": "<official-vcpkg-baseline>"
     },
     "registries": [
       {
         "kind": "git",
         "repository": "https://github.com/asfernandes/firebird-vcpkg-registry.git",
         "baseline": "<baseline>",
         "packages": [ "firebird", "fb-cpp" ]
       }
     ]
   }
   ```
   Alternatively, this project can be used as an overlay declared in `vcpkg-configuration.json`:
   ```json
   {
	 "overlay-ports": [
	   "<registry-path>/ports"
	 ]
   }
   ```
3. Install the packages through vcpkg as usual:
   ```bash
   vcpkg install firebird
   ```
   (or use vcpkg manifest mode)

vcpkg will pull the port definition from this registry and build the Firebird client for the current triplet.

## Firebird port specifics

The `firebird` port follows the library linkage requested by the vcpkg triplet:

- A static triplet builds and links the Firebird client (`fbclient`) as a static library.
- A dynamic triplet builds and links `fbclient` as a shared library, which must be available at runtime.

For example, `x64-linux` selects static linkage and `x64-linux-dynamic` selects shared linkage. Use the equivalent
static or dynamic triplet for other target platforms.

Static client library support is available in Firebird's upstream `master` branch. This registry currently builds
Firebird v5.0.4, where it is not yet present, so the v5 port carries the support as
`ports/firebird/static-build.patch`.

The client can also load dependencies dynamically—most notably `icu` for time-zone handling—so those dependencies must
be available as dynamic libraries or Firebird will fail to load them.

To keep the rest of your dependencies static while turning on a dynamic build for `icu`, create an overlay triplet, for
example:
```
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Linux)

if(PORT MATCHES "^(icu)$")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
```

Point your `cmake`/`vcpkg` invocation to the custom triplet so the build picks up the overrides.

A more complete example of this configuration can be  found in the [fb-cpp](https://github.com/asfernandes/fb-cpp)
repository.

## Ports available
- `firebird`: The Firebird client library ([example](examples/firebird))
- `fb-cpp`: A modern C++ wrapper for the Firebird database API ([example](examples/fb-cpp))


# Updating ports

To update all port versions after making changes to the portfiles, run the following command:
```
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose
```
