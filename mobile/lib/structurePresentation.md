lib/
├── main.dart
│
├── app/
│   ├── app.dart              # MaterialApp / configuração raiz
│   ├── routes.dart           # Definição de rotas
│   └── themes.dart           # Temas (dark/light)
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   ├── errors/
│   │   └── failures.dart
│   └── utils/
│       └── formatters.dart
│
├── data/
│   ├── models/               # Classes de dados (JSON → objeto)
│   │   └── crypto_model.dart
│   ├── repositories/         # Acessa APIs, banco, etc.
│   │   └── crypto_repository.dart
│   └── services/             # HTTP, WebSocket, notificações
│       ├── api_service.dart
│       └── notification_service.dart
│
├── domain/                   # Lógica de negócio pura
│   ├── entities/
│   └── usecases/
│
├── presentation/
│   ├── pages/                # = pages/ do React
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   └── home_controller.dart
│   │   └── alerts/
│   │       └── alerts_page.dart
│   ├── widgets/              # = components/ do React
│   │   ├── crypto_card.dart
│   │   └── price_badge.dart
│   └── controllers/          # Estado (GetX/Bloc/Provider)
│
└── shared/
    ├── widgets/              # Widgets genéricos reutilizáveis
    └── extensions/           # Extensions do Dart