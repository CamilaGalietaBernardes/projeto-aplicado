# 🧮 Projeto Aplicado – Gestão de Estoque e Manutenção

Sistema completo para **gestão de estoque e manutenção**, desenvolvido como parte do **Projeto Aplicado** do curso de Análise e Desenvolvimento de Sistemas – SENAI SC (demanda solcitada por SENAI ES).
Este repositório segue o formato **monorepo**, contendo todas as camadas da aplicação: backend, frontend e mobile.

---

## 🏷️ Estrutura do Projeto

```
projeto-aplicado/
├── backend/        # API desenvolvida em Python (Flask)
├── frontend/       # Interface web em React.js
├── mobile/         # Aplicativo móvel em Flutter
├── docker-compose.yml
└── README.md
```

Cada módulo é independente, mas todos são integrados via **Docker Compose**, o que facilita o desenvolvimento e a execução conjunta de todos os serviços.

---

## 🧩 Tecnologias Utilizadas

| Camada             | Tecnologias principais                |
| ------------------ | ------------------------------------- |
| **Backend**        | Python, Flask, SQLAlchemy, PostgreSQL |
| **Frontend**       | React.js, Vite, Axios, React Router   |
| **Mobile**         | Flutter, Dart, MobX, Hive, Dio        |
| **Infraestrutura** | Docker, Docker Compose, PostgreSQL    |

---

## 🐳 Execução com Docker Compose

O projeto pode ser executado integralmente via **Docker Compose**, tanto em **modo de desenvolvimento** quanto em **produção**.

### ▶️ Rodando o projeto

1. Certifique-se de ter o **Docker** e o **Docker Compose** instalados.

2. No diretório raiz do projeto, execute:

   ```bash
   docker-compose up --build
   ```

3. Os serviços serão iniciados automaticamente:

| Serviço                         | Porta padrão | Descrição                                            |
| ------------------------------- | ------------ | ---------------------------------------------------- |
| **Backend (Flask)**             | `6000`       | API principal da aplicação                           |
| **Frontend (React)**            | `5173`       | Interface web                                        |
| **Banco de Dados (PostgreSQL)** | `5432`       | Banco de dados relacional                            |
| **Mobile (Flutter)**            | —            | Rodar manualmente via emulador ou dispositivo físico |

---

## ⚙️ Ambiente de Desenvolvimento

Durante o desenvolvimento, o Docker também é utilizado para manter o ambiente padronizado entre os integrantes da equipe.

* Cada serviço possui seu **Dockerfile** individual.
* O `docker-compose.yml` mapeia volumes locais, permitindo hot reload.
* Logs podem ser visualizados em tempo real via:

  ```bash
  docker-compose logs -f
  ```

---

## 🧠 Funcionalidades Principais

* Cadastro e controle de peças e equipamentos
* Emissão e acompanhamento de ordens de serviço
* Controle de estoque (entrada e saída automática)
* Alertas de estoque mínimo
* Autenticação de usuários (login e permissões)
* Interface web responsiva e aplicativo móvel sincronizado

---

## 🧑‍💻 Contribuidores

* **Camila Galieta Bernardes** – Backend e Documentação
* **Cristian Moises Brunone Cordero** – Mobile
* **Marcio Kiyoshi Shikasho** - Frontend
* **Adriano Felipe Alves dos Reis** - Frontend e Documentação
---

## 📝 Licença

Este projeto é de uso educacional e faz parte do **Projeto Aplicado IV – SENAI SC - Campus Florianópolis**.
---

## 💡 Observação

Caso ocorra algum erro na inicialização do ambiente (ex.: `gestao_estoque_app exited with code 127`), verifique:

* Se o script `wait-for-db.sh` está com permissão de execução (`chmod +x backend/wait-for-db.sh`)
* Se o banco de dados PostgreSQL está saudável (`docker ps` deve mostrar `healthy`)
