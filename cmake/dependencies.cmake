# GLFW：源码内置，关闭示例/测试/文档
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(GLFW_INSTALL OFF CACHE BOOL "" FORCE)

# 仅影响 GLFW；learnopengl_glad 仍标为 STATIC，不受全局 BUILD_SHARED_LIBS 牵连
option(LEARNOPENGL_GLFW_SHARED "Build GLFW as a shared library (DLL / .so / .dylib)" ON)
if(LEARNOPENGL_GLFW_SHARED)
    set(GLFW_LIBRARY_TYPE "SHARED" CACHE STRING "GLFW library type" FORCE)
    if(WIN32)
        # 让 glfw3.dll 与 .exe 落在同一输出目录，避免运行时报找不到 DLL
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
    endif()
else()
    set(GLFW_LIBRARY_TYPE "" CACHE STRING "GLFW library type (empty = static)" FORCE)
endif()

add_subdirectory("${CMAKE_SOURCE_DIR}/third_party/glfw" "${CMAKE_BINARY_DIR}/third_party/glfw")

# GLAD：单独静态库，多个 demo 共用，避免重复编译 glad.c
set(LEARNOPENGL_GLAD_ROOT "${CMAKE_SOURCE_DIR}/third_party/glad")
add_library(learnopengl_glad STATIC "${LEARNOPENGL_GLAD_ROOT}/src/glad.c")
target_include_directories(learnopengl_glad PUBLIC "${LEARNOPENGL_GLAD_ROOT}/include")

# 统一的 OpenGL 运行库依赖：GLAD + GLFW + 平台系统库
add_library(learnopengl_graphics INTERFACE)
target_link_libraries(learnopengl_graphics INTERFACE learnopengl_glad glfw)
if(WIN32)
    target_link_libraries(learnopengl_graphics INTERFACE opengl32 gdi32)
endif()

# 为 src 下各章示例添加可执行目标（自动链接 learnopengl_graphics）
function(learnopengl_add_executable name)
    add_executable(${name} ${ARGN})
    target_link_libraries(${name} PRIVATE learnopengl_graphics)
endfunction()
