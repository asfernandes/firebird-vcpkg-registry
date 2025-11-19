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
       "kind": "git",
       "repository": "https://github.com/microsoft/vcpkg",
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
   alternatively, this project can be used as an overlay declared in `vcpkg-configuration.json`:
   ```json
   {
	 "overlay-ports": [
	   "<registry-path>/ports"
	 ]
   }
   ```
3. Install the packages through vcpkg as usual:
   ```bash
   ./vcpkg install firebird
   ```
   (or use vcpkg manifest mode)

vcpkg will pull the port definition from this registry and build the Firebird client for the current triplet.

## Firebird port specifics

The upstream Firebird client only ships as a shared library, so the `firebird` port in this registry always produces
`fbclient` as a dynamic library regardless of the selected triplet. Most vcpkg triplets default to static builds on
Linux/macOS, which creates two important implications:

- You can safely depend on `firebird` from static builds of your project as long as you load the produced shared library
  at runtime.
- Dependencies that Firebird needs to load dynamically—most notably `icu` for time-zone handling—must also be available
  as dynamic libraries or Firebird will fail to load it.

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
