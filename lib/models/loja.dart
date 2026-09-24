import 'cardapio.dart';

class Loja {
  final int id_loja;
  final String loja_nome;
  final String? loja_telefone;
  final String? loja_cnpj;
  final DateTime? loja_data_cadastro;
  final List<Cardapio> cardapios;

  const Loja({
    required this.id_loja,
    required this.loja_nome,
    required this.loja_telefone,
    required this.loja_cnpj,
    required this.loja_data_cadastro,
    required this.cardapios,
  });

  factory Loja.fromJson(Map<String, dynamic> json) {
    final rawCardapios = json['cardapios'];
    return Loja(
      id_loja: (json['id_loja'] as num?)?.toInt() ?? 0,
      loja_nome: json['loja_nome'] as String? ?? 'Loja sem nome',
      loja_telefone: json['loja_telefone'] as String?,
      loja_cnpj: json['loja_cnpj'] as String?,
      loja_data_cadastro: DateTime.tryParse(
        json['loja_data_cadastro'] as String? ?? '',
      ),
      cardapios: rawCardapios is List
          ? rawCardapios
              .whereType<Map<String, dynamic>>()
              .map(Cardapio.fromJson)
              .toList(growable: false)
          : const [],
    );
  }
}
