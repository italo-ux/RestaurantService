import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cardapio.dart';
import '../models/loja.dart';

class DeliveryService {
  static const String _baseUrl = 'https://delivery-umtc.onrender.com';
  final http.Client _client;

  DeliveryService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Loja>> buscarLojas() async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/api/lojas'))
        .timeout(const Duration(seconds: 20));
    final data = _lerData(response, 'Não foi possível carregar as lojas.');
    return data
        .whereType<Map<String, dynamic>>()
        .map(Loja.fromJson)
        .toList(growable: false);
  }

  Future<List<Cardapio>> buscarCardapios(int id_loja) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/api/lojas/$id_loja/cardapios'))
        .timeout(const Duration(seconds: 20));
    final data = _lerData(response, 'Não foi possível carregar os cardápios.');
    return data
        .whereType<Map<String, dynamic>>()
        .map(Cardapio.fromJson)
        .toList(growable: false);
  }

  List<dynamic> _lerData(http.Response response, String mensagemErro) {
    if (response.statusCode != 200) {
      throw Exception('$mensagemErro (HTTP ${response.statusCode})');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw Exception('A API retornou uma resposta inválida.');
    }

    if (decoded is! Map<String, dynamic> || decoded['success'] != true) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : null;
      throw Exception(message?.isNotEmpty == true ? message : mensagemErro);
    }

    final data = decoded['data'];
    if (data is! List) {
      throw Exception('A resposta da API não contém uma lista em "data".');
    }
    return data;
  }
}
