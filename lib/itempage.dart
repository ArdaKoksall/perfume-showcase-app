import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailScreen extends StatefulWidget {
  final dynamic perfume;
  const DetailScreen({super.key, required this.perfume});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _pageController = PageController();

  Future<String> _getImageUrl(String gsUrl) async {
    return await FirebaseStorage.instance.refFromURL(gsUrl).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: [
                      FutureBuilder<String>(
                        future: _getImageUrl(widget.perfume['imageurl']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 1,
                        effect: const WormEffect(
                          activeDotColor: Colors.amber,
                          dotColor: Colors.grey,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.perfume['name'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber, // Gold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.perfume['description'],
                    style: const TextStyle(color: Colors.white70)
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10, // Spacing between chips
                    runSpacing: 10, // Spacing between lines (if chips overflow to next line)
                    children: [
                      _buildSpecChip("${widget.perfume['ml']} ml"),
                      _buildSpecChip(widget.perfume['brand']),
                      _buildSpecChip(widget.perfume['aroma']),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      _buildSpecChip('${widget.perfume['price']} €'),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () async {
                          final Uri buyUrl = Uri.parse(widget.perfume['buyurl']);
                          if (!await launchUrl(buyUrl)) {
                            throw Exception('Could not launch $buyUrl');
                          }
                        },
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(String text) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.lightBlueAccent, // Light Coral
        ),
      ),
      backgroundColor: Color(0xFF2F4F4F), // Dark Slate Grey
      side: const BorderSide(color: Colors.amber), // Goldenrod
    );
  }


}
