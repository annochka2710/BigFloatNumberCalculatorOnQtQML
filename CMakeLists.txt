cmake_minimum_required(VERSION 3.16)

project(Calculator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find all required Qt6 components at once
find_package(Qt6 REQUIRED COMPONENTS Quick Core)
#установите свою директорию
set(BOOST_INCLUDE_DIR "C:/Users/annochka27/boost/boost_1_66_0" CACHE PATH "Boost include directory")

if(NOT EXISTS "${BOOST_INCLUDE_DIR}/boost/multiprecision/cpp_dec_float.hpp")
    message(WARNING "Boost multiprecision not found at: ${BOOST_INCLUDE_DIR}")
    message(STATUS "Please check the BOOST_INCLUDE_DIR path")
endif()

message(STATUS "Using Boost from: ${BOOST_INCLUDE_DIR}")

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCalculator
    main.cpp
    calculator.h
    calculator.cpp
)

target_include_directories(appCalculator PRIVATE
    ${BOOST_INCLUDE_DIR}
)

qt_add_qml_module(appCalculator
    URI Calculator
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ImageButton.qml
        qml/TextButton.qml
        qml/Fonts.qml
        qml/Theme.qml
        qml/NumberButton.qml
        qml/OperationButton.qml
        qml/SecretWindow.qml
    RESOURCES
        images/status.png
        images/button/action/active.png
        images/button/action/normal.png
        images/button/cancel/active.png
        images/button/cancel/normal.png
        images/button/simple/active.png
        images/button/simple/normal.png
        images/icon/30/bkt.png
        images/icon/30/division.png
        images/icon/30/equal.png
        images/icon/30/minus.png
        images/icon/30/multiplication.png
        images/icon/30/percent.png
        images/icon/30/plus.png
        images/icon/30/plus_minus.png
    SOURCES
        calculator.h
        calculator.cpp
)

set_target_properties(appCalculator PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCalculator
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Link all Qt6 components at once
target_link_libraries(appCalculator PRIVATE
    Qt6::Quick
    Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS appCalculator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
