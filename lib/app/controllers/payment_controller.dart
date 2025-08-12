// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newsly/app/config/local_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {
  late Razorpay _razorpay;
  
  
  static const String _keyId = LocalConfig.razorpayTestKeyId;
  
  
  static const Map<String, int> subscriptionPlans = {
    'Premium Monthly': 9900, 
    'Premium Yearly': 99900, 
    'Premium Lifetime': 299900, 
  };

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    
    // Attach event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  // Start payment process
  void startPayment({
    required String planName,
    required int amount,
    required String userEmail,
    required String userPhone,
  }) {
    try {
      var options = {
        'key': _keyId,
        'amount': amount, // Amount in paise
        'name': 'Newsly Premium',
        'description': planName,
        'prefill': {
          'contact': userPhone,
          'email': userEmail,
        },
        'theme': {
          'color': '#3498db'
        },
        'currency': 'INR',
        'timeout': 60, // 60 seconds
      };

      _razorpay.open(options);
    } catch (e) {
      print('Payment initiation error: $e');
      Get.snackbar(
        'Payment Error',
        'Failed to initiate payment. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Handle successful payment
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    
    // Save subscription status locally (in a real app, verify with your backend)
    final storage = Get.find<GetStorage>();
    storage.write('is_premium', true);
    storage.write('payment_id', response.paymentId);
    storage.write('subscription_date', DateTime.now().toIso8601String());
    
    Get.snackbar(
      'Payment Successful!',
      'Welcome to Newsly Premium! 🎉',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
    
    // Navigate back or refresh UI
    Get.back();
  }

  // Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    
    Get.snackbar(
      'Payment Failed',
      'Payment could not be completed. Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  
  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    
    Get.snackbar(
      'External Wallet',
      'Selected wallet: ${response.walletName}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Check if user has premium subscription
  bool get isPremiumUser {
    final storage = Get.find<GetStorage>();
    return storage.read('is_premium') ?? false;
  }

  // Get subscription info
  String get subscriptionInfo {
    final storage = Get.find<GetStorage>();
    // final paymentId = storage.read('payment_id') ?? 'N/A';
    final subscriptionDate = storage.read('subscription_date');
    
    if (subscriptionDate != null) {
      final date = DateTime.parse(subscriptionDate);
      return 'Premium since ${date.day}/${date.month}/${date.year}';
    }
    
    return 'No active subscription';
  }
}
