import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // For video playback
import 'package:url_launcher/url_launcher.dart'; // For launching external links

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Into Jesus Church',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    // Initialize video player
    _videoController = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/lifeintojesuschurch.appspot.com/o/videos%2Fcompl.mp4?alt=media&token=fda00cbf-a521-4ed5-9cac-e57a196617fb',
    )..initialize().then((_) {
        setState(() {}); // Rebuild to display video once it's initialized
        _videoController.setLooping(true);
        _videoController.play(); // Start video playback
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose video controller
    super.dispose();
  }

  // Method to open donation form
  void _openDonationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Donate"),
          content: _DonationForm(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Method to open membership form
  void _openMembershipModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join Us"),
          content: _MembershipForm(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Into Jesus Church'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Home Section with Video Background
            Stack(
              children: [
                _videoController.value.isInitialized
                    ? SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: VideoPlayer(_videoController),
                      )
                    : Container(height: 400, color: Colors.black),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to Our Church',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _openDonationModal,
                        child: const Text('Donate'),
                      ),
                      ElevatedButton(
                        onPressed: _openMembershipModal,
                        child: const Text('Join'),
                      ),
                      ElevatedButton(
                        onPressed: () => _launchURL(
                            'https://www.youtube.com/@LIFEINJESUSTV'),
                        child: const Text('Watch'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildSection(
              'Who We Are',
              'We are a community of believers committed to spreading the love of Jesus.',
            ),
            _buildSection(
              'Sermons',
              'Watch our latest sermons here.',
            ),
            _buildSection(
              'Pillars',
              'Our faith is built on these core pillars.',
            ),
            _buildSection(
              'Contact Us',
              'Get in touch with us via email or phone.',
            ),
          ],
        ),
      ),
    );
  }

  // Function to create sections
  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // Launch URL (for Watch button)
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// Donation Form Widget
class _DonationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TextField(decoration: InputDecoration(labelText: 'Name')),
        const TextField(decoration: InputDecoration(labelText: 'Phone Number')),
        const TextField(decoration: InputDecoration(labelText: 'Country')),
        const TextField(decoration: InputDecoration(labelText: 'Amount')),
        DropdownButtonFormField(
          decoration: const InputDecoration(labelText: 'Currency'),
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('USD')),
            DropdownMenuItem(value: 'RWF', child: Text('RWF')),
            DropdownMenuItem(value: 'EURO', child: Text('EURO')),
            DropdownMenuItem(value: 'KES', child: Text('KES')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}

// Membership Form Widget
class _MembershipForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TextField(decoration: InputDecoration(labelText: 'Name')),
        const TextField(decoration: InputDecoration(labelText: 'Email')),
        const TextField(decoration: InputDecoration(labelText: 'Phone Number')),
        const TextField(decoration: InputDecoration(labelText: 'Country')),
        const TextField(decoration: InputDecoration(labelText: 'Occupation')),
      ],
    );
  }
}
