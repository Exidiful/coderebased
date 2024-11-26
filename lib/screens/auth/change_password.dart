import 'package:coderebased/logic/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class ForgotChangePasswordPage extends ConsumerStatefulWidget {
  const ForgotChangePasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotChangePasswordPage> createState() =>
      _ForgotChangePasswordPageState();
}

class _ForgotChangePasswordPageState
    extends ConsumerState<ForgotChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _isLoading = false;
  bool _isForgotPassword = true; // Flag to toggle between modes

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final auth = ref.read(authProvider);
      try {
        if (_isForgotPassword) {
          // Forgot Password flow
          await auth.resetPassword(_emailController.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset email sent.')));
        } else {
          // Change Password flow (implementation depends on your backend)
          // For demonstration, let's assume a changePassword method in AuthProvider
          // await auth.changePassword(_emailController.text.trim(), _newPasswordController.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully.')));
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isForgotPassword ? 'Forgot Password' : 'Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              if (!_isForgotPassword) ...[
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _isObscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(_isObscureConfirm
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscureConfirm = !_isObscureConfirm;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isForgotPassword
                        ? 'Reset Password'
                        : 'Change Password'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isForgotPassword = !_isForgotPassword;
                  });
                },
                child: Text(_isForgotPassword
                    ? 'Change password instead?'
                    : 'Forgot password instead?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
