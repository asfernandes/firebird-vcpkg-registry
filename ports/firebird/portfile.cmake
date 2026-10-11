set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO FirebirdSQL/firebird
    REF v5.0.4
    SHA512 470e371733817b20d84a4dc45a23ca54fb82e150efbec17b3cd3e71d1867023c30dd0aaa83c807f4e03cf0403cd47eeb0b7df2a09a3be897a0f6dddc0bbeeb6a
    HEAD_REF master
    PATCHES
        windows-vs2026-build-files.patch
        windows-vs2026-build-script.patch
        static-build.patch
        windows-paths.patch
        windows-timeout.patch
        tomcrypt-link.patch
        osx-icu-rpath.patch
        osx-unvcpkg.patch
        without-cloop-generation.patch
        system-boost-posix.patch
        system-boost-windows.patch
        system-libs-windows.patch
        re2-string-view.patch
        tommath-api.patch
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
