set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# MinGW：与 GLFW / Windows 头文件配合时建议定义 UNICODE（GLFW 源码侧也会处理）
if(MINGW)
    add_compile_definitions(UNICODE _UNICODE)
endif()
