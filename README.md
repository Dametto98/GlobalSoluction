# Global Solution 2025/1: ResilientRoute - Plataforma de Resposta a Eventos Extremos

**Turma:** 2TDSPZ - Fevereiro
**Desafio:** DESAFIO FIAP: EVENTOS EXTREMOS

## Membros da Equipe

* RM558614 - Caike Dametto - 2TDSPZ
* RM558461 - Guilherme Janinzzi - 2TDSPZ

---

## 1. Nossa Solução: ResilientRoute 🚀

O desafio "Eventos Extremos" convoca soluções tecnológicas inovadoras para ajudar pessoas, proteger o meio ambiente ou prevenir problemas maiores em cenários impactados por desastres naturais. **ResilientRoute** é uma plataforma abrangente projetada para aprimorar a preparação, resposta e recuperação para eventos climáticos extremos, com foco inicial em **enchentes e deslizamentos de terra**.

Nossa plataforma visa:
* Fornecer **alertas antecipados** e **análises de risco** usando análise de dados e IA.
* Oferecer **rotas de evacuação seguras** e relatos de incidentes em tempo real através de um aplicativo móvel.
* Facilitar a **gestão de recursos** e comunicação para serviços de emergência e comunidades afetadas.
* Permitir uma rápida **avaliação de danos** usando tecnologia de visão computacional.

Acreditamos que, ao integrar diversas tecnologias, podemos criar uma solução que faz uma diferença real em momentos de crise. [cite: 7]

---

## 2. Componentes Principais da Plataforma & Stack Tecnológica

O ResilientRoute será construído usando uma abordagem modular, com cada disciplina contribuindo com um componente vital:

* **API Backend (.NET):** O sistema nervoso central gerenciando dados de incidentes, usuários, abrigos e recursos.
* **Banco de Dados (PostgreSQL & Oracle):**
    * **PostgreSQL:** Banco de dados relacional principal para a API .NET principal, lidando com dados operacionais.
    * **Oracle:** Banco de dados relacional para o microsserviço de análise preditiva baseado em Java, focado em processamento complexo de dados e necessidades específicas de relatórios.
* **Aplicativo Móvel (React Native):** A interface primária para os cidadãos receberem alertas, reportarem incidentes, encontrarem abrigos e acessarem rotas seguras.
* **Módulo de Visão Computacional (Python):** Para avaliação automatizada de danos a partir de imagens (por exemplo, de drones ou satélites).
* **Microsserviço de Análise Preditiva (Java):** Um serviço avançado para prever impactos secundários ou padrões de risco complexos.
* **Deployment (Implantação):** Serviços conteinerizados (Docker) com potencial implantação em nuvem para escalabilidade e acessibilidade.

---

## 3. Entregas por Disciplina

Veja como cada disciplina contribui para a plataforma ResilientRoute:

###  secours ADVANCED BUSINESS DEVELOPMENT WITH .NET: API Principal

* **Contribuição:** Desenvolvimento da **API REST** primária para o ResilientRoute. Esta API lidará com funcionalidades centrais como autenticação de usuários, relato de incidentes, gerenciamento de informações de abrigos, rastreamento de recursos e disseminação de alertas.
* **Principais Características & Tecnologias:**
    * Construída com .NET, seguindo boas práticas de arquitetura de API. 
    * Persistência em um banco de dados relacional **PostgreSQL**. 
    * Pelo menos um **relacionamento 1:N**. 
    * **Swagger/OpenAPI** para documentação. 
    * Utilização de **Razor e TagHelpers** para uma potencial interface web simples de administração/monitoramento.
    * Uso correto de **Migrations** do Entity Framework para gerenciamento de esquema de banco de dados.
* **Foco:** Viabilidade, inovação e implementação técnica robusta. 
---

### ☑️ COMPLIANCE, QUALITY ASSURANCE & TESTS: Arquitetura da Solução

* **Contribuição:** Documentar a arquitetura abrangente da plataforma ResilientRoute usando o **modelo TOGAF** com a ferramenta ARCHI. 
* **Principais Entregas:**
    * **Visão da Arquitetura:** Definindo stakeholders (cidadãos, serviços de emergência, ONGs), objetivos (ex: reduzir o tempo de resposta em X%, melhorar a eficiência da alocação de recursos) e requisitos chave. 
    * **Arquitetura de Negócios:** Descrevendo processos centrais (ex: registro de usuário, disseminação de alertas, orientação de evacuação, relato de danos), funções e papéis dos atores. 
    * **Arquitetura de Sistemas de Informação:** Detalhando componentes de aplicação (app móvel, API .NET, microsserviço Java, módulo de Visão Computacional, dashboards) e componentes de dados (dados do usuário, dados geoespaciais, dados de incidentes, BD de abrigos). 
    * **Arquitetura de Tecnologia:** Especificando infraestrutura de rede, dispositivos de acesso do usuário (smartphones, navegadores web), ambientes de servidor e stacks de software necessários para cada componente. 
    * **Documento de Apresentação do Projeto:** Incluindo nome do projeto, equipe, descrição do problema, público-alvo (comunidades em áreas propensas a enchentes/deslizamentos, equipes de resposta a emergências) e impacto estimado (ex: vidas salvas potenciais, redução no tempo de recuperação). 
* **Foco:** Garantir um blueprint arquitetônico bem definido, compatível e de alta qualidade para a solução.

---

### ☁️ DEVOPS TOOLS & CLOUD COMPUTING: Conteinerização & Implantação

* **Contribuição:** Conteinerizar a **API do Advanced Business Development with .NET** e seu banco de dados **PostgreSQL** usando Docker. 
* **Principais Características & Tecnologias:**
    * **Contêiner da Aplicação (API .NET):**
        * Construído via `Dockerfile`. 
        * Executa com um usuário não-root. 
        * Diretório de trabalho definido e pelo menos uma variável de ambiente. 
        * Porta exposta para acesso à API. 
        * A API contará com funcionalidade CRUD completa, persistindo dados no contêiner PostgreSQL. 
    * **Contêiner do Banco de Dados (PostgreSQL):**
        * Usando uma imagem pública oficial. 
        * Volume nomeado para persistência de dados. 
        * Pelo menos uma variável de ambiente (ex: para credenciais do banco de dados). 
        * Porta exposta для acesso ao banco de dados. 
    * **Geral:**
        * Contêineres executam em modo background (segundo plano). 
        * Logs de ambos os contêineres serão exibidos via terminal. 
        * Todas as evidências fornecidas via comandos de terminal (sem GUI do Docker Desktop para evidências). 
        * Um repositório GitHub conterá todos os arquivos necessários (código-fonte, Dockerfile, scripts/JSONs de teste).
* **Foco:** Criar um ambiente de implantação portável, escalável e gerenciado de forma eficiente para a API principal.

---

### 🤖 DISRUPTIVE ARCHITECTURES: IOT, IOB & GENERATIVE IA (Foco em Visão Computacional)

* **Contribuição:** Desenvolvimento de um módulo de **Visão Computacional para avaliação rápida de danos** após eventos extremos como enchentes ou deslizamentos de terra. Isso se desvia do foco em IoT, enfatizando a análise de imagens conforme orientação do professor.
* **Objetivo:** Analisar imagens aéreas ou de satélite (potencialmente utilizando fontes como o **Disasters Charter**  ou datasets públicos) para identificar e quantificar danos à infraestrutura e ao meio ambiente.
* **Principais Características & Tecnologias:**
    * **Sistema de Análise de Imagens:**
        * Utilizar Python com bibliotecas como OpenCV, TensorFlow/PyTorch.
        * O sistema visará processar imagens para, por exemplo:
            * Identificar áreas inundadas.
            * Detectar edifícios ou estradas danificadas.
            * Mapear a extensão de deslizamentos de terra.
    * **Dataset (Conjunto de Dados):** Exploraremos datasets de fontes como o International Charter Space and Major Disasters  ou outros datasets públicos de imagens de desastres (ex: xBD, Maxar Open Data Program).
    * **"Dashboard" (Visualização):** Uma interface web simples ou um Jupyter Notebook para carregar uma imagem (ou selecionar de um dataset), acionar a análise e exibir a imagem com sobreposições (ex: caixas delimitadoras em estruturas danificadas, máscaras de segmentação para regiões inundadas) e estatísticas resumidas.
    * **"Gateway" (Pipeline de Processamento):** Um script backend ou API simples (ex: usando Flask/FastAPI) para receber dados de imagem, orquestrar o(s) modelo(s) de visão computacional para análise e retornar resultados estruturados (ex: JSON com coordenadas de danos, porcentagem de área afetada).
    * **"Protocolos" (Comunicação):** Primariamente HTTP para transferência de dados de imagem e JSON para troca de resultados de análise.
    * **Aspecto de IA Generativa:** Poderia ser explorado para gerar resumos textuais dos danos detectados a partir da análise visual ou para criar dados sintéticos de imagem para aumentar os conjuntos de treinamento, se necessário (embora este último seja mais avançado).
* **Entregas (Adaptado de IoT):**
    * **Protótipo Funcional:** Um pipeline de visão computacional funcional demonstrando a análise de imagens para avaliação de danos. 
    * **Documentação:** Repositório GitHub com código comentado, instruções de configuração (README.md), descrição do dataset utilizado e explicação do fluxo de trabalho da análise. 
    * **Vídeo de Apresentação:** Um vídeo curto (máx. 3 minutos) mostrando o módulo de Visão Computacional em ação, explicando sua funcionalidade, o problema que resolve e seus benefícios para a resposta a desastres. 
* **Foco:** Alavancar a visão computacional para fornecer insights rápidos e acionáveis sobre a extensão dos danos pós-desastre, auxiliando os esforços de resposta e recuperação.

---

### ☕ JAVA ADVANCED: Microsserviço de Análise Preditiva

* **Contribuição:** Desenvolvimento de um **microsserviço API Rest especializado usando Spring Boot** para análises preditivas avançadas relacionadas às consequências de eventos extremos. Este serviço complementará a API .NET principal, lidando com tarefas de processamento de dados mais complexas.
* **Funcionalidade Exemplo:** Prever riscos secundários potenciais (ex: probabilidade de surtos de doenças com base na duração da inundação e densidade populacional afetada, ou identificar áreas de alto risco para deslizamentos subsequentes devido à saturação do solo).
* **Principais Características & Tecnologias:**
    * API Rest construída com Spring Boot, aderindo a boas práticas de arquitetura. 
    * Persistência em um banco de dados relacional **Oracle** usando Spring Data JPA (conectando-se ao banco de dados desenvolvido na disciplina "Mastering Relational and Non-Relational Database"). 
    * Mapeamento de relacionamentos entre entidades. 
    * Validação de entrada com Bean Validation. 
    * Funcionalidades como paginação, ordenação e filtros para quaisquer endpoints consultáveis. 
    * Documentação da API com Swagger. 
    * Segurança com JWT (JSON Web Tokens) para autenticação. 
    * **Implantação em uma plataforma de nuvem.** 
* **Foco:** Fornecer capacidades analíticas avançadas para melhorar a previsão e preparação para os efeitos em cascata de desastres.

---

### 💾 MASTERING RELATIONAL AND NON-RELATIONAL DATABASE: Persistência de Dados para Análises (Oracle)

* **Contribuição:** Projeto e implementação do banco de dados relacional **Oracle** que servirá ao microsserviço de análise preditiva **Java Advanced**.
* **Principais Entregas:**
    * **Modelo Relacional (3FN):** Diagramas lógico e físico para o banco de dados Oracle, garantindo a normalização.
    * **Criação de Tabelas:** Scripts SQL para criar tabelas com todas as restrições necessárias (PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK, etc.). 
    * **Procedures DML por Tabela:** Para cada tabela do sistema:
        * 1 procedure de inserção.
        * 1 procedure de atualização (update). 
        * 1 procedure de exclusão (delete). 
        * Execução dessas procedures para inserção de no mínimo 5 linhas por tabela (não serão considerados inserts manuais/hardcoded). 
    * **Funções para Retorno de Dados Processados:** Pelo menos 2 funções (ex: `calcular_risco_medio_area`, `retornar_total_ocorrencias_por_regiao`). 
    * **Blocos Anônimos com Consultas Complexas:** 2 blocos anônimos distintos relevantes para o serviço de analytics, usando JOIN, GROUP BY, HAVING, ORDER BY, subqueries, IF/ELSE, LOOP. 
    * **Cursores Explícitos:** Utilização de cursores para leitura de dados (OPEN, FETCH, CLOSE) dentro de um LOOP em um dos blocos anônimos ou procedures.
    * **Consultas SQL Complexas (Relatórios):** Pelo menos 5 instruções SELECT demonstrando recuperação complexa de dados usando JOINs entre múltiplas tabelas, agregações (SUM, COUNT, AVG), GROUP BY, HAVING, subqueries e ORDER BY. 
    * **Integração com Projeto Java:** Demonstração do banco de dados Oracle sendo utilizado pelo microsserviço Java Advanced. 
* **Foco:** Construir um banco de dados Oracle robusto e eficiente, otimizado para as tarefas de análise de dados e relatórios do microsserviço Java.

---

### 📱 MOBILE APPLICATION DEVELOPMENT: Aplicativo Móvel Cidadão

* **Contribuição:** Desenvolvimento do aplicativo móvel **ResilientRoute usando React Native**. Este aplicativo será a interface primária para os cidadãos.
* **Principais Características & Tecnologias:**
    * **Telas e Navegação:**
        * Mínimo de **5 telas distintas** (ex: Início/Dashboard, Mapa de Alertas ao Vivo, Reportar Incidente, Abrigos Próximos, Contatos de Emergência/Meu Perfil).
        * Navegação intuitiva usando React Navigation ou Expo Router.
    * **CRUD com API:**
        * Implementação de operações de **Create, Read, Update, Delete** interagindo com a **API .NET** (desenvolvida em Advanced Business Development with .NET). Exemplos: enviar um relato de incidente (Create), visualizar alertas ativos (Read), atualizar status de segurança do usuário (Update).
        * Uso de Axios ou Fetch para comunicação com API, incluindo tratamento de erros e feedback visual (loaders, mensagens).
    * **Estilização:**
        * Aparência personalizada (cores, fontes, imagens) alinhada com a marca e tema do ResilientRoute.
        * Design consistente respeitando padrões de usabilidade.
    * **Arquitetura do Código:**
        * Organização lógica de arquivos, pastas e componentes.
        * Convenções de nomenclatura claras e padronizadas.
        * Separação adequada de responsabilidades.
        * Código limpo, legível, bem estruturado e devidamente formatado.
* **Entregas:**
    * Arquivo de texto com o endereço do repositório no GitHub Classroom.
    * README.md no repositório com nomes dos integrantes, link para o vídeo no YouTube e descrição da solução da Global Solution. 
    * Vídeo demonstrando todas as funcionalidades do App (máx. 5 minutos).
* **Foco:** Criar um aplicativo móvel amigável, confiável e funcional que capacite os cidadãos durante eventos extremos.

---

## 4. Informações Gerais do Projeto

* **Código Fonte:** Todo o código fonte dos respectivos componentes será hospedado no GitHub. Links específicos dos repositórios serão adicionados aqui e dentro do pacote de entrega de cada disciplina.
* **Demonstrações em Vídeo:** Cada disciplina relevante fornecerá demonstrações em vídeo conforme especificado em seus requisitos. Links para esses vídeos (ex: no YouTube) serão incluídos nas entregas.
* **Colaboração:** Embora cada disciplina tenha entregas específicas, o objetivo principal é garantir que esses componentes possam (pelo menos conceitualmente para esta fase) se integrar na plataforma coesa ResilientRoute.

---

## 5. Configuração e Execução do Projeto (Orientação Geral)

Instruções detalhadas de configuração estarão disponíveis nos arquivos README de cada repositório individual de componente. Geralmente, isso envolverá:

1.  Clonar o repositório específico.
2.  Instalar as dependências necessárias (ex: .NET SDK, Node.js, bibliotecas Python, JDK Java, Maven/Gradle, ambiente React Native).
3.  Configurar variáveis de ambiente (ex: strings de conexão de banco de dados, chaves de API).
4.  Executar scripts de migração de banco de dados.
5.  Iniciar a aplicação/serviço (ex: `dotnet run`, `npm start`, `docker-compose up`).

---

Estamos entusiasmados para desenvolver o ResilientRoute e acreditamos que ele tem um potencial significativo para enfrentar os desafios impostos por eventos naturais extremos!
