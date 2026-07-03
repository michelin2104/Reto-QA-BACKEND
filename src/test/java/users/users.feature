Feature: Gestión de Usuarios en la API ServeRest

  Background:
    * url 'https://serverest.dev'
    * def dataGen = read('helpers/data-generator.js')
    * def schemas = read('users-schemas.json')

  @happy
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

  @unhappy
  Scenario: Intentar buscar un usuario con un ID que no existe (Caso Negativo)
    # Enviamos un ID falso pero válido de 16 caracteres para forzar el error 404/400 de no encontrado
    Given path 'usuarios', '0000000000000000'
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  # ... Conservas intactos tus escenarios anteriores de Background y CRUD Positivo ...

  @unhappyoutline
  Scenario Outline: Validar restricciones y campos obligatorios al registrar usuario (Casos Negativos)
    Given path 'usuarios'
    And request { nome: '<nome>', email: '<email>', password: '<password>', administrador: '<administrador>' }
    When method post
    Then status 400
    And match response["<campo_error>"] == "<mensaje_esperado>"

    Examples:
      | nome        | email                 | password | administrador | campo_error    | mensaje_esperado                          |
      |             | outline_1@test.com    | pass123  | true          | nome           | nome não pode ficar em branco             |
      | Camilo Test |                       | pass123  | true          | email          | email não pode ficar em branco            |
      | Camilo Test | outline_invalid_email | pass123  | true          | email          | email deve ser um email válido            |
      | Camilo Test | outline_3@test.com    |          | true          | password       | password não pode ficar em branco         |
      | Camilo Test | outline_4@test.com    | pass123  |               | administrador  | administrador deve ser 'true' ou 'false'  |