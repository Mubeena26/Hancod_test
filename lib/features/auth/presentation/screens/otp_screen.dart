import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/features/home/presentation/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;
  String _phoneNumber = '';
  bool _canResend = false;
  int _resendTimer = 30;

  @override
  void initState() {
    super.initState();
  }

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

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      setState(() {
        _phoneNumber = phone;
        _otpSent = true;
      });
      _startResendTimer();
      // Auto-focus first OTP field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
      // Handle send OTP API call here
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

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      // Handle OTP verification
      // Navigator.pushReplacement(...);
    }
  }

  String _formatPhoneNumber(String phone) {
    // Format phone number for display (e.g., +1 (234) 567-8901)
    if (phone.length >= 10) {
      final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
      if (cleaned.length == 10) {
        return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
      }
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
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
          child: _otpSent ? _buildOtpView() : _buildPhoneInputView(),
        ),
      ),
    );
  }

  Widget _buildPhoneInputView() {
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            // _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.color4FB15E,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
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

  Widget _buildOtpView() {
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
              height: 56,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
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
            onPressed: () {
              _verifyOtp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.color4FB15E,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
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
                  onPressed: () {
                    _startResendTimer();
                    // Handle resend OTP
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
