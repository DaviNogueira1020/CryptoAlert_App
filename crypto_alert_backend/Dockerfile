FROM dart:stable AS build

WORKDIR /app

# 1. Ativa a CLI do Dart Frog globalmente dentro do container
RUN dart pub global activate dart_frog_cli

# 2. Adiciona o caminho dos executáveis globais do Dart ao PATH do Linux
ENV PATH="/root/.pub-cache/bin:${PATH}"

# 3. Copia os arquivos de dependências primeiro (aproveita o cache de camadas do Docker)
COPY pubspec.* ./
RUN dart pub get

# 4. Copia o restante do código-fonte do backend
COPY . .

# 5. Executa o build de produção do Dart Frog (cria a pasta autocontida /app/build)
RUN dart_frog build

# 6. Altera o diretório de trabalho para a pasta do build gerado
WORKDIR /app/build

# 7. Baixa as dependências específicas do build de produção
RUN dart pub get

# 8. Expõe a porta padrão
EXPOSE 8080

# 9. Inicializa o servidor编译 real de produção
CMD ["dart", "bin/server.dart"]