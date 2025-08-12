import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsly/app/controllers/auth_controller.dart';
import 'package:newsly/app/controllers/donation_controller.dart';


class DonationPage extends StatelessWidget {
  final DonationController donationController = Get.put(DonationController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Newsly'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 24),
            _buildDonationOptions(),
            SizedBox(height: 24),
            _buildSupportMessage(),
            // SizedBox(height: 24),
            // _buildDonationStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.local_cafe,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 12),
            Text(
              'Buy me a Coffee ☕',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Support the development of Newsly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Support Level',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...DonationController.donationAmounts.entries.map((entry) {
          return _buildDonationCard(
            donationType: entry.key,
            amount: entry.value,
            description: _getDonationDescription(entry.key),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDonationCard({
    required String donationType,
    required int amount,
    required String description,
  }) {
    final price = (amount / 100).toStringAsFixed(0);
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _initiateDonation(donationType, amount),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    _getEmojiForDonation(donationType),
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donationType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹$price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade600,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportMessage() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                SizedBox(width: 8),
                Text(
                  'Why Support Us?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '• Keep Newsly free for everyone\n'
              '• Support ongoing development\n'
              '• Help us add new features\n'
              '• Maintain high-quality journalism\n'
              '• Cover server and hosting costs',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDonationStats() {
  //   return Obx(() {
  //     return Card(
  //       child: Padding(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Community Support',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             SizedBox(height: 12),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 _buildStatItem(
  //                   icon: Icons.favorite,
  //                   label: 'Total Supporters',
  //                   value: '${donationController.totalDonationsCount}',
  //                 ),
  //                 _buildStatItem(
  //                   icon: Icons.local_cafe,
  //                   label: 'Coffees Bought',
  //                   value: '${donationController.donationHistory.length}',
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  // Widget _buildStatItem({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  // }) {
  //   return Column(
  //     children: [
  //       Icon(icon, color: Colors.orange.shade600, size: 32),
  //       SizedBox(height: 8),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.orange.shade600,
  //         ),
  //       ),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12,
  //           color: Colors.grey[600],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  String _getDonationDescription(String donationType) {
    switch (donationType) {
      case '☕ Buy me a Coffee':
        return 'A small gesture of appreciation';
      case '🍕 Buy me a Pizza':
        return 'Fuel late-night coding sessions';
      case '🎯 Support Development':
        return 'Help us build amazing features';
      case '❤️ Generous Donation':
        return 'Your incredible support means everything';
      default:
        return 'Support Newsly development';
    }
  }

  String _getEmojiForDonation(String donationType) {
    if (donationType.contains('☕')) return '☕';
    if (donationType.contains('🍕')) return '🍕';
    if (donationType.contains('🎯')) return '🎯';
    if (donationType.contains('❤️')) return '❤️';
    return '💝';
  }

  void _initiateDonation(String donationType, int amount) {
    if (authController.isLoggedIn) {
      // Get user details (replace with actual user data)
      final userEmail = 'user@example.com'; // Get from AuthController
      final userPhone = '9999999999'; // Get from AuthController
      
      donationController.startDonation(
        donationType: donationType,
        amount: amount,
        userEmail: userEmail,
        userPhone: userPhone,
      );
    } else {
      Get.snackbar(
        'Login Required',
        'Please login to support us',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
