FROM dart:stable

WORKDIR /app

# Instalar Dart Frog CLI
RUN dart pub global activate dart_frog_cli

# Adicionar pub-cache ao PATH
ENV PATH="/root/.pub-cache/bin:$PATH"

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get
RUN dart_frog build

EXPOSE 8080

CMD ["dart", "run", "bin/server.dart"]