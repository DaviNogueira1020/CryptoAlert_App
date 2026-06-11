FROM dart:stable AS build

WORKDIR /app

# Instalar Dart Frog CLI
RUN dart pub global activate dart_frog_cli

# Adicionar pub-cache ao PATH
ENV PATH="/root/.pub-cache/bin:$PATH"

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart_frog build
# garante build persistente
RUN ls -la .dart_frog

EXPOSE 8080

CMD ["dart", "run", "bin/server.dart"]