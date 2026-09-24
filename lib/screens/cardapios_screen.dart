import 'package:flutter/material.dart';

import '../models/cardapio.dart';
import '../services/delivery_service.dart';

class CardapiosScreen extends StatefulWidget {
  const CardapiosScreen({
    super.key,
    required this.id_loja,
    required this.nomeLoja,
  });

  final int id_loja;
  final String nomeLoja;

  @override
  State<CardapiosScreen> createState() => _CardapiosScreenState();
}

class _CardapiosScreenState extends State<CardapiosScreen> {
  final DeliveryService _service = DeliveryService();
  late Future<List<Cardapio>> _cardapiosFuture;

  @override
  void initState() {
    super.initState();
    _cardapiosFuture = _service.buscarCardapios(widget.id_loja);
  }

  void _recarregar() {
    setState(
      () => _cardapiosFuture = _service.buscarCardapios(widget.id_loja),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F3),
      appBar: AppBar(title: Text(widget.nomeLoja)),
      body: FutureBuilder<List<Cardapio>>(
        future: _cardapiosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                CircularProgressIndicator(),
                SizedBox(height: 14),
                Text('Buscando cardápios…'),
              ]),
            );
          }
          if (snapshot.hasError) {
            return _AvisoCardapios(
              mensagem:
                  'Não foi possível carregar os cardápios.\n${snapshot.error}',
              onTentarNovamente: _recarregar,
            );
          }

          final cardapios = snapshot.data ?? const <Cardapio>[];
          if (cardapios.isEmpty) {
            return _AvisoCardapios(
              mensagem: 'Esta loja ainda não tem cardápios disponíveis.',
              onTentarNovamente: _recarregar,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _recarregar(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                const Text('Cardápios',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Opções de ${widget.nomeLoja}',
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 18),
                ...cardapios.map((cardapio) => _CardapioCard(cardapio: cardapio)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardapioCard extends StatelessWidget {
  const _CardapioCard({required this.cardapio});
  final Cardapio cardapio;

  @override
  Widget build(BuildContext context) {
    final ativo = cardapio.cardapio_ativo;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0DB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.restaurant_menu_rounded,
                  color: Color(0xFFB45309)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cardapio.cardapio_nome,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _Tag(
                      label: ativo ? 'Disponível' : 'Indisponível',
                      color: ativo ? const Color(0xFFE7F1E7) : Colors.black12,
                      textColor: ativo ? const Color(0xFF276749) : Colors.black54,
                    ),
                    _Tag(
                      label:
                          '${cardapio.produtos.length} ${cardapio.produtos.length == 1 ? 'produto' : 'produtos'}',
                      color: const Color(0xFFF0F1EF),
                      textColor: Colors.black87,
                    ),
                  ]),
                  if (cardapio.produtos.isEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Nenhum produto listado neste cardápio.',
                        style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label,
            style: TextStyle(
                color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

class _AvisoCardapios extends StatelessWidget {
  const _AvisoCardapios({
    required this.mensagem,
    required this.onTentarNovamente,
  });

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.menu_book_rounded,
                size: 44, color: Color(0xFF276749)),
            const SizedBox(height: 12),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ]),
        ),
      );
}
