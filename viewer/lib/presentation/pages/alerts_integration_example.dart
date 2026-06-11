import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/index.dart';

// Página para gerenciar alertas - exemplo de integração com a API
class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  // Variáveis para capturar dados do formulário
  late TextEditingController _symbolController;
  late TextEditingController _targetController;
  
  // Opção selecionada: 'above' ou 'below'
  String _selectedType = 'above';

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers
    _symbolController = TextEditingController();
    _targetController = TextEditingController();
    
    // Carrega os alertas quando a página inicia
    Future.microtask(() {
      context.read<AlertProvider>().loadAlerts();
    });
  }

  @override
  void dispose() {
    // Limpa os controllers quando a página é destruída
    _symbolController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  // Função que cria um novo alerta
  void _createAlert() {
    // Valida se os campos foram preenchidos
    if (_symbolController.text.isEmpty || _targetController.text.isEmpty) {
      // Mostra mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    // Converte o valor alvo para double
    final target = double.tryParse(_targetController.text);
    if (target == null) {
      // Se não conseguir converter, mostra erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preço inválido')),
      );
      return;
    }

    // Chama o provider para criar o alerta na API
    context.read<AlertProvider>().createAlert(
      symbol: _symbolController.text.toUpperCase(),
      target: target,
      type: _selectedType,
    );

    // Limpa os campos do formulário
    _symbolController.clear();
    _targetController.clear();

    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alerta criado com sucesso!')),
    );
  }

  // Função que deleta um alerta
  void _deleteAlert(String id) {
    // Pede confirmação antes de deletar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar alerta?'),
          content: const Text('Tem certeza que deseja deletar este alerta?'),
          actions: [
            // Botão Cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            // Botão Deletar
            TextButton(
              onPressed: () {
                // Chama o provider para deletar o alerta
                context.read<AlertProvider>().deleteAlert(id);
                Navigator.pop(context);
                
                // Mostra mensagem de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alerta deletado!')),
                );
              },
              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Alertas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<AlertProvider>(
        builder: (context, alertProvider, child) {
          // Se está carregando, mostra um loading
          if (alertProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se teve erro, mostra a mensagem
          if (alertProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro: ${alertProvider.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => alertProvider.loadAlerts(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Se não tem alertas, mostra mensagem
          if (alertProvider.alerts.isEmpty) {
            return const Center(
              child: Text('Nenhum alerta cadastrado'),
            );
          }

          // Mostra a lista de alertas
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de formulário para criar novo alerta
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Criar novo alerta',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        
                        // Campo de símbolo (ex: BTCUSDT)
                        TextField(
                          controller: _symbolController,
                          decoration: const InputDecoration(
                            labelText: 'Símbolo (ex: BTCUSDT)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Campo de preço alvo
                        TextField(
                          controller: _targetController,
                          decoration: const InputDecoration(
                            labelText: 'Preço alvo',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        
                        // Seletor de tipo (acima ou abaixo)
                        DropdownButton<String>(
                          value: _selectedType,
                          items: const [
                            DropdownMenuItem(value: 'above', child: Text('Acima de')),
                            DropdownMenuItem(value: 'below', child: Text('Abaixo de')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedType = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        
                        // Botão para criar alerta
                        ElevatedButton(
                          onPressed: _createAlert,
                          child: const Text('Criar alerta'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seção mostrando a lista de alertas
                const Text(
                  'Alertas cadastrados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Lista de alertas
                ...alertProvider.alerts.map((alert) {
                  return Card(
                    child: ListTile(
                      title: Text(alert.symbol),
                      subtitle: Text(
                        'Preço alvo: ${alert.target} | Tipo: ${alert.type}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ícone indicando se está ativo ou não
                          Icon(
                            alert.active ? Icons.check_circle : Icons.cancel,
                            color: alert.active ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          // Botão para deletar
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAlert(alert.id),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
