set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    # FIXME:
    REPO asfernandes/firebird
    REF 468842eba588d6da0eab61b7fd2a75c0a6cdc94b
    SHA512 b75ba47e38145a4db64a1d1b2db253915e4d66c27e9c5eb7c901e866a4ae385801141d21cf1f77dfaf049c088349387b2501b9c2af361f0ceb6be8b522de0dc3
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
