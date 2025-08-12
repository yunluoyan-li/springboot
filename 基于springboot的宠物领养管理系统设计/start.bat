@echo off
echo 正在启动宠物领养系统...
echo.

REM 检查Java是否安装
java -version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到Java，请确保已安装Java并配置环境变量
    pause
    exit /b 1
)

REM 检查Maven是否安装
mvn -version >nul 2>&1
if errorlevel 1 (
    echo 警告: 未找到Maven，尝试使用Java直接启动...
    echo.
    
    REM 尝试使用Java直接启动
    cd target\classes
    java -cp ".;..\dependency\*" com.example.petadoption.PetAdoptionApplication
    if errorlevel 1 (
        echo 错误: 启动失败，请检查依赖项
        pause
        exit /b 1
    )
) else (
    echo 使用Maven启动应用程序...
    echo.
    mvn spring-boot:run
)

echo.
echo 应用程序启动完成！
echo 访问地址: http://localhost:8080
echo.
pause 