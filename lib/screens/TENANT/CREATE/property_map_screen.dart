import 'package:flutter/material.dart';

class PropertyMapScreen extends StatefulWidget {
  final double lat;
  final double long; 

  const PropertyMapScreen({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  State<PropertyMapScreen> createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
 
  @override
  void initState() {
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Map"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text("test map screen")
          ],
        ),
      ),
    );
  }
}