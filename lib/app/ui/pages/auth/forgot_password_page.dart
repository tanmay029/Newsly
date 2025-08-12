import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsly/app/controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              _buildHeader(),
              SizedBox(height: 60),
              _buildForm(),
              SizedBox(height: 24),
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: CustomTextField(
        controller: _emailController,
        label: 'Email',
        prefixIcon: Icons.email,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter your email';
          }
          if (!GetUtils.isEmail(value!)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildResetButton() {
    return Obx(() => CustomButton(
      text: 'Send Reset Link',
      isLoading: controller.isLoading,
      onPressed: _handleResetPassword,
    ));
  }

  void _handleResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      controller.resetPassword(_emailController.text.trim());
    }
  }
}
