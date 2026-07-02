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
git clone [https://github.com/michelin2104/Reto-QA-BACKEND.git](https://github.com/michelin2104/Reto-QA-BACKEND.git)
cd Reto-QA-BACKEND 

2. Instalar dependencias e inicializar el entorno:

npm install

3. Descargar el motor ejecutable de Karate:
Ejecuta el script personalizado de Node para descargar el componente standalone necesario:

npm run download-karate

4. Execution (Ejecución de Pruebas)
Para lanzar toda la suite de pruebas automatizadas, simplemente ejecuta:

npm test