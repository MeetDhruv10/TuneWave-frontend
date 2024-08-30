import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tunewave/Views/Library.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key, required this.title});

  final String title;

  @override
  State<Playlist> createState() => _PlaylistState();
}

class PlaylistModel{
  final String name;
  PlaylistModel({required this.name});
}
class _PlaylistState extends State<Playlist> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            'Create Playlist',
            style: TextStyle(fontSize: 30.0),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Playlist Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24,
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Provide a default name if the user didn't enter one
                    if (_nameController.text.isEmpty) {
                      _nameController.text = 'Playlist 1';
                    }
                    final newPlaylist = PlaylistModel(name: _nameController.text);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Library(title: "L",playlist: newPlaylist)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('created Playlist: ${_nameController.text}')),
                    );
                  }
                },
                child: Text('Create Playlist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



