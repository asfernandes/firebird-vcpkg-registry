include(GNUInstallDirs)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

set(_vcpkg_prefix "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}")


# Release configurations

install(DIRECTORY "${_vcpkg_prefix}/bin/"
    DESTINATION "${CMAKE_INSTALL_BINDIR}"
    CONFIGURATIONS Release RelWithDebInfo MinSizeRel
    USE_SOURCE_PERMISSIONS
    OPTIONAL
)

install(DIRECTORY "${_vcpkg_prefix}/lib/"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    CONFIGURATIONS Release RelWithDebInfo MinSizeRel
    USE_SOURCE_PERMISSIONS
    OPTIONAL
    PATTERN "*.a" EXCLUDE
    PATTERN "*.lib" EXCLUDE
    PATTERN "cmake" EXCLUDE
    PATTERN "pkgconfig" EXCLUDE
)

install(DIRECTORY "${_vcpkg_prefix}/plugins/"
    DESTINATION "plugins"
    CONFIGURATIONS Release RelWithDebInfo MinSizeRel
    USE_SOURCE_PERMISSIONS
    OPTIONAL
)

install(DIRECTORY "${_vcpkg_prefix}/share/firebird/"
    DESTINATION "share/firebird"
    CONFIGURATIONS Release RelWithDebInfo MinSizeRel
    USE_SOURCE_PERMISSIONS
    OPTIONAL
    PATTERN "*.cmake" EXCLUDE
    PATTERN "usage*" EXCLUDE
    PATTERN "vcpkg*" EXCLUDE
)


# Debug configuration

install(DIRECTORY "${_vcpkg_prefix}/debug/bin/"
    DESTINATION "debug/${CMAKE_INSTALL_BINDIR}"
    CONFIGURATIONS Debug
    USE_SOURCE_PERMISSIONS
    OPTIONAL
)

install(DIRECTORY "${_vcpkg_prefix}/debug/lib/"
    DESTINATION "debug/${CMAKE_INSTALL_LIBDIR}"
    CONFIGURATIONS Debug
    USE_SOURCE_PERMISSIONS
    OPTIONAL
    PATTERN "*.a" EXCLUDE
    PATTERN "*.lib" EXCLUDE
    PATTERN "cmake" EXCLUDE
    PATTERN "pkgconfig" EXCLUDE
)

install(DIRECTORY "${_vcpkg_prefix}/debug/plugins/"
    DESTINATION "debug/plugins"
    CONFIGURATIONS Debug
    USE_SOURCE_PERMISSIONS
    OPTIONAL
)

install(DIRECTORY "${_vcpkg_prefix}/debug/share/firebird/"
    DESTINATION "debug/share/firebird"
    CONFIGURATIONS Debug
    USE_SOURCE_PERMISSIONS
    OPTIONAL
    PATTERN "*.cmake" EXCLUDE
    PATTERN "usage*" EXCLUDE
    PATTERN "vcpkg*" EXCLUDE
)
