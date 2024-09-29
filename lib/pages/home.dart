import 'dart:io';

import '../models/band.dart';
import '../services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.on('initial-bands', _handleInitialBands);
    super.initState();
  }

  _handleInitialBands(dynamic payload) {
    bands = (List.from(payload)).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.off('initial-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: (socketService.serverStatus == ServerStatus.online)
                ? const Row(
                    children: [
                      Text('Online'),
                      SizedBox(width: 10.0),
                      Icon(Icons.wifi, color: Colors.green),
                    ],
                  )
                : const Row(
                    children: [
                      Text('Offline'),
                      SizedBox(width: 10.0),
                      Icon(Icons.wifi_off, color: Colors.red),
                    ],
                  ),
          ),
        ],
        title: const Text(
          'Band Voting App',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add new band'),
          content: TextFormField(
            controller: textController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Band Name',
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text),
              child: const Text('Add'),
            ),
            // MaterialButton(
            //   elevation: 5,
            //   textColor: Colors.blue,
            //   onPressed: () => Navigator.pop(context),
            //   child: const Text('Cancel'),
            // ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Add new band'),
          content: CupertinoTextField(
            controller: textController,
            onChanged: (value) {},
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => addBandToList(textController.text),
              child: const Text('Add'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) =>
            socketService.emit('delete-band', {'id': band.id}),
        background: Container(
          padding: const EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 10.0),
                Text(
                  'Delete band',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        child: ListTile(
          onTap: () => socketService.emit('vote', {'id': band.id}),
          title: Text(band.name),
          leading: CircleAvatar(
            radius: 20.0,
            child: Text(band.name.substring(0, 2)),
          ),
          trailing: Text('${band.votes}'),
        ));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }
}
