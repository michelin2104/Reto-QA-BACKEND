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

### 🎯 Stack Tecnológico
- **Karate DSL**: Framework de testing basado en Java que permite escribir pruebas de APIs en un lenguaje DSL simple y legible
- **Node.js**: Gestor de dependencias y orquestador de scripts para descargar y ejecutar Karate
- **Integración Híbrida**: Aprovecha la simplicidad de Node.js con la robustez de Java/Karate para APIs REST

### 1. Patrones y Buenas Prácticas Utilizadas

#### 📌 A. BDD (Behavior Driven Development) con Gherkin
Se utilizó **Gherkin** (lenguaje específico de dominio para BDD) para escribir los tests de forma legible y entendible por stakeholders no técnicos:

```gherkin
Feature: Gestión de Usuarios en la API ServeRest

  Scenario: Flujo CRUD Completo de un Usuario (Casos Positivos)
    Given path 'usuarios'
    When method post
    Then status 201
```

**Ventajas del enfoque BDD:**
- ✅ Los tests actúan como **documentación viva** del comportamiento esperado
- ✅ Lenguaje natural: equipo técnico y producto hablan el mismo idioma
- ✅ Fácil de mantener y entender por nuevos miembros del equipo
- ✅ Karate DSL convierte automáticamente Gherkin en tests ejecutables

#### 📌 B. Data-Driven & Dynamic Helpers
Se implementó un script helper nativo en JavaScript (`data-generator.js`) que construye datos dinámicos utilizando **timestamps** del sistema como identificador único:

```javascript
function createRandomUser() {
    const timestamp = java.lang.System.currentTimeMillis();
    return {
        nome: "Camilo Test " + timestamp,
        email: "camilo_" + timestamp + "@test.com",
        password: "password123",
        administrador: "true"
    };
}
```

**Beneficios:**
- ✅ **Evita colisiones de datos**: Cada ejecución genera un email único basado en milisegundos
- ✅ **Idempotencia en ejecuciones concurrentes**: No hay conflictos entre múltiples ejecuciones simultáneas
- ✅ **Reutilización**: El mismo helper se invoca en POST (crear) y PUT (actualizar)

#### 📌 C. Separación de Responsabilidades
El proyecto está estructurado en **tres capas bien definidas**:

| Archivo | Responsabilidad |
|---------|-----------------|
| `users.feature` | Flujos de negocio, escenarios y assertions |
| `users-schemas.json` | Contratos de respuesta (validación estructural) |
| `helpers/data-generator.js` | Generación de datos dinámicos |

Esto garantiza **mantenibilidad, reusabilidad y claridad** en el código.

#### 📌 D. Contract Testing / Validación de Esquemas
Se valida no solo los **códigos de estado HTTP**, sino también la **estructura y tipos de datos** de las respuestas usando los comodines nativos de Karate (`#string`):

```json
{
  "createUserResponse": { 
    "message": "#string", 
    "_id": "#string" 
  },
  "getUserResponse": { 
    "nome": "#string", 
    "email": "#string", 
    "password": "#string", 
    "administrador": "#string", 
    "_id": "#string" 
  }
}
```

**Validación en el Feature:**
```gherkin
When method post
Then status 201
And match response == schemas.createUserResponse
```

Esto asegura que la API retorne exactamente los campos esperados con los tipos correctos.

### 2. Estrategia de Escenarios

#### 🔄 Flujo CRUD Completo (Caso Positivo) - Escenario Encadenado
Se implementó un **único escenario que cubre el ciclo de vida completo** del recurso:

```
1. POST (Creación) → 2. GET (Lectura) → 3. PUT (Actualización) → 4. DELETE (Eliminación)
```

**Ventajas de este enfoque:**
- ✅ Valida que la API mantenga consistencia entre operaciones
- ✅ Verifica que el ID generado en POST se puede usar en GET/PUT/DELETE
- ✅ Simula un caso de uso real de principio a fin
- ✅ Detecta inconsistencias en el estado del servidor

**Ejemplo del flujo:**
```gherkin
Scenario: Flujo CRUD Completo de un Usuario (Casos Positivos)
    # 1. POST - Registrar Usuario
    Given path 'usuarios'
    And request newUser
    When method post
    Then status 201
    * def userId = response._id  # Captura el ID para usar después
    
    # 2. GET - Buscar Usuario por ID
    Given path 'usuarios', userId
    When method get
    Then status 200
    And match response.email == newUser.email
    
    # 3. PUT - Actualizar Información
    Given path 'usuarios', userId
    When method put
    Then status 200
    
    # 4. DELETE - Eliminar el Usuario
    Given path 'usuarios', userId
    When method delete
    Then status 200
```

#### 🚫 Manejo de Errores (Casos Negativos)
Se valida el comportamiento de la API frente a solicitudes **inválidas o con recursos inexistentes**:

```gherkin
Scenario: Intentar buscar un usuario con un ID que no existe
    Given path 'usuarios', '0000000000000000'
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'
```

**Cobertura de negativos:**
- ✅ IDs inexistentes retornan 400 con mensaje específico
- ✅ API responde de forma controlada sin crashes
- ✅ Mensajes de error son consistentes

### 3. Herramientas y Reportes

Karate genera automáticamente **reportes interactivos en HTML** después de cada ejecución:
- `karate-summary.html`: Resumen visual con estadísticas
- `karate-timeline.html`: Línea de tiempo de ejecución
- `karate-tags.html`: Agrupación por tags
- JSON detallado para integración CI/CD