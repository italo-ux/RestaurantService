import 'package:flutter/material.dart';

import '../models/loja.dart';
import '../services/delivery_service.dart';
import 'cardapios_screen.dart';

class LojasScreen extends StatefulWidget {
  const LojasScreen({super.key});

  @override
  State<LojasScreen> createState() => _LojasScreenState();
}

class _LojasScreenState extends State<LojasScreen> {
  final DeliveryService _service = DeliveryService();
  late Future<List<Loja>> _lojasFuture;

  @override
  void initState() {
    super.initState();
    _lojasFuture = _service.buscarLojas();
  }

  void _recarregar() {
    setState(() => _lojasFuture = _service.buscarLojas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F3),
      appBar: AppBar(
        title: const Text('Delivery'),
        actions: [
          IconButton(
            tooltip: 'Atualizar lojas',
            onPressed: _recarregar,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<Loja>>(
        future: _lojasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _EstadoCarregando(label: 'Buscando lojas…');
          }
          if (snapshot.hasError) {
            return _EstadoAviso(
              mensagem: 'Não foi possível carregar as lojas.\n${snapshot.error}',
              onTentarNovamente: _recarregar,
            );
          }

          final lojas = snapshot.data ?? const <Loja>[];
          if (lojas.isEmpty) {
            return _EstadoAviso(
              mensagem: 'Nenhuma loja encontrada.',
              onTentarNovamente: _recarregar,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _recarregar(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                const Text(
                  'Escolha uma loja',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  '${lojas.length} ${lojas.length == 1 ? 'loja disponível' : 'lojas disponíveis'}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 18),
                ...lojas.map((loja) => _LojaCard(
                      loja: loja,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CardapiosScreen(
                            id_loja: loja.id_loja,
                            nomeLoja: loja.loja_nome,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LojaCard extends StatelessWidget {
  const _LojaCard({required this.loja, required this.onTap});

  final Loja loja;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F1E7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.storefront_rounded,
                    color: Color(0xFF276749), size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loja.loja_nome,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text(
                      loja.loja_telefone?.isNotEmpty == true
                          ? loja.loja_telefone!
                          : 'Telefone não informado',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${loja.cardapios.length} ${loja.cardapios.length == 1 ? 'cardápio' : 'cardápios'}',
                      style: const TextStyle(
                          color: Color(0xFF276749), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoCarregando extends StatelessWidget {
  const _EstadoCarregando({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(label),
        ]),
      );
}

class _EstadoAviso extends StatelessWidget {
  const _EstadoAviso({required this.mensagem, required this.onTentarNovamente});
  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.info_outline_rounded,
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
