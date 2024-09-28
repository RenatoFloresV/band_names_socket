import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Bon Jovi', votes: 15),
    Band(id: '4', name: 'Led Zeppelin', votes: 3),
    Band(id: '5', name: 'Pink Floyd', votes: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
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
        builder: (context) => AlertDialog(
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
            MaterialButton(
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
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
              // color: Colors.blue,
              child: const Text('Add'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              // color: Colors.blue,
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  Widget _bandTile(Band band) {
    return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          print(direction);
        },
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
          title: Text(band.name),
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: band.votes > 5 ? Colors.lightGreen : Colors.red,
            child: Text(band.name.substring(0, 2)),
          ),
          trailing: Text('${band.votes}'),
        ));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
