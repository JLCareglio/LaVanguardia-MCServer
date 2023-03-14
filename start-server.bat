@echo off
rem Asignar el nombre del subdirectorio a una variable
set subdir=lavanguardia\
rem Leer el archivo motd-list.yml y guardar los mensajes en una variable
setlocal EnableDelayedExpansion
set i=0
for /f "skip=1 delims=" %%a in (motd-list.yml) do (
  set /a i+=1
  set motd[!i!]=%%a
)
rem Leer el motd actual del archivo server.properties y guardarlo en una variable
for /f "tokens=2 delims==" %%a in ('findstr /i "motd" %subdir%server.properties') do (
  set current_motd=%%a
)
rem Generar un número aleatorio entre 1 y el número de mensajes
set /a n=%random% %% i + 1
rem Comparar el mensaje elegido con el motd actual y generar otro número si son iguales
:loop
if "!motd[%n%]!"=="!current_motd!" (
  set /a n=%random% %% i + 1
  goto loop
)
rem Cambiar el MOTD del archivo server.properties por el mensaje elegido
(for /f "tokens=1* delims==" %%a in (%subdir%server.properties) do (
  if "%%a"=="motd" (
    echo motd=!motd[%n%]!
  ) else (
    echo %%a=%%b
  )
)) > %subdir%server.properties.tmp
move /y %subdir%server.properties.tmp %subdir%server.properties

rem Contar el número de archivos png en la carpeta "server-icons"
set j=0
for %%a in ("server-icons\*.png") do (
  set /a j+=1
)
rem Generar un número aleatorio entre 1 y el número de archivos png
set /a m=%random% %% j + 1
rem Copiar y renombrar el archivo png elegido como server-icon.png dentro de la subcarpeta "lavanguardia"
set k=0
for %%a in ("server-icons\*.png") do (
  set /a k+=1
  if !k!==!m! (
    xcopy "%%a" "%subdir%server-icon.png" /y
  )
)

rem Cambiar al directorio "lavanguardia" y ejecutar el comando java al final
cd %subdir% && java -Xmx4G -Xms1024M -jar purpur-1.19.3-1930.jar --nogui
