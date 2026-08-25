import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OIDCLoginScreen(),
    );
  }
}

class OIDCLoginScreen extends StatefulWidget {
  const OIDCLoginScreen({super.key});

  @override
  State<OIDCLoginScreen> createState() => _OIDCLoginScreenState();
}

class _OIDCLoginScreenState extends State<OIDCLoginScreen> {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  String _result = 'Not Logged In';

  Future<void> _login() async {
    try {
      final AuthorizationTokenResponse? response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'YOUR_CLIENT_ID', // นำ Client ID ที่ได้จาก Django Admin ใน backend2 มาวางที่นี่
          'com.example.app://oauthredirect',
          issuer: 'http://10.0.2.2:8000/openid', // Android Emulator URL
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      if (response != null) {
        setState(() {
          _result = 'Login Success!\nAccess Token: ${response.accessToken}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Authentication Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frontend 2 - OpenID Connect')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login with OpenID Connect'),
              ),
              const SizedBox(height: 20),
              Text(_result, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}