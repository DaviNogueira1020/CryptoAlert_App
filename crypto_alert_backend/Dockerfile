FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get

EXPOSE 8080

CMD ["dart", "run", "bin/server.dart"]