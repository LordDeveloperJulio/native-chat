# LinguaAI 🌍

Aplicativo Flutter de aprendizado de inglês com IA conversacional. Converse com **Aria**, sua tutora de inglês, obtenha correções gramaticais em tempo real, aprenda palavras novas e acompanhe seu progresso.

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Framework | Flutter (null safety, SDK ^3.11.5) |
| IA | OpenAI GPT-4o (`gpt-4o`) |
| Banco local | Drift 2.x (SQLite) |
| Estado | Riverpod 2.x |
| HTTP | Dio 5.x |
| UI extras | Google Fonts (Nunito), fl_chart |

## Pré-requisitos

- Flutter SDK ≥ 3.11.5 instalado e no PATH
- Conta na [OpenAI](https://platform.openai.com) com uma chave de API válida
- Dart SDK ≥ 3.11.5 (incluso no Flutter)

## Setup

### 1. Clone e instale dependências

```bash
git clone <repo-url>
cd study_english
flutter pub get
```

### 2. Configure a chave de API

Copie o arquivo de exemplo e adicione sua chave:

```bash
cp .env.example .env
```

Edite `.env`:

```env
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxx
```

> **Atenção:** O arquivo `.env` já está no `.gitignore`. Nunca comite sua chave de API.

### 3. Gere o código do banco de dados (Drift)

```bash
dart run build_runner build --delete-conflicting-outputs
```

Este comando gera `lib/core/db/database.g.dart`. Execute novamente sempre que alterar `database.dart`.

### 4. Execute o aplicativo

```bash
flutter run
```

## Estrutura do projeto

```
lib/
├── core/
│   ├── api/
│   │   ├── openai_client.dart     # Cliente HTTP para GPT-4o
│   │   ├── prompt_builder.dart    # System prompt dinâmico da Aria
│   │   └── level_adapter.dart     # Adaptação automática de nível
│   ├── db/
│   │   ├── database.dart          # Tabelas e queries Drift
│   │   └── database.g.dart        # Gerado pelo build_runner (não editar)
│   └── models/
│       ├── user_profile.dart      # Modelo UI do usuário
│       ├── message.dart           # Modelo de mensagem do chat
│       └── ai_response.dart       # Parse da resposta JSON do GPT
├── features/
│   ├── home/                      # Tela inicial: streak e seleção de modo
│   ├── chat/                      # Conversa com a Aria
│   ├── progress/                  # Métricas, gráficos e erros frequentes
│   └── paywall/                   # Tela de assinatura premium
└── shared/
    ├── widgets/                   # Componentes reutilizáveis
    └── theme/                     # Cores e tipografia centralizadas
```

## Funcionalidades

- **4 modos de conversa:** Casual, Negócios, Viagem, Entrevista
- **Correção automática:** A Aria identifica erros gramaticais e vocabulares
- **Palavras novas:** Destaque de vocabulário relevante após cada resposta
- **Adaptação de nível:** O nível sobe/desce automaticamente com base na dificuldade das respostas
- **Streak diário:** Contagem de dias consecutivos de prática
- **Freemium:** 10 mensagens gratuitas por dia; tela de paywall para upgrade
- **Banco local:** Todo histórico e progresso salvos offline com SQLite/Drift

## Modos disponíveis

| Modo | Foco |
|------|------|
| Casual | Conversas do dia a dia, tom descontraído |
| Negócios | Inglês profissional, vocabulário formal |
| Viagem | Situações de turismo e deslocamento |
| Entrevista | Preparação para entrevistas de emprego |

## Variáveis de ambiente

| Variável | Descrição |
|----------|-----------|
| `OPENAI_API_KEY` | Chave de API da OpenAI (obrigatória) |

## Desenvolvimento

### Rebuild do banco após alterações

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Análise estática

```bash
dart analyze lib/
```

### Testes

```bash
flutter test
```

## Segurança

- A chave de API é lida exclusivamente do `.env` via `flutter_dotenv`
- O `.env` está no `.gitignore` por padrão
- Nenhuma chave ou dado sensível é hardcoded no código-fonte
# native-chat
