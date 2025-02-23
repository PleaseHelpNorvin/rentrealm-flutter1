import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OuterCreateTenantScreen3 extends StatefulWidget {
  const OuterCreateTenantScreen3({super.key});

  @override
  State<OuterCreateTenantScreen3> createState() =>
      _OuterCreateTenantScreen3State();
}

class _OuterCreateTenantScreen3State extends State<OuterCreateTenantScreen3> {
  late List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Details"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  final String imagePath;

  const ImagePlaceHolder({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
