vcpkg_acquire_msys(MSYS_ROOT PACKAGES unzip)
vcpkg_add_to_path(${MSYS_ROOT}/usr/bin)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(FB_ARCH_OUT "Win32")
    set(FB_PROCESSOR_ARCHITECTURE "x86")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(FB_ARCH_OUT "x64")
    set(FB_PROCESSOR_ARCHITECTURE "AMD64")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(FB_ARCH_OUT "arm64")
    set(FB_PROCESSOR_ARCHITECTURE "ARM64")
endif()


# Release build

vcpkg_execute_build_process(
    COMMAND ${CMAKE_COMMAND} -E env
        "FB_PROCESSOR_ARCHITECTURE=${FB_PROCESSOR_ARCHITECTURE}"
        run_all.bat
        JUSTBUILD
        RELEASE
        CLIENT_ONLY
    WORKING_DIRECTORY "${SOURCE_PATH}/builds/win32"
    LOGNAME configure-${TARGET_TRIPLET}-rel
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_release/include"
    DESTINATION "${CURRENT_PACKAGES_DIR}"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_release/lib/fbclient_ms.lib"
    DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_release/fbclient.dll"
    DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
)

file(
    INSTALL "${SOURCE_PATH}/temp/${FB_ARCH_OUT}/release/yvalve/fbclient.pdb"
    DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
)

file(GLOB PLUGINS_FILES_RELEASE
    "${SOURCE_PATH}/output_${FB_ARCH_OUT}_release/plugins/*"
)
file(
    INSTALL ${PLUGINS_FILES_RELEASE}
    DESTINATION "${CURRENT_PACKAGES_DIR}/plugins/${PORT}"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_release/firebird.msg"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_release/tzdata"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)


# Debug build

vcpkg_execute_build_process(
    COMMAND ${CMAKE_COMMAND} -E env
        "FB_PROCESSOR_ARCHITECTURE=${FB_PROCESSOR_ARCHITECTURE}"
        run_all.bat
        JUSTBUILD
        DEBUG
        CLIENT_ONLY
    WORKING_DIRECTORY "${SOURCE_PATH}/builds/win32"
    LOGNAME configure-${TARGET_TRIPLET}-dbg
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_debug/lib/fbclient_ms.lib"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_debug/fbclient.dll"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
)

file(
    INSTALL "${SOURCE_PATH}/temp/${FB_ARCH_OUT}/debug/yvalve/fbclient.pdb"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
)

file(GLOB PLUGINS_FILES_DEBUG
    "${SOURCE_PATH}/output_${FB_ARCH_OUT}_debug/plugins/*"
)
file(
    INSTALL ${PLUGINS_FILES_DEBUG}
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/plugins/${PORT}"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_debug/firebird.msg"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/share/${PORT}"
)

file(
    INSTALL "${SOURCE_PATH}/output_${FB_ARCH_OUT}_debug/tzdata"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/share/${PORT}"
)
