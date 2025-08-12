// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newsly/app/config/local_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DonationController extends GetxController {
  late Razorpay _razorpay;
  
  
  static const String _keyId = LocalConfig.razorpayTestKeyId;
  
  
  static const Map<String, int> donationAmounts = {
    '☕ Buy me a Coffee': 5000,    // ₹50
    '🍕 Buy me a Pizza': 20000,   // ₹200
    '🎯 Support Development': 50000, // ₹500
    '❤️ Generous Donation': 100000, // ₹1000
  };

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    
  
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleDonationSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleDonationError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  
  void startDonation({
    required String donationType,
    required int amount,
    required String userEmail,
    required String userPhone,
  }) {
    try {
      var options = {
        'key': _keyId,
        'amount': amount, // Amount in paise
        'name': 'Support Newsly',
        'description': donationType,
        'prefill': {
          'contact': userPhone,
          'email': userEmail,
        },
        'theme': {
          'color': '#FF6B35' // Coffee-themed orange color
        },
        'currency': 'INR',
        'timeout': 60,
        'notes': {
          'donation_type': donationType,
          'app_version': '1.0.0',
        }
      };

      _razorpay.open(options);
    } catch (e) {
      print('Donation initiation error: $e');
      Get.snackbar(
        'Payment Error',
        'Failed to initiate donation. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Handle successful donation
  void _handleDonationSuccess(PaymentSuccessResponse response) {
    print('Donation Success: ${response.paymentId}');
    
    // Save donation record locally
    final storage = Get.find<GetStorage>();
    List<String> donations = storage.read<List>('donations')?.cast<String>() ?? [];
    donations.add('${DateTime.now().toIso8601String()}|${response.paymentId}');
    storage.write('donations', donations);
    
    // Update total donations
    int totalDonations = storage.read('total_donations') ?? 0;
    storage.write('total_donations', totalDonations + 1);
    
    Get.snackbar(
      'Thank You! ❤️',
      'Your support means the world to us! 🙏',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
    
    // Show appreciation dialog
    _showThankYouDialog(response.paymentId ?? 'N/A');
  }

  // Handle donation error
  void _handleDonationError(PaymentFailureResponse response) {
    print('Donation Error: ${response.code} - ${response.message}');
    
    Get.snackbar(
      'Payment Failed',
      'Donation could not be completed. Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    
    Get.snackbar(
      'External Wallet',
      'Processing via ${response.walletName}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Show thank you dialog
  void _showThankYouDialog(String paymentId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Your generous support helps us keep Newsly free and ad-supported for everyone!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Payment ID: $paymentId',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get total donations count
  int get totalDonationsCount {
    final storage = Get.find<GetStorage>();
    return storage.read('total_donations') ?? 0;
  }

  // Get donation history
  List<String> get donationHistory {
    final storage = Get.find<GetStorage>();
    return storage.read<List>('donations')?.cast<String>() ?? [];
  }
}
