
######### CONTENIDO #########

Para descomprimir el instalador utilizar el siguiente comando:
tar -zxvf filename.tgz

El mismo creará la carpeta Grupo07 que contendrá los siguientes archivos:
Instalep
Initep
Logep
Movep
Demonep
Stop_Daemon
/dirconf 
/Datos (directorio con tablas y maestros)


######### REQUISITOS #########
-El usuario debe tener permiso de escritura sobre el directorio.


######### INSTALACION #########

Para instalar el sistema ubicarse en el directorio GRUPO07 y ejecute: 
./Instalep
Luego seguir los pasos indicados en la pantalla que lo guiarán en la instalación del sistema EPLAM

Si el proceso de instalación finaliza correctamente se crearán los siguientes directorios (los nombres pueden ser modificados durante el proceso de instalación).
bin (incluye los ejecutables)
imp
log
mae (incluye el set de datos)
nok
nov
ok
rep
/dirconf/Instalep.conf
/dirconf/Instalep.log
/bkp_datos (backup del set de datos)


######### EJECUCIÓN #########
Antes de ejecutar el sistema deberá inicializarlo mediante el proceso Initep, para eso deberá ejecutar, desde el directorio raíz, el siguiente comando:
. ./Initep dirconf/Instalep.conf

Una vez inicializada la aplicación podrá lanzar el proceso Demonep con el comando:
./Demonep &

En caso de querer detener el proceso Demonep deberá ejecutar:
./Stop_Daemon Demonep
