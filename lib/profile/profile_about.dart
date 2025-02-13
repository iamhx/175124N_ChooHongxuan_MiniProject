import 'package:flutter/material.dart';
import '/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileAboutView extends StatefulWidget {
  const ProfileAboutView({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileAboutView();
}

class _ProfileAboutView extends State<ProfileAboutView>
    with AutomaticKeepAliveClientMixin<ProfileAboutView> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Feedback for MRT Info & Journey Planner',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const MainAppBar(title: "About"),
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'About App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'MRT Info & Journey Planner is designed to provide users with a seamless MRT System Map viewing experience. The app focuses on the North-South Line (NS Line) and offers interactive features to explore station information.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Company Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hongxuan Pte Ltd\n'
                  '180 Ang Mo Kio Ave 8\n'
                  'Singapore 569830',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('+65 9836 1480'),
                  onTap: () => _makePhoneCall('+6598361480'),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('choohongxuan@gmail.com'),
                  onTap: () => _sendEmail('choohongxuan@gmail.com'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Developer Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Developed by: CHOO HONGXUAN\n'
                  'Student ID: 175124N\n'
                  'School of Engineering\n'
                  'Nanyang Polytechnic',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Version',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('1.0.0'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
