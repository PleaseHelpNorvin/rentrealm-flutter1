import 'package:flutter/material.dart';

class CreateTenantScreen1 extends StatefulWidget {
  const CreateTenantScreen1({super.key});

  @override
  State<CreateTenantScreen1> createState() => _CreateTenantScreen1State();
}

class _CreateTenantScreen1State extends State<CreateTenantScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("create tenant 1"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text("test")
              ],
            ) 
          )
        ],
      ),
    );
  }
}