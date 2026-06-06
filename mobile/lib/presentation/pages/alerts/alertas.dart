import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'alertaModel.dart';
import 'novoAlerta.dart';

class AlertasPage extends StatefulWidget {
  const AlertasPage({super.key});

  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  final List<Alerta> meusAlertas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Container(
              color: const Color(0xFF0B0F1A),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_none,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Meus Alertas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF651FFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        onPressed: () async {
                          final novo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NovoAlerta()),
                          );
                          if (novo != null) {
                            setState(() => meusAlertas.add(novo));
                          }
                        },
                        child: const Text(
                          '+ Novo alerta',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Gerencie suas alertas de preços de criptomoedas.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: meusAlertas.isEmpty
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF111622),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.05)),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 48,
                                  color: Colors.white24,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhum alerta criado ainda',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Clique em "Novo Alerta" para começar.',
                                  style: TextStyle(
                                      color: Colors.white38, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: meusAlertas.length,
                            itemBuilder: (context, index) {
                              final alerta = meusAlertas[index];
                              final descricaoSnippet = alerta.descricao.length >
                                      60
                                  ? alerta.descricao.substring(0, 60) + '...'
                                  : alerta.descricao;
                              return Card(
                                color: const Color(0xFF111622),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: const Icon(
                                      Icons.notifications_active,
                                      color: Color(0xFF00E5FF)),
                                  title: Text(
                                      '${alerta.titulo} • ${alerta.moeda}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(descricaoSnippet,
                                      style: const TextStyle(
                                          color: Colors.white70)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.white70),
                                        onPressed: () async {
                                          final edited = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NovoAlerta(alerta: alerta)),
                                          );
                                          if (edited != null) {
                                            setState(() =>
                                                meusAlertas[index] = edited);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () => setState(
                                            () => meusAlertas.removeAt(index)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const Footer(initialBottonClicked: 0),
        ],
      ),
    );
  }
}
