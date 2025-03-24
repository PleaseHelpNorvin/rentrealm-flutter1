import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PropertyMapScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String propertyName;

  const PropertyMapScreen({
    super.key,
    required this.lat,
    required this.long,
    required this.propertyName,
  });

  @override
  State<PropertyMapScreen> createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  final double staticLat = 10.315397; //remove for dynamic use
  final double staticLong = 123.997458; //remove for dynamic use
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue, // Same as AppBar background
            border: Border(
              bottom: BorderSide(color: Colors.blue.shade900, width: 3), // Blue border at the bottom
            ),
          ),
          child: AppBar(
            title: Text("Apartment-${widget.propertyName}'s Location"),
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            foregroundColor: Colors.white,
            elevation: 0, // Remove AppBar shadow
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          // initialCenter: LatLng(widget.lat, widget.long), // ✅ uncomment for dynamic use
          initialCenter: LatLng(staticLat, staticLong),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 100.0,
                height: 100.0,
                // point: LatLng(widget.lat, widget.long), //uncomment for dynamic use
                point: LatLng(staticLat, staticLong), //comment for dynamic use
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
