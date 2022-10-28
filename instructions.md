# Modelo de dbt para projetos Indicium

O objetivo deste modelo é compilar todos os padrões de dbt utilizados ao longo dos projetos para diferentes aplicações de cloud, banco de dados, serviços de git e outras particularidades que surgem nas atividades práticas.

| Cloud | Data Warehouse | Serviço de Git |
| ----- | -------------- | -------------- |
| AWS   | Redshift       | Bitbucket      |
| AWS   | Redshift       | Github         |
| AWS   | Postgres       | Bitbucket      |
| AWS   | Postgres       | Github         |
| AWS   | Databricks     | Bitbucket      |
| AWS   | Databricks     | GitHub         |
| GCP   | BigQuery       | Bitbucket      |
| GCP   | BigQuery       | Github         |
| Azure | Azure Synapse  | Bitbucket      |
| Azure | Azure Synapse  | Github         |
| Azure | Azure Synapse  | Azure DevOps   |

# Usabilidade

Nesta seção serão apresentados direcionamentos de como utilizar os templates presentes neste repositório.

## CI/CD Pipelines

A ideia do pipeline de CI/CD é garantir automação de diferentes processos de integração e deploy. A seguir vamos mostrar quais são os conteúdos esperados em um pipeline de CI/CD completo de dbt. Vamos dividir esses processos entre processos de Integração (CI) e processos de Deploy (CD).

#### Integração

* Testar se todo tipo de modelo roda corretamente
* Rodar os testes de dados configurados no dbt
* Testar a qualidade dos códigos por meio de linter

#### Deploy

* Atualizar bases estáticas por meio de seeds
* Criar imagem da nova versão do dbt referenciada em produção
* Gerar novo conteúdo para o dbt docs

Portanto, para garantir estes processos, os templates criados neste repositório foram pré-criados com base nas definições já testadas ao longo dos projetos. Vamos ao trabalho!

### Bitbucket

Bitbucket é a ferramenta de git mais utilizada nos projetos da Indicium, tanto internos quanto externos. Você pode acessar o arquivo [bitbucket-pipelines.yml](bitbucket-pipelines.yml) para checar os passos pré-estabelecidos para o CI/CD. 

O **primeiro passo** para usar esse pipeline é setar todas as variáveis de ambiente utilizadas nos pipelines. Essas variáveis servem para basicamente preencher o profiles.yml e garantir o funcionamento do dbt. Elas são dependentes do banco e da autenticação usada no dbt. Por exemplo, para Postgres teremos:

```yml
profile_name:
  target: ci
  outputs:
    ci:
      type: postgres
      host: "{{ env_var('DBT_DB_HOST') }}"
      port: "{{ env_var('DBT_DB_PORT') | int }}"
      user: "{{ env_var('DBT_CI_USER') }}"
      password: "{{ env_var('DBT_CI_PASSWORD') }}"
      dbname: "{{ env_var('DBT_DB_NAME') }}"
      schema: "{{ env_var('DBT_CI_SCHEMA') }}"
      threads: 4
      keepalives_idle: 0
```

As variáveis env_var precisam iniciar com o prefixo "DBT_" para serem reconhecidas pelo dbt.

O **segundo passo**, para garantir o funcionamento do Slim CI, é necessário [criar uma aplicação](https://support.atlassian.com/bitbucket-cloud/docs/create-an-app-password/) do Bitbucket para usar o upload do artefato. A senha da aplicação, em conjunto com o username (veja como ver seu username aqui), devem ser configuradas como variáveis (BITBUCKET_USERNAME e BITBUCKET_APP_PASSWORD)

**TO-DO: Uma versão melhorada desse processo deve ser avaliada: utilizar um consumer do bitbucket para autenticação, ao invés de usar um usuário pessoal**.

Por fim, o **último passo** é garantir que o requirements.txt contém uma versão do SQLFluff maior que 0.12, para que o processo de linter funcione corretamente. Além de garantir a instalação do SQLFluff, para que a ferramenta funcione, é necessário também configurar o arquivo .sqlfluff, conforme explicado na seção de SQLFluff abaixo.

### GitHub

...

### Azure DevOps

...

## .env

Caso seja preferível usar um arquivo .env em conjunto com o arquivo profiles.yml do repositório para trabalhar localmente, o arquivo [.env.example](.env.example) possui um template que deve ser copiado em um arquivo chamado ```.env e preenchido com as variáveis necessárias.

Para utilizar o profiles.yml do diretório como padrão, basta adicionar uma variável no seu .env apontando para o profiles do repositório (que está na pasta principal). Ou seja, só adicionar a seguinte linha no .env:

```bash
export DBT_PROFILES_DIR="./"
```

Para usar o .env, basta executar o seguinte comando para acessar as variáveis de ambiente pelo terminal:

```bash
$ source .env
```

## SQLFluff

SQLFluff é uma ferramenta poderosa para garantir a qualidade dos nossos códigos SQL. Para que a ferramenta funcione corretamente, é necessário fazer algumas configurações.

Primeiro, não esqueça de adicionar a variável DBT_DEFAULT_PROFILE_TARGET tanto no seu .env local quanto nas variáveis do seu repositório. Localmente, você deve configurar o default para seu target de desenvolvimento (geralmente, *dev*) e no pipeline o valor dessa variável deve ser o nome do profile de CI, ou seja, *ci*. 

Segundo, algumas linhas do arquivo .sqlfluff devem ser configuradas.

Em ```[sqlfluff]```, adicione o dialeto do seu projeto na linha ```dialect = project_dialect```. Na seção ```[sqlfluff:templater:dbt]```, adicione o nome do profile na linha ```profile = profile_name```. Feito! Com essas configurações, SQLFluff deve funcionar corretamente.

## README.md

O README padrão está presente no repositório, nas versões em [português](README.md) e [inglês](README_en.md). Dependendo do idioma acordado com o cliente, escolha um dos arquivos para manter no seu repositório e preencha com as informações necessárias.

Não esqueça de adicionar ao README qualquer particularidade do projeto que é importante informar para qualquer desenvolvedor ou membro do projeto que terá contato com o dbt.