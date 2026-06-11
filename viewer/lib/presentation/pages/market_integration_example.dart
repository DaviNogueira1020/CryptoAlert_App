import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/index.dart';

// Página para visualizar dados de mercado - exemplo de integração com a API
class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();
    // Carrega os dados de mercado quando a página inicia
    Future.microtask(() {
      context.read<MarketProvider>().loadMarketOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados de Mercado'),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Botão para atualizar os dados manualmente
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Força uma atualização dos dados de mercado
              context.read<MarketProvider>().refreshMarketData();
            },
          ),
        ],
      ),
      body: Consumer<MarketProvider>(
        builder: (context, marketProvider, child) {
          // Se está carregando, mostra um loading
          if (marketProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se teve erro, mostra a mensagem
          if (marketProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro: ${marketProvider.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => marketProvider.loadMarketOverview(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Se não tem dados de mercado, mostra mensagem
          if (marketProvider.marketData.isEmpty) {
            return const Center(
              child: Text('Nenhum dado de mercado disponível'),
            );
          }

          // Mostra a lista de ativos de mercado
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: marketProvider.marketData.length,
            itemBuilder: (context, index) {
              // Pega o ativo de mercado atual
              final market = marketProvider.marketData[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  // Mostra a imagem/logo se disponível
                  leading: market.imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(market.imageUrl!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.currency_bitcoin),
                        ),
                  
                  // Nome e símbolo da criptomoeda
                  title: Text('${market.name} (${market.symbol})'),
                  
                  // Preço em USD
                  subtitle: Text(
                    'Preço: \$${market.priceUsd.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),

                  // Mostra variação 24h se disponível (ainda em implementação)
                  trailing: market.change24h != null
                      ? Text(
                          '${market.change24h! > 0 ? '+' : ''}${market.change24h!.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: market.change24h! > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text('N/A'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
