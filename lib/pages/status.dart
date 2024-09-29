import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    // final socketEmit = socketService.socket.emit(event);

    if (socketService.serverStatus == 'disconnected') {
      return const Text('El server está desconectado.');
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          socketService.emit('emit-message', {
            'name': 'Flutter',
            'message': 'Hola desde Flutter',
          });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status: ${socketService.serverStatus}'),
          ],
        ),
      ),
    );
  }
}
