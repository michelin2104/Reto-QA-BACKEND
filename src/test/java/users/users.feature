Feature: Gestión de Usuarios en la API ServeRest

  Background:
    * url 'https://serverest.dev'
    * def dataGen = read('helpers/data-generator.js')
    * def schemas = read('users-schemas.json')

  Scenario: Flujo CRUD Completo de un Usuario (Casos Positivos)
    # 1. POST - Registrar Usuario
    Given path 'usuarios'
    * def newUser = dataGen()
    And request newUser
    When method post
    Then status 201
    And match response == schemas.createUserResponse
    * def userId = response._id

    # 2. GET - Buscar Usuario por ID
    Given path 'usuarios', userId
    When method get
    Then status 200
    And match response == schemas.getUserResponse
    And match response.email == newUser.email

    # 3. PUT - Actualizar Información del Usuario
    Given path 'usuarios', userId
    * def updatedUser = dataGen()
    And request updatedUser
    When method put
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    # 4. DELETE - Eliminar el Usuario del Sistema
    Given path 'usuarios', userId
    When method delete
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

  Scenario: Intentar buscar un usuario con un ID que no existe (Caso Negativo)
    # Enviamos un ID falso pero válido de 16 caracteres para forzar el error 404/400 de no encontrado
    Given path 'usuarios', '0000000000000000'
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'