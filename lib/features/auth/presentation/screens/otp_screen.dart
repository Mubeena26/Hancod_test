import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/features/auth/presentation/providers/auth_providers.dart';
import 'package:hancord_test/features/auth/presentation/providers/auth_state.dart';
import 'package:hancord_test/features/home/presentation/screens/home_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String _phoneNumber = '';
  bool _canResend = false;
  int _resendTimer = 30;

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Format phone number (add + if not present)
    String formattedPhone = phone;
    if (!formattedPhone.startsWith('+')) {
      // Assume default country code if not provided
      formattedPhone = '+1$formattedPhone';
    }

    final authController = ref.read(authControllerProvider.notifier);
    await authController.sendOtp(formattedPhone);

    final authState = ref.read(authControllerProvider);
    if (authState.isOtpSent && authState.verificationId != null) {
      setState(() {
        _phoneNumber = phone;
      });
      _startResendTimer();
      // Auto-focus first OTP field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    } else if (authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.error!), backgroundColor: Colors.red),
      );
    }
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 30;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      bool shouldContinue = true;
      setState(() {
        _resendTimer--;
        if (_resendTimer <= 0) {
          _canResend = true;
          shouldContinue = false;
        }
      });
      return shouldContinue;
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authController = ref.read(authControllerProvider.notifier);
    await authController.verifyOtp(otp);

    final authState = ref.read(authControllerProvider);
    if (authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.error!), backgroundColor: Colors.red),
      );
      // Clear OTP fields on error
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  String _formatPhoneNumber(String phone) {
    // Format phone number for display (e.g., +1 (234) 567-8901)
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length >= 10) {
      if (cleaned.length == 10) {
        return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
      } else if (cleaned.length == 11 && cleaned.startsWith('1')) {
        return '+1 (${cleaned.substring(1, 4)}) ${cleaned.substring(4, 7)}-${cleaned.substring(7)}';
      }
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isOtpSent = authState.isOtpSent;

    // Listen to auth state changes and navigate to home if authenticated
    ref.listen<AsyncValue>(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: isOtpSent
              ? _buildOtpView(authState)
              : _buildPhoneInputView(authState),
        ),
      ),
    );
  }

  Widget _buildPhoneInputView(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        // Title
        const Text(
          'Enter Your Phone Number',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'rf-dewi',
          ),
        ),
        const SizedBox(height: 12),
        // Subtitle
        const Text(
          'We\'ll send you a verification code',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'rf-dewi',
          ),
        ),
        const SizedBox(height: 48),
        // Phone number input field
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          enabled: !authState.isLoading,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'rf-dewi',
          ),
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: 'rf-dewi',
            ),
            prefixIcon: const Icon(Icons.phone, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: PColors.color4FB15E, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
          ],
        ),
        const SizedBox(height: 32),
        // Send OTP button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: authState.isLoading ? null : _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.color4FB15E,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Send OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'rf-dewi',
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpView(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        // Title
        const Text(
          'Enter Verification Code',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'rf-dewi',
          ),
        ),
        const SizedBox(height: 12),
        // Subtitle with phone number
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'rf-dewi',
            ),
            children: [
              const TextSpan(text: 'We sent a verification code to '),
              TextSpan(
                text: _formatPhoneNumber(_phoneNumber),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        // OTP input fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 48,
              height: 60,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                enabled: !authState.isLoading,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'rf-dewi',
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: PColors.color4FB15E,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onOtpChanged(index, value),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Verify button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: authState.isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.color4FB15E,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'rf-dewi',
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        // Resend OTP
        Center(
          child: _canResend
              ? TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          _startResendTimer();
                          _sendOtp();
                        },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: PColors.color4FB15E,
                      fontFamily: 'rf-dewi',
                    ),
                  ),
                )
              : Text(
                  'Resend code in ${_resendTimer}s',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'rf-dewi',
                  ),
                ),
        ),
      ],
    );
  }
}
