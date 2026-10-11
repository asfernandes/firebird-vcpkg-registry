set(VCPKG_POLICY_ALLOW_DEBUG_SHARE enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    # FIXME:
    REPO asfernandes/firebird
    REF 092afce9b2ad9ebf4aaa29164eed2ffa97f83032
    SHA512 4ed303a9a71910f1c8d9511f6251ac22047ff52fb9cba0e45639b5842811b4cd654b55f5f8f54556b4dc90dac20cddfdc6792f4fc56439cb27575898d74053f4
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
