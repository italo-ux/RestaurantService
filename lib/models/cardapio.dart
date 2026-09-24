class Cardapio {
  final int id_cardapio;
  final int cardapio_id_loja;
  final String cardapio_nome;
  final bool cardapio_ativo;
  final List<dynamic> disponibilidades;
  final List<dynamic> produtos;

  const Cardapio({
    required this.id_cardapio,
    required this.cardapio_id_loja,
    required this.cardapio_nome,
    required this.cardapio_ativo,
    required this.disponibilidades,
    required this.produtos,
  });

  factory Cardapio.fromJson(Map<String, dynamic> json) {
    return Cardapio(
      id_cardapio: (json['id_cardapio'] as num?)?.toInt() ?? 0,
      cardapio_id_loja: (json['cardapio_id_loja'] as num?)?.toInt() ?? 0,
      cardapio_nome: json['cardapio_nome'] as String? ?? 'Cardápio sem nome',
      cardapio_ativo: json['cardapio_ativo'] as bool? ?? false,
      disponibilidades: _asList(json['disponibilidades']),
      produtos: _asList(json['produtos']),
    );
  }

  static List<dynamic> _asList(dynamic value) =>
      value is List ? List<dynamic>.unmodifiable(value) : const [];
}
