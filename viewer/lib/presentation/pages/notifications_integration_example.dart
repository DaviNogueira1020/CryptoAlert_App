import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/index.dart';

// Página para gerenciar notificações - exemplo de integração com a API
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Carrega as notificações quando a página inicia
    Future.microtask(() {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  // Função que marca uma notificação como lida
  void _markAsRead(String id) {
    context.read<NotificationProvider>().markAsRead(id);
  }

  // Função que deleta uma notificação
  void _deleteNotification(String id) {
    context.read<NotificationProvider>().deleteNotification(id);
    
    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notificação deletada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          // Se está carregando, mostra um loading
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se teve erro, mostra a mensagem
          if (notificationProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro: ${notificationProvider.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => notificationProvider.loadNotifications(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Se não tem notificações, mostra mensagem
          if (notificationProvider.notifications.isEmpty) {
            return const Center(
              child: Text('Nenhuma notificação'),
            );
          }

          // Mostra a lista de notificações
          return SingleChildScrollView(
            child: Column(
              children: [
                // Mostra quantidade de notificações não lidas
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.deepPurple.shade100,
                  child: Text(
                    'Não lidas: ${notificationProvider.unreadCount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Lista de notificações
                ...notificationProvider.notifications.map((notification) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      // Ícone para indicar se foi lida
                      leading: Icon(
                        notification.isRead ? Icons.done_all : Icons.mail,
                        color: notification.isRead ? Colors.grey : Colors.blue,
                      ),

                      // Mensagem da notificação
                      title: Text(
                        notification.message,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),

                      // Data de criação
                      subtitle: Text(
                        notification.createdAt.toString().split('.')[0],
                        style: const TextStyle(fontSize: 12),
                      ),

                      // Ações (marcar como lida e deletar)
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botão para marcar como lida
                          if (!notification.isRead)
                            IconButton(
                              icon: const Icon(Icons.done, color: Colors.blue),
                              onPressed: () => _markAsRead(notification.id),
                            ),

                          // Botão para deletar
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNotification(notification.id),
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
