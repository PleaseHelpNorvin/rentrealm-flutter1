import 'package:flutter/material.dart';

class CreateRent extends StatefulWidget {
  @override
  CreateRentState createState() => CreateRentState();
}

class CreateRentState extends State<CreateRent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Now!'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("Tetetetest"),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
