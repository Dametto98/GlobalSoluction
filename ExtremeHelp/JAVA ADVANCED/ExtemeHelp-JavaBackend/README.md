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

As principais configurações da aplicação estão no arquivo `src/main/resources/application.properties`. Para esta versão, o projeto está configurado para usar um banco de dados H2 em memória, o que significa que nenhuma configuração externa de banco de dados é necessária.

O banco de dados é criado e populado automaticamente toda vez que a aplicação é iniciada, e os dados são perdidos quando a aplicação é encerrada.

Configurações do H2 no `application.properties`:

```properties
spring.datasource.url=jdbc:h2:mem:mottomap
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

```

---

## ▶️ Como Executar a Aplicação Localmente

Como o banco de dados é em memória, não é necessário configurar nenhuma variável de ambiente. Basta compilar e rodar.

### 1. Usando o Maven Wrapper (Recomendado)

Esta é a forma mais fácil, pois utiliza a versão do Maven embarcada no projeto. No terminal, na raiz do diretório `ExtemeHelp-JavaBackend`, execute:

### 1. Usando o Maven Wrapper

Esta é a forma mais fácil, pois utiliza a versão do Maven embarcada no projeto. No terminal, na raiz do diretório `ExtemeHelp-JavaBackend`, execute:

**No Linux/macOS:**
```bash
./mvnw spring-boot:run
```

**No Windows (CMD):**
```cmd
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
java -jar target/extremehelp-0.0.1-SNAPSHOT.jar
```

A aplicação iniciará na porta `8080` por padrão.

---

## 📚 Documentação da API

Uma vez que a aplicação esteja rodando, você pode testar por sistemas como Postman ou Insomnia.

* **URL padrão da aplcação:** [http://localhost:8080/](http://localhost:8080/)

---

## 🐳 Conteinerização com Docker

Esta API foi projetada para ser executada em um ambiente de containers Docker, garantindo portabilidade e consistência entre os ambientes de desenvolvimento e produção.

O `Dockerfile` necessário para construir a imagem da aplicação, bem como as instruções completas para o deploy, configuração de rede e execução integrada com o container do banco de dados, estão centralizados no repositório principal do projeto.

Para um guia passo a passo sobre como construir a imagem e implantar o ambiente completo, por favor, consulte o `README.md` principal:

➡️ **[Instruções de Deploy - Repositório Principal](https://github.com/GuiJanunzzi/ExtremeHelp-Cloud)***