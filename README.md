# Reto de Automatización QA - BackEnd (ServeRest API)

Este repositorio contiene una suite de pruebas automatizadas para la API de Usuarios de [ServeRest](https://serverest.dev/) desarrollada utilizando **Karate DSL** e integrada en un entorno gestionado con **Node.js**.

---

## 🚀 Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:
* **Node.js** (Versión 16 o superior recomendada)
* **Java JRE/JDK** (Versión 11 o superior, necesario para ejecutar el motor ejecutable de Karate)

---

## 🛠️ Configuración e Instalación

1. **Clonar el repositorio:**
```bash
git clone https://github.com/michelin2104/Reto-QA-BACKEND.git
cd Reto-QA-BACKEND
```

2. **Instalar dependencias e inicializar el entorno:**
```bash
npm install
```

3. **Descargar el motor ejecutable de Karate:**
Ejecuta el script personalizado de Node para descargar el componente standalone necesario:
```bash
npm run download-karate
```

4. **Execution (Ejecución de Pruebas):**
Para lanzar toda la suite de pruebas automatizadas, simplemente ejecuta:
```bash
npm test
```

## 📊 Reportes de Prueba

Al finalizar la ejecución, Karate genera de forma automática un reporte visual interactivo en HTML. Puedes consultarlo abriendo el siguiente archivo en cualquier navegador web:

```
target/karate-reports/karate-summary.html
```

## 💡 Informe de Estrategia de Automatización

### 1. Patrones y Buenas Prácticas Utilizadas
Data-Driven & Dynamic Helpers: Se implementó un script helper nativo en JavaScript (data-generator.js) encargado de construir datos dinámicos utilizando timestamps. Esto garantiza la unicidad de campos restrictivos (como el email) evitando colisiones y falsos negativos durante ejecuciones concurrentes o consecutivas.

Separación de Responsabilidades: Se estructuró el proyecto aislando los flujos de negocio (.feature), los esquemas de validación estructural (.json) y la lógica de asistencia de datos (.js).

Contract Testing / Validación de Esquemas: No solo se validan los códigos de estado HTTP (201, 200, 400), sino que se realiza una aserción estricta de tipos de datos sobre los contratos de respuesta JSON utilizando los comodines nativos de Karate (#string).

### 2. Cobertura de Escenarios
Flujo CRUD Completo (Caso Positivo): Ciclo de vida íntegro de un recurso en una única sesión encadenada: Creación (POST) -> Lectura (GET) -> Modificación completa (PUT) -> Eliminación física (DELETE).

Manejo de Errores (Caso Negativo): Validación del comportamiento de la API frente a solicitudes con formatos o recursos inexistentes, asegurando que retorne los códigos de error controlados esperados por la especificación.