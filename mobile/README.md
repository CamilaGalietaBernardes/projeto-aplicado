# Mobile - Sistema de Gestão de Peças e Manutenção

Aplicativo mobile desenvolvido em Flutter para gerenciar estoque de peças, ordens de serviço e alertas. Integrado com o backend Flask hospedado no Render.

**Status:** 90% Completo - Em Desenvolvimento Ativo 🚀

---

## 🚀 Tecnologias Utilizadas

- **Flutter** 3.8+ - Framework multiplataforma
- **Dart** 3.8+ - Linguagem de programação
- **Riverpod** 2.6.1 - Gerenciamento de estado
- **Go Router** 16.0.0 - Navegação e rotas
- **HTTP** 1.2.0 - Requisições para API
- **ScreenUtil** 5.9.3 - Responsividade
- **SharedPreferences** 2.3.4 - Persistência local
- **Google Fonts** 6.2.1 - Tipografia
- **Intl** 0.20.2 - Formatação de datas

---

## 📱 Funcionalidades Implementadas

### ✅ Autenticação
- Login com email e senha
- Validação via backend
- Persistência de sessão com SharedPreferences
- Proteção de rotas
- Redirect automático

### ✅ Ordens de Serviço
- Listagem completa de ordens
- Criação de novas ordens
- **Edição de status** ✨
- **Exclusão de ordens** ✨
- Busca e filtros por status
- Cards visuais informativos
- Seleção de peças utilizadas
- Controle de técnicos responsáveis

### ✅ Gestão de Estoque ✨ COMPLETO
- Listagem de todas as peças
- Cadastro de novas peças
- Edição de peças existentes
- Exclusão de peças
- Busca por nome/categoria
- Filtros por categoria
- Indicadores visuais de estoque baixo
- Atualização em tempo real

### ✅ Alertas de Estoque ✨ COMPLETO
- Peças com estoque abaixo do mínimo
- Cards destacados com métricas
- Barra de progresso visual
- Atualização rápida de estoque
- Navegação integrada
- Endpoint `/estoque/alertas` integrado

### ✅ Gestão de Usuários ✨ NOVO
- Listagem de todos os usuários
- Cadastro de novos usuários
- Edição de usuários existentes
- Exclusão de usuários
- Busca e filtros por setor
- Cards informativos
- Integração completa com backend
- Notificações de sucesso/erro

### ✅ Sistema de Notificações ✨ NOVO
- Central de notificações completa
- Badge com contador no AppBar
- Notificações locais persistentes (SharedPreferences)
- 4 tipos de notificação:
  - ✅ SUCCESS (verde) - Operações bem-sucedidas
  - ❌ ERROR (vermelho) - Erros e falhas
  - ⚠️ WARNING (laranja) - Alertas de estoque
  - ℹ️ INFO (azul) - Informações gerais
- Marcar como lida/não lida
- Swipe para excluir
- Limpar todas
- Notificações automáticas:
  - Alertas de estoque baixo
  - CRUD de usuários (criar/editar/excluir)
- Limite de 50 notificações (auto-limpeza)

---

## 🏗️ Arquitetura

### Padrão: MVVM + Clean Architecture + Riverpod

```
mobile/lib/
├── core/                      # Configurações globais
│   ├── constants/             # Constantes e configurações
│   ├── providers/             # Providers globais
│   └── utils/                 # Utilitários (logger)
├── domain/                    # Camada de domínio
│   ├── models/                # Modelos de dados
│   │   ├── user_model.dart
│   │   ├── stock_model.dart
│   │   ├── order_service_model.dart
│   │   ├── notification_model.dart ✨ NOVO
│   │   └── part_model.dart
│   └── repository/            # Interfaces dos repositórios
│       ├── auth_repository.dart
│       ├── stock_repository.dart
│       ├── user_repository.dart ✨ NOVO
│       ├── notification_repository.dart ✨ NOVO
│       └── order_service_repository.dart
├── data/                      # Camada de dados
│   ├── services/              # APIs e serviços externos
│   │   ├── auth_api.dart
│   │   ├── stock_api.dart
│   │   ├── user_api.dart ✨ NOVO
│   │   ├── notification_local_service.dart ✨ NOVO
│   │   └── order_service_api.dart
│   └── repository_impl/       # Implementações dos repositórios
│       ├── auth_repository_impl.dart
│       ├── stock_repository_impl.dart
│       ├── user_repository_impl.dart ✨ NOVO
│       ├── notification_repository_impl.dart ✨ NOVO
│       └── order_service_repository_impl.dart
├── view_model/                # ViewModels (lógica de negócio)
│   ├── login_view_model.dart
│   ├── stock_view_model.dart
│   ├── user_view_model.dart ✨ NOVO
│   ├── notification_view_model.dart ✨ NOVO
│   ├── stock_notification_provider.dart ✨ NOVO
│   └── order_service_view_model.dart
├── features/                  # Telas da aplicação
│   ├── auth/
│   │   └── login_view.dart
│   └── views/
│       ├── home_view.dart
│       ├── profile_view.dart
│       └── children/
│           ├── order_view.dart
│           ├── stock_view.dart ✨
│           ├── stock_alerts_view.dart ✨
│           ├── user_list_view.dart ✨ NOVO
│           ├── notifications_view.dart ✨ NOVO
│           └── setting_view.dart
├── presentation/              # Componentes de UI
│   ├── shared_widgets/        # Widgets reutilizáveis
│   │   ├── scaffold_home.dart (com badge ✨)
│   │   ├── text_form.dart
│   │   └── elevated_button.dart
│   ├── widgets/               # Widgets específicos
│   │   └── order_service_card.dart
│   └── theme/
│       └── app_colors.dart
├── routes/                    # Configuração de rotas
│   ├── app_router.dart
│   └── router_notifier.dart
└── main.dart                  # Entry point
```

---

## 🔌 Integração com Backend

**Base URL:** `http://localhost:5000`

### Endpoints Utilizados

#### Autenticação
```
POST   /login                  # Login de usuário
```

#### Usuários
```
GET    /usuarios               # Listar usuários ✨
POST   /usuarios               # Criar usuário ✨
PUT    /usuarios/<id>          # Atualizar usuário ✨
DELETE /usuarios/<id>          # Excluir usuário ✨
```

#### Estoque/Peças
```
GET    /peca                   # Listar peças ✨
POST   /peca                   # Criar peça ✨
PUT    /peca/<id>              # Atualizar peça ✨
DELETE /peca/<id>              # Excluir peça ✨
GET    /estoque/alertas        # Alertas de estoque baixo ✨
```

#### Ordens de Serviço
```
GET    /ordemservico           # Listar ordens
POST   /ordemservico           # Criar ordem
PUT    /ordemservico/<id>      # Atualizar ordem ✨
DELETE /ordemservico/<id>      # Excluir ordem ✨
```

---

## 🚦 Rotas do Aplicativo

```dart
/login                         # Tela de login (pública)
/home                          # Home - Lista de ordens
  /home/childA                 # Criar nova ordem
/stock                         # Gestão de estoque ✨
  /stock/alerts                # Alertas de estoque ✨
/settings                      # Configurações
  /settings/users              # Gestão de usuários ✨ NOVO
  /settings/notifications      # Central de notificações ✨ NOVO
```

---

## 📦 Instalação e Execução

### Pré-requisitos
- Flutter SDK 3.8+
- Dart SDK 3.8+
- Android Studio / Xcode (para emuladores)
- Dispositivo físico ou emulador configurado

### Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/camilagalieta/projeto-aplicado.git
cd projeto-aplicado/mobile
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Execute o aplicativo:**
```bash
flutter run
```

### Build para Produção

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📊 Gerenciamento de Estado

### Riverpod Providers

**AuthViewModel:**
```dart
sessionProvider              # Sessão do usuário
```

**StockViewModel:**
```dart
stockViewModelProvider       # Lista de peças
lowStockAlertsProvider       # Alertas de estoque
stockSearchQueryProvider     # Busca
stockCategoryFilterProvider  # Filtro de categoria
```

**UserViewModel:** ✨ NOVO
```dart
userViewModelProvider        # Lista de usuários
userSearchQueryProvider      # Busca de usuários
userSetorFilterProvider      # Filtro por setor
```

**NotificationViewModel:** ✨ NOVO
```dart
notificationViewModelProvider      # Lista de notificações
unreadNotificationCountProvider    # Contador de não lidas
stockNotificationMonitorProvider   # Monitor de alertas
```

**OrderServiceViewModel:**
```dart
orderListProvider            # Lista de ordens
orderServiceNotifierProvider # Criação/Edição/Exclusão
searchQueryProvider          # Busca de ordens
statusFilterProvider         # Filtro de status
```

---

## 🔔 Sistema de Notificações

### Tipos de Notificação

| Tipo | Cor | Uso |
|------|-----|-----|
| SUCCESS | 🟢 Verde | Operações bem-sucedidas |
| ERROR | 🔴 Vermelho | Erros e falhas |
| WARNING | 🟠 Laranja | Alertas de estoque |
| INFO | 🔵 Azul | Informações gerais |

### Notificações Automáticas

- ✅ **Estoque Baixo**: Quando peça < mínimo
- ✅ **Usuário Criado**: Sucesso ao criar usuário
- ✅ **Usuário Atualizado**: Sucesso ao editar
- ✅ **Usuário Excluído**: Sucesso ao excluir
- ✅ **Erros de Operação**: Falhas em CRUD

### Recursos

- Persistência local (SharedPreferences)
- Badge com contador no AppBar
- Central de notificações completa
- Marcar como lida
- Swipe para excluir
- Limpar todas
- Pull-to-refresh
- Limite de 50 notificações

---

## 🐛 Troubleshooting

### Erro ao carregar dados
- Verificar conexão com internet
- Verificar se backend está online
- Verificar logs no console

### Erro de compilação
```bash
flutter clean
flutter pub get
flutter run
```

### Problemas com navegação
- Verificar `app_router.dart`
- Usar `context.go()` para navegação entre shells
- Usar `context.push()` para navegação aninhada

---

## 📈 Roadmap

### ✅ Sprint 1 - Gestão de Estoque (COMPLETO)
- ✅ Gestão completa de estoque
- ✅ Sistema de alertas
- ✅ Edição/Exclusão de ordens

### ✅ Sprint 2 - Gestão de Usuários (COMPLETO)
- ✅ Tela de listagem de usuários
- ✅ Cadastro de usuários
- ✅ Edição de usuários
- ✅ Exclusão de usuários

### ✅ Sprint 3 - Notificações (COMPLETO)
- ✅ Sistema de notificações locais
- ✅ Central de notificações
- ✅ Badge de notificações não lidas
- ✅ Notificações automáticas de estoque
- ✅ Notificações CRUD de usuários

### 🚧 Sprint 4 - Relatórios e Perfil (PRÓXIMO)
- [ ] Tela de relatórios com gráficos
- [ ] Completar tela de perfil
- [ ] Configurações funcionais completas
- [ ] Logout funcional
- [ ] Dark mode
- [ ] Alteração de senha

---

## 📄 Documentação Adicional

- [SISTEMA_NOTIFICACOES_COMPLETO.md](./SISTEMA_NOTIFICACOES_COMPLETO.md) - Documentação técnica do sistema de notificações
- [IMPLEMENTACOES_REALIZADAS.md](./IMPLEMENTACOES_REALIZADAS.md) - Detalhes das implementações recentes
- [ROADMAP_PARA_100.md](./ROADMAP_PARA_100.md) - Plano completo para 100%
- [FUNCIONALIDADES_PENDENTES_MOBILE.md](../FUNCIONALIDADES_PENDENTES_MOBILE.md) - Features pendentes
- [Backend README](../backend/README.md) - Documentação da API
- [Frontend README](../frontend/README.md) - Documentação do web

---

## 📊 Métricas do Projeto

| Métrica | Valor |
|---------|-------|
| Progresso Geral | 90% |
| Arquivos de Código | 50+ |
| Linhas de Código | ~5000 |
| ViewModels | 5 |
| Repositories | 5 |
| Telas Implementadas | 10+ |
| Providers Riverpod | 15+ |
| Integrações API | 18 endpoints |

---

## 🎯 Comparação de Features

| Feature | Backend | Web | Mobile |
|---------|---------|-----|--------|
| Autenticação | ✅ | ✅ | ✅ |
| Gestão de Usuários | ✅ | ✅ | ✅ ✨ |
| Gestão de Estoque | ✅ | ✅ | ✅ ✨ |
| Alertas de Estoque | ✅ | ✅ | ✅ ✨ |
| Ordens de Serviço | ✅ | ✅ | ✅ |
| Notificações | ✅ | ✅ | ✅ ✨ |
| Relatórios | ❌ | ✅ | ⏳ |
| Perfil Completo | ✅ | ❌ | ⏳ |
| Configurações | ❌ | ❌ | ⏳ |

**Legenda:**
- ✅ Implementado
- ✨ Implementado recentemente
- ⏳ Em desenvolvimento
- ❌ Não implementado

---

## 📝 Licença

Este projeto foi desenvolvido para fins acadêmicos no SENAI - Projeto Aplicado III.

---

**Status do Projeto:** 90% Completo - Em Desenvolvimento Ativo 🚀
**Última Atualização:** 11/10/2025

---

## 🏆 Conquistas Recentes

### Fase 1: Gestão de Usuários ✅
- Interface completa CRUD
- Integração com backend
- Notificações automáticas

### Fase 2: Sistema de Notificações ✅
- Arquitetura completa (Domain, Data, ViewModel, View)
- 4 tipos de notificação
- Persistência local
- Badge em tempo real
- Integrações automáticas

### Progresso Total: 75% → 90% (+15%) 🎉

---

**Desenvolvido com ❤️ usando Flutter + Riverpod**
