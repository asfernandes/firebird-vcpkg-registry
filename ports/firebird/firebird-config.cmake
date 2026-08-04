if(TARGET firebird)
    return()
endif()

include(CMakeFindDependencyMacro)

set(_FIREBIRD_ROOT "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}")
set(_FIREBIRD_ROOT_DEBUG "${_FIREBIRD_ROOT}/debug")
set(_FIREBIRD_INCLUDE_DIR "${_FIREBIRD_ROOT}/include")
set(_FIREBIRD_LIB_DIR "${_FIREBIRD_ROOT}/lib")
set(_FIREBIRD_LIB_DIR_DEBUG "${_FIREBIRD_ROOT_DEBUG}/lib")
set(_FIREBIRD_BIN_DIR "${_FIREBIRD_ROOT}/bin")
set(_FIREBIRD_BIN_DIR_DEBUG "${_FIREBIRD_ROOT_DEBUG}/bin")

set(_FIREBIRD_SHARED_FILENAME "")

if(NOT WIN32)
    if(EXISTS "${_FIREBIRD_LIB_DIR}/libfbclient.a")
        set(_FIREBIRD_SHARED_FILENAME "libfbclient.a")
    else()
        foreach(_FIREBIRD_SHARED_CANDIDATE libfbclient.so libfbclient.dylib)
            if(EXISTS "${_FIREBIRD_LIB_DIR}/${_FIREBIRD_SHARED_CANDIDATE}")
                set(_FIREBIRD_SHARED_FILENAME "${_FIREBIRD_SHARED_CANDIDATE}")
                break()
            endif()
        endforeach()
    endif()
endif()

if((NOT WIN32 AND EXISTS "${_FIREBIRD_LIB_DIR}/libfbclient.a") OR
   (WIN32 AND EXISTS "${_FIREBIRD_LIB_DIR}/fbclient_static_ms.lib"))
    add_library(firebird STATIC IMPORTED)

    find_library(_FIREBIRD_TOMMATH_RELEASE
        NAMES tommath tommathd
        PATHS "${_FIREBIRD_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )

    find_library(_FIREBIRD_TOMMATH_DEBUG
        NAMES tommath tommathd
        PATHS "${_FIREBIRD_LIB_DIR_DEBUG}"
        NO_DEFAULT_PATH
    )

    if(NOT _FIREBIRD_TOMMATH_DEBUG)
        set(_FIREBIRD_TOMMATH_DEBUG "${_FIREBIRD_TOMMATH_RELEASE}")
    endif()

    if(NOT WIN32)
        find_dependency(Threads)

        if(APPLE)
            find_library(_FIREBIRD_ICONV iconv REQUIRED)
            find_library(_FIREBIRD_OBJC objc REQUIRED)
            find_library(_FIREBIRD_COREFOUNDATION CoreFoundation REQUIRED)
            find_library(_FIREBIRD_FOUNDATION Foundation REQUIRED)
            find_library(_FIREBIRD_SECURITY Security REQUIRED)
        endif()
    endif()
else()
    add_library(firebird SHARED IMPORTED)
endif()

set_target_properties(firebird PROPERTIES
    IMPORTED_CONFIGURATIONS "DEBUG;RELEASE"
    INTERFACE_INCLUDE_DIRECTORIES "${_FIREBIRD_INCLUDE_DIR}"
)

if(WIN32)
    set(_FIREBIRD_LIB_RELEASE "${_FIREBIRD_LIB_DIR}/fbclient_static_ms.lib")
    set(_FIREBIRD_LIB_DEBUG "${_FIREBIRD_LIB_DIR_DEBUG}/fbclient_static_ms.lib")

    if(EXISTS "${_FIREBIRD_LIB_RELEASE}")
        set_target_properties(firebird PROPERTIES
            IMPORTED_LOCATION_RELEASE "${_FIREBIRD_LIB_RELEASE}"
            IMPORTED_LOCATION_DEBUG "${_FIREBIRD_LIB_DEBUG}"
        )
    else()
        set(_FIREBIRD_IMPLIB_RELEASE "${_FIREBIRD_LIB_DIR}/fbclient_ms.lib")
        set(_FIREBIRD_IMPLIB_DEBUG "${_FIREBIRD_LIB_DIR_DEBUG}/fbclient_ms.lib")
        if(NOT EXISTS "${_FIREBIRD_IMPLIB_DEBUG}")
            set(_FIREBIRD_IMPLIB_DEBUG "${_FIREBIRD_IMPLIB_RELEASE}")
        endif()

        set(_FIREBIRD_DLL_RELEASE "${_FIREBIRD_BIN_DIR}/fbclient.dll")
        set(_FIREBIRD_DLL_DEBUG "${_FIREBIRD_BIN_DIR_DEBUG}/fbclient.dll")
        if(NOT EXISTS "${_FIREBIRD_DLL_DEBUG}")
            set(_FIREBIRD_DLL_DEBUG "${_FIREBIRD_DLL_RELEASE}")
        endif()

        set_target_properties(firebird PROPERTIES
            IMPORTED_IMPLIB_RELEASE "${_FIREBIRD_IMPLIB_RELEASE}"
            IMPORTED_IMPLIB_DEBUG "${_FIREBIRD_IMPLIB_DEBUG}"
            IMPORTED_LOCATION_RELEASE "${_FIREBIRD_DLL_RELEASE}"
            IMPORTED_LOCATION_DEBUG "${_FIREBIRD_DLL_DEBUG}"
        )
    endif()
else()
    set(_FIREBIRD_SHARED_RELEASE "${_FIREBIRD_LIB_DIR}/${_FIREBIRD_SHARED_FILENAME}")
    set(_FIREBIRD_SHARED_DEBUG "${_FIREBIRD_LIB_DIR_DEBUG}/${_FIREBIRD_SHARED_FILENAME}")
    if(NOT EXISTS "${_FIREBIRD_SHARED_DEBUG}")
        set(_FIREBIRD_SHARED_DEBUG "${_FIREBIRD_SHARED_RELEASE}")
    endif()

    set_target_properties(firebird PROPERTIES
        IMPORTED_LOCATION_RELEASE "${_FIREBIRD_SHARED_RELEASE}"
        IMPORTED_LOCATION_DEBUG "${_FIREBIRD_SHARED_DEBUG}"
    )
endif()

if(APPLE AND _FIREBIRD_SHARED_FILENAME STREQUAL "libfbclient.a")
    set_property(TARGET firebird APPEND PROPERTY
        INTERFACE_LINK_OPTIONS "-Wl,-rpath,$<TARGET_FILE_DIR:firebird>"
    )
endif()

if(_FIREBIRD_TOMMATH_RELEASE)
    set_property(TARGET firebird APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES
            "$<$<CONFIG:Debug>:${_FIREBIRD_TOMMATH_DEBUG}>"
            "$<$<NOT:$<CONFIG:Debug>>:${_FIREBIRD_TOMMATH_RELEASE}>"
    )

    if(NOT WIN32)
        set_property(TARGET firebird APPEND PROPERTY
            INTERFACE_LINK_LIBRARIES
                Threads::Threads
                ${CMAKE_DL_LIBS}
        )

        if(APPLE)
            set_property(TARGET firebird APPEND PROPERTY
                INTERFACE_LINK_LIBRARIES
                    ${_FIREBIRD_ICONV}
                    ${_FIREBIRD_OBJC}
                    ${_FIREBIRD_COREFOUNDATION}
                    ${_FIREBIRD_FOUNDATION}
                    ${_FIREBIRD_SECURITY}
            )
        endif()
    endif()

    if(WIN32)
        set_property(TARGET firebird APPEND PROPERTY
            INTERFACE_LINK_LIBRARIES
                advapi32
                bcrypt
                legacy_stdio_definitions
                mpr
                ole32
                psapi
                shell32
                user32
                ws2_32
        )
    endif()
endif()
