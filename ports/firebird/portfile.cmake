set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    # FIXME:
    REPO asfernandes/firebird
    REF work/build-deps-v5
    SHA512 e887a0ddeb6243966773964a12fd73752e4a248fb4516ddb988ca2543e804bb86d1a21abde1a710739adf8a4eb742a46a8cd307aef2bea2048fa2c2b497c1734
    HEAD_REF master
    PATCHES
        static-build.patch
        windows-paths.patch
        osx-icu-rpath.patch
        osx-unvcpkg.patch
)

# Only decNumber, ttmath and ICU's tzdata are used from the bundled third-party sources.
file(GLOB FIREBIRD_EXTERN_DIRS LIST_DIRECTORIES true "${SOURCE_PATH}/extern/*" "${SOURCE_PATH}/extern/icu/*")
list(REMOVE_ITEM FIREBIRD_EXTERN_DIRS
    "${SOURCE_PATH}/extern/decNumber"
    "${SOURCE_PATH}/extern/ttmath"
    "${SOURCE_PATH}/extern/icu"
    "${SOURCE_PATH}/extern/icu/tzdata"
)
file(REMOVE_RECURSE ${FIREBIRD_EXTERN_DIRS})

if(VCPKG_TARGET_IS_WINDOWS)
    include("${CMAKE_CURRENT_LIST_DIR}/windows/portfile.cmake")
else()
    include("${CMAKE_CURRENT_LIST_DIR}/posix/portfile.cmake")
endif()

# Copy common files

file(
    INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)

vcpkg_install_copyright(
    FILE_LIST
        "${SOURCE_PATH}/builds/install/misc/IPLicense.txt"
        "${SOURCE_PATH}/builds/install/misc/IDPLicense.txt"
)

file(
    INSTALL "${CMAKE_CURRENT_LIST_DIR}/${PORT}-config.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)
