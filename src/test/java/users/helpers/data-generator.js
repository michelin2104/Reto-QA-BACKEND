function createRandomUser() {
    const timestamp = java.lang.System.currentTimeMillis();
    return {
        nome: "Camilo Test " + timestamp,
        email: "camilo_" + timestamp + "@test.com",
        password: "password123",
        administrador: "true"
    };
}