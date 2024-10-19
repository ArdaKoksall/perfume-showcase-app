import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:video_player/video_player.dart'; // Import video_player package
import 'firebase_options.dart';
import 'itempage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white70),
        displayLarge: TextStyle(color: Color(0xFFFF0000), fontSize: 36, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
      ),
    ),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  bool _showPerfumes = true; // Track whether to show or hide the items
  bool _videoPlaying = true;

  Future<String> _getImageUrl(String gsUrl) async {
    return await FirebaseStorage.instance.refFromURL(gsUrl).getDownloadURL();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/background.mp4')
      ..initialize().then((_) {
        setState(() {}); // To refresh the UI once the video is loaded
        _controller.setLooping(true); // Loop the video
        _controller.play(); // Start playing the video
      });
  }

  void video() {
    setState(() {
      if (_videoPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _videoPlaying = !_videoPlaying;
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Video background instead of image
          Positioned.fill(
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio, // Maintain the video's aspect ratio
              child: VideoPlayer(_controller),
            )
                : Container(color: Colors.black), // Show a black screen until the video loads
          ),
          // Overlay dark layer for contrast
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.4), // Dark overlay for contrast
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Royal\nQuality",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF0000),
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black87,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Energetic aromatic fougere fragrance for all the ways you play.",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                // Row to hold the visibility toggle button and video control button
                Row(
                  children: [
                    // IconButton to toggle the visibility of the perfumes
                    IconButton(
                      icon: Icon(
                        _showPerfumes ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPerfumes = !_showPerfumes;
                        });
                      },
                    ),
                    const SizedBox(width: 10), // Add some spacing between buttons
                    // IconButton to control the video play/pause
                    IconButton(
                      icon: Icon(
                        _videoPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: video,
                    ),
                  ],
                ),

                // Perfume list, shown or hidden based on _showPerfumes
                _showPerfumes
                    ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('perfumes').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var perfumes = snapshot.data!.docs;

                      // Shuffle the perfumes and pick the first 5
                      perfumes.shuffle(Random());
                      var randomPerfumes = perfumes.take(5).toList();

                      return PageView.builder(
                        controller: PageController(viewportFraction: 0.7),
                        itemCount: randomPerfumes.length,
                        itemBuilder: (context, index) {
                          var perfume = randomPerfumes[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(perfume: perfume),
                                ),
                              );
                            },
                            child: FutureBuilder<String>(
                              future: _getImageUrl(perfume['imageurl']),
                              builder: (context, imageSnapshot) {
                                if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (imageSnapshot.hasError || !imageSnapshot.hasData) {
                                  return const Center(child: Text('Error loading image'));
                                }

                                return Card(
                                  color: const Color(0xFF3D0000), // Dark red
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(color: Color(0xFFFF0000), width: 2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                        child: CachedNetworkImage(
                                          imageUrl: imageSnapshot.data!,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              perfume['name'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFFD1D1D1),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${perfume['price']} €',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
                    : const SizedBox(), // Hide perfumes if _showPerfumes is false
              ],
            ),
          ),
        ],
      ),
    );
  }
}
