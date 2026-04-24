import 'package:flutter/material.dart';
import 'dart:async';

import 'package:nectracker/controllers/auth_controller.dart';

class TelaSolicitaEmail extends StatefulWidget {
  const TelaSolicitaEmail({super.key});

  @override
  State<TelaSolicitaEmail> createState() => _TelaSolicitaEmailState();
}

class _TelaSolicitaEmailState extends State<TelaSolicitaEmail> {
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _isResendEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
          _timer?.cancel();
        });
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_isResendEnabled) {
      try {
        await AuthController.reenviarConfirmacao();

        if (!mounted) return;

        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail de confirmação reenviado!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEC107),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE49A),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 100,
                color: Colors.black87,
              ),
              const SizedBox(height: 32),
              const Text(
                'Verifique seu e-mail',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enviamos um link de confirmação para o seu endereço de e-mail. Por favor, verifique sua caixa de entrada e clique no link para ativar sua conta.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isResendEnabled ? _resendEmail : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.black38,
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isResendEnabled
                        ? 'Reenviar E-mail'
                        : 'Reenviar em ${_secondsRemaining}s',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
