# WalletTransfer API

## Descripción del Proyecto

WalletTransfer API es una solución desarrollada en .NET 8 siguiendo el patrón de Clean Architecture para gestionar transferencias de saldo. La API permite realizar operaciones CRUD sobre billeteras y registrar el historial de movimientos (transacciones) asociadas a cada billetera. Además, se implementa autenticación JWT para proteger los endpoints críticos.

## Características Principales

- **Operaciones CRUD sobre billeteras:** Crear, leer, actualizar y eliminar billeteras.
- **Registro de transacciones:** Permite realizar transferencias entre billeteras, registrando tanto el débito como el crédito.
- **Autenticación JWT:** Solo los usuarios autenticados pueden realizar operaciones de creación, actualización y eliminación. Los endpoints protegidos requieren un token JWT.
- **Documentación interactiva con Swagger:** Facilita la prueba y el entendimiento de la API.
- **Base de datos en la nube:** La base de datos está alojada en la nube para una mejor prueba y escalabilidad del proyecto.

## Cómo Obtener y Utilizar el Token de Autenticación

Para obtener un token válido y utilizarlo en Swagger, sigue estos pasos:

1. **Obtener el Token:**
   - Envía una solicitud `POST` al endpoint `/api/auth/login` con las siguientes credenciales en el body (formato JSON):
     
     ```json
     {
       "username": "userPayPhone",
       "password": "PayPhonePro"
     }
     ```
     
   - Si las credenciales son correctas, recibirás una respuesta con el token en formato JSON, por ejemplo:
     
     ```json
     {
       "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
     }
     ```

2. **Utilizar el Token en Swagger:**
   - Abre la interfaz de Swagger `https://localhost:7299/swagger`.
   - Haz clic en el botón **Authorize** que se encuentra en la parte superior.
   - En el campo de autorización, ingresa el token en el siguiente formato:
     
     ```
     Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
     ```
     
   - Una vez autorizado, podrás probar los endpoints protegidos sin recibir errores 401 (no autorizado).

## Configuración de la Base de Datos

La aplicación está configurada para conectarse a una base de datos SQL Server alojada en la nube, lo que permite realizar pruebas de integración y escalabilidad en un entorno más cercano a producción. Asegúrate de actualizar la cadena de conexión en el archivo `appsettings.json` con las credenciales y parámetros correctos para conectarte a la instancia en la nube.

## Ejecución del Proyecto

Sigue estos pasos para ejecutar la API localmente:

1. **Requisitos Previos:**
   - Tener instalado el .NET 8 SDK.
   - Contar con Visual Studio 2022, Visual Studio Code u otro editor compatible.

2. **Clonar el Repositorio:**

   Abre una terminal y clona el repositorio:

   ```bash
   git clone https://github.com/N1co12/Payphone.WalletTransferAPI.git
   cd WalletTransfer.API
   
3. **Restaurar Paquetes y Compilar la Solución:**

   Ejecuta los siguientes comandos en la terminal:

   ```bash
   dotnet restore
   dotnet build

4. **Ejecutar la API:**

   Desde la carpeta del proyecto API, ejecuta:

   ```bash
   dotnet run

5. **Probar la API:**

   Abre tu navegador y accede a la interfaz de Swagger en:

   ```bash
   https://localhost:7299/swagger/index.html

## Ejecución de las Pruebas

  La solución incluye dos tipos de pruebas:
  - **Pruebas Unitarias:**
    Se han implementado en el proyecto WalletTransfer.Tests.Unit para validar la lógica de negocio de forma aislada.
  - **Pruebas de Integración:**
    Se encuentran en el proyecto WalletTransfer.Tests.Integration y validan el flujo completo de autenticación y operaciones utilizando WebApplicationFactory.

  Para ejecutar todas las pruebas, abre una terminal en la raíz de la solución y ejecuta:

   ```bash
   dotnet test
   ```

## Contacto

  Para cualquier duda o sugerencia, contacta a **nicojuhu@gmail.com**.
