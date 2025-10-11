# Funcionalidades Pendentes no Mobile

## Visão Geral

Este documento compara as funcionalidades implementadas no **Frontend Web** e **Backend** com o que está disponível no **Mobile Flutter**, identificando gaps e próximos passos para o desenvolvimento.

---

## Status Atual do Mobile

### ✅ Funcionalidades Implementadas

#### 1. Autenticação
- [x] Tela de login
- [x] Integração com API de autenticação (`/login`)
- [x] Armazenamento de sessão
- [x] Arquitetura MVVM com Riverpod
- [x] AuthApiService e AuthRepository

#### 2. Ordens de Serviço
- [x] Listagem de ordens de serviço
- [x] Criação de novas ordens
- [x] Integração com API (`/ordemservico`)
- [x] OrderServiceApi e OrderServiceRepository
- [x] OrderServiceViewModel
- [x] Interface para visualização de ordens (OrderView)
- [x] Card de ordem de serviço (OrderServiceCard)

#### 3. Estrutura e Arquitetura
- [x] Arquitetura MVVM (Model-View-ViewModel)
- [x] Gerenciamento de estado com Riverpod
- [x] Camadas bem definidas (data, domain, presentation)
- [x] Modelos de dados: UserModel, OrderServiceModel, PartModel, StockModel
- [x] Sistema de roteamento (router_notifier.dart)
- [x] Componentes compartilhados (ScaffoldHome, TextForm, ElevatedButton)
- [x] Sistema de logging

---

## ❌ Funcionalidades Pendentes (Existem no Web/Backend mas NÃO no Mobile)

### 1. Gestão de Estoque / Peças

**Status:** 🔴 NÃO IMPLEMENTADO

**O que existe no Web:**
- Listagem completa de peças com quantidades
- Cadastro de novas peças
- Edição de peças existentes
- Exclusão de peças
- Alertas visuais para estoque baixo
- Filtros e busca

**O que falta no Mobile:**
- [ ] Tela de listagem de estoque
- [ ] Tela/Modal de cadastro de peça
- [ ] Tela/Modal de edição de peça
- [ ] Funcionalidade de exclusão de peça
- [ ] Integração com endpoints:
  - `GET /peca` - Listar peças
  - `POST /peca` - Cadastrar peça
  - `PUT /peca/<id>` - Atualizar peça
  - `DELETE /peca/<id>` - Excluir peça
- [ ] ViewModel para gestão de estoque
- [ ] Repository e API Service para peças
- [ ] Cards/Widgets de exibição de peças
- [ ] Indicadores visuais de estoque baixo

**Prioridade:** 🔥 ALTA

---

### 2. Alertas de Estoque Baixo

**Status:** 🔴 NÃO IMPLEMENTADO

**O que existe no Web:**
- Sistema de alertas automático para estoque < qtd_min
- Visualização de peças em estado crítico
- Notificações visuais

**O que falta no Mobile:**
- [ ] Tela de alertas de estoque
- [ ] Integração com `GET /estoque/alertas`
- [ ] Notificações push (opcional)
- [ ] Badge indicador na navegação
- [ ] Cards de alerta com destaque visual
- [ ] ViewModel para alertas

**Prioridade:** 🔥 ALTA

---

### 3. Gestão de Usuários

**Status:** 🟡 PARCIALMENTE IMPLEMENTADO

**O que existe no Web:**
- Listagem de todos os usuários
- Cadastro de novos usuários
- Edição de usuários
- Exclusão de usuários

**O que existe no Mobile:**
- [x] Fetch de usuários para seleção em ordens de serviço
- [x] UserModel definido
- [x] Integração com `GET /usuarios`

**O que falta no Mobile:**
- [ ] Tela de listagem de usuários
- [ ] Tela/Modal de cadastro de usuário
- [ ] Tela/Modal de edição de usuário
- [ ] Funcionalidade de exclusão
- [ ] Integração com endpoints:
  - `POST /usuarios` - Criar usuário
  - `PUT /usuarios/<id>` - Atualizar usuário
  - `DELETE /usuarios/<id>` - Excluir usuário
- [ ] ViewModel para gestão de usuários
- [ ] Repository completo para usuários

**Prioridade:** 🟠 MÉDIA

---

### 4. Edição e Exclusão de Ordens de Serviço

**Status:** 🟡 PARCIALMENTE IMPLEMENTADO

**O que existe no Web:**
- Edição completa de ordens
- Atualização de status
- Exclusão de ordens

**O que existe no Mobile:**
- [x] Listagem de ordens
- [x] Criação de ordens

**O que falta no Mobile:**
- [ ] Tela/Modal de edição de ordem
- [ ] Funcionalidade de atualização de status
- [ ] Funcionalidade de exclusão de ordem
- [ ] Integração com endpoints:
  - `PUT /ordemservico/<id>` - Atualizar ordem
  - `DELETE /ordemservico/<id>` - Excluir ordem
- [ ] Botões de ação nos cards de ordem
- [ ] Confirmação de exclusão

**Prioridade:** 🟠 MÉDIA

---

### 5. Notificações

**Status:** 🔴 NÃO IMPLEMENTADO

**O que existe no Web:**
- Sistema local de notificações
- Central de notificações com histórico
- Notificações para estoque baixo
- Notificações de ações bem-sucedidas/erros
- Limpeza de notificações

**O que falta no Mobile:**
- [ ] Tela de notificações
- [ ] Sistema de notificações locais (SharedPreferences)
- [ ] Integração com `GET /notificacoes-estoque`
- [ ] Badge de notificações não lidas
- [ ] Notificações push (Firebase Cloud Messaging)
- [ ] ViewModel para notificações
- [ ] Cards de notificação
- [ ] Funcionalidade de limpar notificações

**Prioridade:** 🟠 MÉDIA

---

### 6. Relatórios

**Status:** 🔴 NÃO IMPLEMENTADO

**O que existe no Web:**
- Visualização de relatórios
- Filtros por período e categoria
- Estatísticas de estoque
- Histórico de ordens de serviço

**O que falta no Mobile:**
- [ ] Tela de relatórios
- [ ] Gráficos e estatísticas (ex: fl_chart package)
- [ ] Filtros de data
- [ ] Filtros por categoria
- [ ] Agregação de dados
- [ ] Exportação (opcional)
- [ ] ViewModel para relatórios

**Prioridade:** 🟡 BAIXA

---

### 7. Perfil do Usuário

**Status:** 🟡 PARCIALMENTE IMPLEMENTADO

**O que existe no Mobile:**
- [x] Tela de perfil básica (profile_view.dart)

**O que falta no Mobile:**
- [ ] Exibição completa dos dados do usuário
- [ ] Edição de perfil próprio
- [ ] Alteração de senha
- [ ] Foto de perfil
- [ ] Configurações do aplicativo

**Prioridade:** 🟡 BAIXA

---

### 8. Configurações

**Status:** 🟡 PARCIALMENTE IMPLEMENTADO

**O que existe no Mobile:**
- [x] Tela de configurações básica (setting_view.dart)

**O que falta no Mobile:**
- [ ] Configurações de notificações
- [ ] Tema (dark mode)
- [ ] Idioma
- [ ] Sobre o app
- [ ] Versão
- [ ] Logout

**Prioridade:** 🟡 BAIXA

---

## 📊 Comparação de Features (Backend ↔ Web ↔ Mobile)

| Feature                    | Backend API | Frontend Web | Mobile Flutter |
|----------------------------|-------------|--------------|----------------|
| Login                      | ✅          | ✅           | ✅             |
| Listar Usuários            | ✅          | ✅           | ✅ (parcial)   |
| Criar Usuário              | ✅          | ✅           | ❌             |
| Editar Usuário             | ✅          | ✅           | ❌             |
| Excluir Usuário            | ✅          | ✅           | ❌             |
| Listar Peças/Estoque       | ✅          | ✅           | ❌             |
| Criar Peça                 | ✅          | ✅           | ❌             |
| Editar Peça                | ✅          | ✅           | ❌             |
| Excluir Peça               | ✅          | ✅           | ❌             |
| Listar Ordens de Serviço   | ✅          | ✅           | ✅             |
| Criar Ordem de Serviço     | ✅          | ✅           | ✅             |
| Editar Ordem de Serviço    | ✅          | ✅           | ❌             |
| Excluir Ordem de Serviço   | ✅          | ✅           | ❌             |
| Alertas de Estoque         | ✅          | ✅           | ❌             |
| Notificações               | ✅          | ✅           | ❌             |
| Relatórios                 | ❌          | ✅ (client)  | ❌             |
| Perfil de Usuário          | ✅          | ❌           | 🟡 (básico)    |
| Configurações              | ❌          | ❌           | 🟡 (básico)    |

**Legenda:**
- ✅ Totalmente implementado
- 🟡 Parcialmente implementado
- ❌ Não implementado

---

## 🗂️ Estrutura de Arquivos Sugerida para Implementação

### 1. Para Gestão de Estoque

```
mobile/lib/
├── domain/
│   ├── models/
│   │   └── stock_model.dart (✅ já existe)
│   └── repository/
│       └── stock_repository.dart (❌ criar)
├── data/
│   ├── services/
│   │   └── stock_api.dart (❌ criar)
│   └── repository_impl/
│       └── stock_repository_impl.dart (❌ criar)
├── view_model/
│   └── stock_view_model.dart (❌ criar)
└── features/
    └── views/
        └── children/
            ├── stock_view.dart (❌ criar)
            └── stock_form_view.dart (❌ criar)
```

### 2. Para Alertas

```
mobile/lib/
├── domain/
│   └── repository/
│       └── alert_repository.dart (❌ criar)
├── data/
│   ├── services/
│   │   └── alert_api.dart (❌ criar)
│   └── repository_impl/
│       └── alert_repository_impl.dart (❌ criar)
├── view_model/
│   └── alert_view_model.dart (❌ criar)
└── features/
    └── views/
        └── children/
            └── alert_view.dart (❌ criar)
```

### 3. Para Notificações

```
mobile/lib/
├── domain/
│   ├── models/
│   │   └── notification_model.dart (❌ criar)
│   └── repository/
│       └── notification_repository.dart (❌ criar)
├── data/
│   ├── services/
│   │   └── notification_api.dart (❌ criar)
│   └── repository_impl/
│       └── notification_repository_impl.dart (❌ criar)
├── view_model/
│   └── notification_view_model.dart (❌ criar)
└── features/
    └── views/
        └── children/
            └── notification_view.dart (❌ criar)
```

---

## 🚀 Roadmap de Implementação Sugerido

### Sprint 1 - Gestão de Estoque (Essencial) 🔥
**Duração:** 2-3 semanas

1. **Criar estrutura de dados**
   - StockRepository interface
   - StockApi service
   - StockRepositoryImpl

2. **Implementar ViewModel**
   - StockViewModel com Riverpod
   - Estados: loading, success, error
   - Métodos: fetchParts, createPart, updatePart, deletePart

3. **Criar interfaces**
   - StockView (listagem)
   - StockFormView (cadastro/edição)
   - StockCard widget
   - Integração com navegação

4. **Testar integração**
   - Testar CRUD completo
   - Validar com backend
   - Ajustar modelos se necessário

### Sprint 2 - Alertas de Estoque 🔥
**Duração:** 1 semana

1. **Criar estrutura**
   - AlertRepository e AlertApi
   - AlertViewModel

2. **Implementar interface**
   - AlertView (listagem de alertas)
   - Badge na navegação
   - Cards de alerta com destaque

3. **Integração**
   - Endpoint `/estoque/alertas`
   - Atualização automática

### Sprint 3 - Edição de Ordens de Serviço 🟠
**Duração:** 1 semana

1. **Ampliar OrderServiceViewModel**
   - Adicionar updateOrder
   - Adicionar deleteOrder

2. **Criar interfaces**
   - OrderEditView
   - Botões de edição/exclusão nos cards
   - Dialogs de confirmação

3. **Integração**
   - Endpoints PUT e DELETE
   - Atualização da listagem

### Sprint 4 - Gestão de Usuários 🟠
**Duração:** 1-2 semanas

1. **Ampliar estrutura de usuários**
   - UserRepository completo
   - UserViewModel

2. **Criar interfaces**
   - UserListView
   - UserFormView
   - Integração CRUD completo

### Sprint 5 - Notificações 🟠
**Duração:** 1-2 semanas

1. **Implementar sistema local**
   - SharedPreferences para persistência
   - NotificationService

2. **Criar interfaces**
   - NotificationView
   - Badge de notificações
   - Sistema de limpeza

3. **Integração (opcional)**
   - Firebase Cloud Messaging
   - Push notifications

### Sprint 6 - Perfil e Configurações 🟡
**Duração:** 1 semana

1. **Completar ProfileView**
   - Exibir dados completos
   - Edição de perfil
   - Alteração de senha

2. **Completar SettingView**
   - Configurações funcionais
   - Tema (dark mode)
   - Logout

### Sprint 7 - Relatórios (Opcional) 🟡
**Duração:** 2 semanas

1. **Implementar visualizações**
   - Gráficos com fl_chart
   - Filtros de período

2. **Agregação de dados**
   - Estatísticas locais
   - Formatação de dados

---

## 📋 Checklist Resumido de Implementação

### Prioridade ALTA 🔥
- [ ] **Gestão de Estoque**
  - [ ] Listar peças
  - [ ] Cadastrar peça
  - [ ] Editar peça
  - [ ] Excluir peça
  - [ ] ViewModel e Repository
  - [ ] Interface completa

- [ ] **Alertas de Estoque**
  - [ ] Integração com `/estoque/alertas`
  - [ ] Tela de alertas
  - [ ] Badge de notificação
  - [ ] ViewModel

### Prioridade MÉDIA 🟠
- [ ] **Edição de Ordens**
  - [ ] Atualizar ordem
  - [ ] Excluir ordem
  - [ ] Interface de edição

- [ ] **Gestão de Usuários**
  - [ ] CRUD completo
  - [ ] Interface de listagem
  - [ ] Formulários

- [ ] **Notificações**
  - [ ] Sistema local
  - [ ] Tela de notificações
  - [ ] Badge

### Prioridade BAIXA 🟡
- [ ] **Relatórios**
  - [ ] Tela de relatórios
  - [ ] Gráficos
  - [ ] Filtros

- [ ] **Perfil e Configurações**
  - [ ] Completar perfil
  - [ ] Configurações funcionais
  - [ ] Tema dark

---

## 🛠️ Dependências Recomendadas

Adicionar ao `pubspec.yaml`:

```yaml
dependencies:
  # Já existentes
  flutter_riverpod: ^2.3.6
  http: ^1.0.0

  # Novas sugeridas
  shared_preferences: ^2.2.0      # Para notificações locais
  fl_chart: ^0.63.0               # Para gráficos (relatórios)
  cached_network_image: ^3.2.3    # Cache de imagens
  intl: ^0.18.1                   # Formatação de datas
  flutter_local_notifications: ^15.1.0  # Notificações locais
  firebase_messaging: ^14.6.5     # Push notifications (opcional)
```

---

## 📝 Notas Finais

1. **Arquitetura consistente:** Manter o padrão MVVM + Riverpod já estabelecido
2. **Reutilização de código:** Criar widgets compartilhados para forms, cards, etc.
3. **Tratamento de erros:** Implementar feedback visual apropriado
4. **Loading states:** Usar indicadores de carregamento em todas as operações assíncronas
5. **Validação:** Validar inputs antes de enviar para API
6. **Offline-first (futuro):** Considerar cache local e sincronização

---

## 🎯 Meta Final

Atingir **paridade completa** entre Mobile e Web, oferecendo todas as funcionalidades do sistema em ambas as plataformas, mantendo uma experiência de usuário consistente e de alta qualidade.

**Status Atual de Completude:** ~40% (4/10 features principais)
**Meta:** 100%

---

**Última atualização:** 11/10/2025
