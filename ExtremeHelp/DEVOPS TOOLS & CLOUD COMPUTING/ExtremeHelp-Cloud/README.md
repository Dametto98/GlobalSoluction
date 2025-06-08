# ExtremeHelp - API Backend

## 📖 Sobre o Projeto

Este repositório contém o código-fonte e a configuração de infraestrutura como código para a API **ExtremeHelp**. A solução foi desenvolvida como parte do projeto da Global Solution para as disciplinas de DevOps & Cloud Computing e Java Advanced.

O objetivo da API é servir como back-end para uma plataforma que conecta voluntários a pessoas que necessitam de ajuda durante eventos emergenciais (enchentes, ondas de calor, etc.), além de centralizar alertas e dicas de preparação.

## 🚀 Tecnologias Utilizadas

* **Backend:** Java 17, Spring Boot 3, Spring Security, JPA/Hibernate
* **Banco de Dados:** Oracle Database
* **Build:** Apache Maven
* **Conteinerização:** Docker
* **Cloud:** Microsoft Azure (para hospedagem do banco de dados)

---

## 📋 Pré-requisitos

Para executar este projeto, você precisará ter as seguintes ferramentas instaladas em sua máquina local:

* [Git](https://git-scm.com/)
* [Java 17 (ou superior)](https://www.oracle.com/java/technologies/downloads/)
* [Apache Maven](https://maven.apache.org/download.cgi)
* [Docker](https://www.docker.com/products/docker-desktop/)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* Uma ferramenta de cliente SQL (DBeaver, SQL Developer, etc.)
* Uma ferramenta para testes de API, como [Insomnia](https://insomnia.rest/download) ou [Postman](https://www.postman.com/downloads/).

---

## 📂 Estrutura do Repositório

```
.
├── ExtemeHelp-JavaBackend/ # Código-fonte da aplicação Java/Spring Boot
├── scripts/
│   ├── sql/              # Scripts DDL (CREATE TABLE) e DML (PROCEDURES) do Oracle
│   └── json/             # Exemplos de JSON para testes de CRUD no Insomnia/Postman
└── Dockerfile              # Dockerfile para construir a imagem da aplicação Java
```


---

## ⚙️ Como Executar o Projeto

Siga os passos abaixo para configurar o ambiente e rodar a aplicação.

### 1. Configuração do Ambiente na Nuvem (Azure)

Execute os seguintes comandos no seu terminal usando a **Azure CLI** para criar a infraestrutura básica na nuvem.

**1.1. Crie o Grupo de Recursos:**
```bash
az group create --location eastus --name rg-extremehelp
```

**1.2. Crie a Máquina Virtual (VM):**
```bash
az vm create \
    --resource-group rg-extremehelp \
    --name vm-linux-extremehelp \
    --image Canonical:ubuntu-24_04-lts:minimal:24.04.202505020 \
    --size Standard_B2s \
    --admin-username admin_fiap \
    --admin-password "SuaSenhaForteAqui@123"
```
> **Nota:** Anote o endereço de IP público (`publicIpAddress`) da VM que será exibido no final deste comando. Você precisará dele mais tarde.

**1.3. Libere a Porta 1521 para o Oracle:**
```bash
az network nsg rule create \
    --resource-group rg-extremehelp \
    --nsg-name vm-linux-extremehelpNSG \
    --name allow_oracle_port_1521 \
    --protocol tcp \
    --priority 1010 \
    --destination-port-range 1521 \
    --access Allow \
    --direction Inbound
```

### 2. Configuração do Banco de Dados na VM

**2.1. Conecte-se à VM via SSH:**
```bash
ssh admin_fiap@<IP_DA_SUA_VM>
```

**2.2. Instale o Docker na VM:**
Siga as instruções oficiais do Docker para instalar o Docker Engine no Ubuntu:
[https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

**2.3. Execute o Container do Banco de Dados Oracle:**
```bash
sudo docker run -d \
    --name extremehelp-db \
    -p 1521:1521 \
    -e ORACLE_PWD=extremehelp@123 \
    -e ORACLE_CHARACTERSET=AL32UTF8 \
    -v oracle_dados:/opt/oracle/oradata \
    [container-registry.oracle.com/database/free](https://container-registry.oracle.com/database/free)
```

**2.4. Verifique se o Banco está Pronto:**
O container do Oracle leva alguns minutos para iniciar. Monitore os logs até ver a mensagem `DATABASE IS READY TO USE!`.
```bash
sudo docker logs -f extremehelp-db
```
(Pressione `Ctrl + C` para sair dos logs quando terminar).

**2.5. Crie o Schema e Insira os Dados:**
Use sua ferramenta de cliente SQL para se conectar ao banco de dados Oracle usando o **IP público da sua VM**. Em seguida, execute os scripts `.sql` localizados na pasta `/scripts/sql` deste repositório para criar as tabelas, sequences, procedures e inserir os dados iniciais.

* **Host:** `<IP_DA_SUA_VM>`
* **Porta:** `1521`
* **Nome do Serviço:** `FREEPDB1`
* **Usuário:** `SYSTEM`
* **Senha:** `extremehelp@123`

### 3. Construir e Executar o Container da Aplicação

**3.1. Clone este repositório para sua máquina local:**
```bash
git clone https://github.com/GuiJanunzzi/ExtemeHelp-JavaBackend.git
cd ExtemeHelp-JavaBackend
```

**3.2. Construa a Imagem Docker da Aplicação:**
No terminal, na raiz do projeto (onde está o `Dockerfile`), execute:
```bash
docker build -t extremehelp_backend:1.0 .
```

**3.3. Execute o Container da Aplicação:**
Execute o container, injetando as variáveis de ambiente com os dados de conexão do seu banco de dados na VM.

> **IMPORTANTE:** Substitua `<IP_DA_SUA_VM>` pelo IP público da sua máquina virtual do Azure.

```bash
docker run -d \
    --name extremehelp-app \
    -p 8080:8080 \
    -e DB_HOST="<IP_DA_SUA_VM>" \
    -e DB_USERNAME="SYSTEM" \
    -e DB_PASSWORD="extremehelp@123" \
    extremehelp_backend:1.0
```

### 4. Testando a Aplicação

Após iniciar o container da aplicação, você pode verificar os logs para confirmar que ela subiu corretamente:
```bash
docker logs -f extremehelp-app
```

**4.1. Acesso via Swagger UI:**
A documentação da API estará disponível no seu navegador em:
[http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)

**4.2. Testes com Insomnia/Postman:**
Você pode usar uma ferramenta de cliente API para testar os endpoints de CRUD. Utilize os arquivos de exemplo na pasta `/scripts/json` para montar suas requisições.
* **URL Base:** `http://localhost:8080`
