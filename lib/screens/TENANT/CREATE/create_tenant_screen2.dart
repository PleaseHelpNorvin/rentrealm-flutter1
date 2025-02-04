import 'package:flutter/material.dart';

class CreateTenantScreen2 extends StatefulWidget {
  const CreateTenantScreen2({super.key});

  @override
  State<CreateTenantScreen2> createState() => _CreateTenantScreen2State();
}

class _CreateTenantScreen2State extends State<CreateTenantScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("create tenant 2"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text("test2")
              ],
            ) 
          )
        ],
      ),
    );
  }
}