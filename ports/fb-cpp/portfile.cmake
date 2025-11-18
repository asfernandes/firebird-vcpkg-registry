vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO asfernandes/fb-cpp
    REF v0.0.1
    SHA512 fc90ea3b2bf338344e2d8b81d1d700a26591432dacf594dbae5f1fa726f48e870db2d3c52b7e68549998e7aebf089ccaa34d5169e0c49dc82bc67a34af52ab83
    HEAD_REF main
)

set(FB_CPP_USE_BOOST_DLL_VALUE 0)
set(FB_CPP_USE_BOOST_DLL_OPTION OFF)
if("boost-dll" IN_LIST FEATURES)
    set(FB_CPP_USE_BOOST_DLL_VALUE 1)
    set(FB_CPP_USE_BOOST_DLL_OPTION ON)
endif()

set(FB_CPP_USE_BOOST_MULTIPRECISION_VALUE 0)
set(FB_CPP_USE_BOOST_MULTIPRECISION_OPTION OFF)
if("boost-multiprecision" IN_LIST FEATURES)
    set(FB_CPP_USE_BOOST_MULTIPRECISION_VALUE 1)
    set(FB_CPP_USE_BOOST_MULTIPRECISION_OPTION ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DFB_CPP_USE_BOOST_DLL=${FB_CPP_USE_BOOST_DLL_OPTION}
        -DFB_CPP_USE_BOOST_MULTIPRECISION=${FB_CPP_USE_BOOST_MULTIPRECISION_OPTION}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH "fb-cpp/cmake/${PORT}")

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}")
configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake.in"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/vcpkg-cmake-wrapper.cmake"
    @ONLY
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
