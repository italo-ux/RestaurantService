# DeliveryService

Aplicativo Flutter com duas telas: catálogo de lojas e cardápios por loja.

## Executar

1. Instale o Flutter SDK e configure um emulador ou dispositivo.
2. No terminal, entre nesta pasta e execute `flutter pub get`.
3. Execute `flutter run`.

## Organização

- `lib/models/`: modelos `Loja` e `Cardapio`, com `fromJson`.
- `lib/services/`: requisições GET, validação HTTP/`success` e leitura da lista `data`.
- `lib/screens/`: telas de lojas e cardápios, usando `FutureBuilder`.
- `lib/main.dart`: tema e inicialização do app.

As rotas consultadas são `GET /api/lojas` e `GET /api/lojas/{id_loja}/cardapios`.
