# ExtremeHelp - API Backend (Java/Spring Boot)

Este diretório contém o código-fonte do back-end da plataforma ExtremeHelp, uma API RESTful desenvolvida com Java e Spring Boot.

## 📖 Sobre o Projeto

**ExtremeHelp** é uma plataforma digital projetada para ser uma ponte solidária em momentos de crise. O objetivo principal é conectar, de forma rápida e geolocalizada, pessoas em situação de vulnerabilidade com voluntários dispostos a oferecer ajuda.

Além de coordenar os pedidos e atendimentos, a plataforma atua como um canal centralizado para a divulgação de alertas de emergência (como enchentes, ondas de calor ou outros riscos) e dicas de preparação, fortalecendo a resiliência e a segurança da comunidade.

## 🚀 Tecnologias Utilizadas

* **Linguagem:** Java 17
* **Framework:** Spring Boot 3
* **Segurança:** Spring Security (com autenticação baseada em JWT)
* **Acesso a Dados:** Spring Data JPA / Hibernate
* **Banco de Dados:** Oracle
* **Build:** Apache Maven
* **Documentação de API:** SpringDoc (Swagger UI)

---

## 📋 Pré-requisitos

Para compilar e rodar esta aplicação localmente, você precisará de:

* **JDK 17** (Java Development Kit)
* **Apache Maven 3.6+**
* Acesso a uma instância do **Oracle Database** (pode ser o container Docker configurado para este projeto).

---

## ⚙️ Configuração

As principais configurações da aplicação estão no arquivo `src/main/resources/application.properties`. A aplicação é configurada para usar perfis do Spring, permitindo diferentes configurações para cada ambiente (ex: `dev`, `prod`).

A conexão com o banco de dados é controlada por variáveis de ambiente para maior segurança e flexibilidade:

* `DB_HOST`: O endereço IP ou hostname do servidor do banco de dados.
* `DB_USERNAME`: O nome de usuário para a conexão.
* `DB_PASSWORD`: A senha para a conexão.

**Exemplo de `application-prod.properties`:**

```properties
# URL de conexão JDBC usando placeholders
spring.datasource.url=jdbc:oracle:thin:@//${DB_HOST}/FREEPDB1
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

# Configurações do Driver e Hibernate
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver

```

---

## ▶️ Como Executar a Aplicação Localmente

Existem duas formas principais de executar a aplicação na sua máquina local para desenvolvimento ou teste.

### 1. Usando o Maven Wrapper

Esta é a forma mais fácil, pois utiliza a versão do Maven embarcada no projeto. No terminal, na raiz do diretório `ExtemeHelp-JavaBackend`, execute:

**No Linux/macOS:**
```bash
# Defina as variáveis de ambiente primeiro
export DB_HOST="<ip_do_seu_banco>"
export DB_USERNAME="<usuario_do_banco>"
export DB_PASSWORD="<senha_do_banco>"

# Execute a aplicação
./mvnw spring-boot:run
```

**No Windows (CMD):**
```cmd
REM Defina as variáveis de ambiente primeiro
set DB_HOST="<ip_do_seu_banco>"
DB_USERNAME="<usuario_do_banco>"
set DB_PASSWORD="<senha_do_banco>"

REM Execute a aplicação
mvnw.cmd spring-boot:run
```

### 2. Executando o Arquivo JAR

Primeiro, você precisa compilar o projeto e gerar o arquivo `.jar`.

**Compile o projeto:**
```bash
./mvnw clean package -DskipTests
```

Após a compilação, o arquivo `app.jar` (ou similar) estará na pasta `target/`. Agora, execute o JAR, passando as variáveis de ambiente:

```bash
# Defina as variáveis de ambiente
export DB_HOST="<ip_do_seu_banco>"
export DB_USERNAME="<usuario_do_banco>"
export DB_PASSWORD="<senha_do_banco>"

# Execute o JAR
java -jar target/app.jar
```

A aplicação iniciará na porta `8080` por padrão.

---

## 📚 Documentação da API (Swagger)

Uma vez que a aplicação esteja rodando, você pode acessar a documentação interativa da API, gerada pelo Swagger UI, no seu navegador. Isso permite visualizar e testar todos os endpoints disponíveis.

* **URL da Documentação:** [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)

---

## 🐳 Conteinerização com Docker

Esta API foi projetada para ser executada em um ambiente de containers Docker, garantindo portabilidade e consistência entre os ambientes de desenvolvimento e produção.

O `Dockerfile` necessário para construir a imagem da aplicação, bem como as instruções completas para o deploy, configuração de rede e execução integrada com o container do banco de dados, estão centralizados no repositório principal do projeto.

Para um guia passo a passo sobre como construir a imagem e implantar o ambiente completo, por favor, consulte o `README.md` principal:

➡️ **[Instruções de Deploy - Repositório Principal](https://github.com/GuiJanunzzi/ExtremeHelp-Cloud)***