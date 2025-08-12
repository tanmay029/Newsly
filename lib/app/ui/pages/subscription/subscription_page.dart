// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsly/app/controllers/auth_controller.dart';
import 'package:newsly/app/controllers/payment_controller.dart';

class SubscriptionPage extends StatelessWidget {
  final PaymentController paymentController = Get.put(PaymentController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newsly Premium'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumFeatures(),
            SizedBox(height: 24),
            _buildSubscriptionPlans(),
            SizedBox(height: 24),
            _buildCurrentStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeatures() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'Premium Features',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildFeatureItem('🚫', 'Ad-free reading experience'),
            _buildFeatureItem('⚡', 'Faster article loading'),
            _buildFeatureItem('🔖', 'Unlimited bookmarks'),
            _buildFeatureItem('🌙', 'Dark mode support'),
            _buildFeatureItem('📱', 'Offline reading'),
            _buildFeatureItem('🎯', 'Personalized news feed'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...PaymentController.subscriptionPlans.entries.map((entry) {
          return _buildPlanCard(
            planName: entry.key,
            amount: entry.value,
            description: _getPlanDescription(entry.key),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPlanCard({
    required String planName,
    required int amount,
    required String description,
  }) {
    final price = (amount / 100).toStringAsFixed(0);
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  planName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹$price',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _initiatePayment(planName, amount),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Subscribe Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return Obx(() {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    paymentController.isPremiumUser 
                        ? Icons.verified 
                        : Icons.account_circle,
                    color: paymentController.isPremiumUser 
                        ? Colors.green 
                        : Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    paymentController.isPremiumUser 
                        ? 'Premium User' 
                        : 'Free User',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (paymentController.isPremiumUser) ...[
                SizedBox(height: 8),
                Text(
                  paymentController.subscriptionInfo,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  String _getPlanDescription(String planName) {
    switch (planName) {
      case 'Premium Monthly':
        return 'Perfect for trying premium features';
      case 'Premium Yearly':
        return 'Best value - Save 17% compared to monthly';
      case 'Premium Lifetime':
        return 'One-time payment, lifetime access';
      default:
        return '';
    }
  }

  void _initiatePayment(String planName, int amount) {
    if (authController.isLoggedIn) {
      // Get user details (you might need to add these to your AuthController)
      final userEmail = 'user@example.com'; // Replace with actual user email
      final userPhone = '9999999999'; // Replace with actual user phone
      
      paymentController.startPayment(
        planName: planName,
        amount: amount,
        userEmail: userEmail,
        userPhone: userPhone,
      );
    } else {
      Get.snackbar(
        'Login Required',
        'Please login to subscribe to premium',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
