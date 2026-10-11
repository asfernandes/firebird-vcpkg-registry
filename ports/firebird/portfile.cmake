set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    # FIXME:
    REPO asfernandes/firebird
    REF work/win-arm64
    SHA512 a8c6e4ff3974b6c6cffb02d03f2eff59114f2b5b49b7b93d23b3182134b61b258becb3f75fc71da2ea9e52f4043830766c37715b22be8d70938c7284fd0a1977
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
