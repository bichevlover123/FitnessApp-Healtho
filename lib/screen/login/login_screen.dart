import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/name_screen.dart';
import 'package:healtho_gym/screen/login/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  late SharedPreferences _prefs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadRememberMePreference();
      if (_rememberMe) await _attemptAutoLogin();
    } catch (e) {
      if (mounted) _showErrorMessage('Initialization error: ${e.toString()}');
    }
  }

  Future<void> _loadRememberMePreference() async {
    setState(() => _rememberMe = _prefs.getBool('remember_me') ?? false);
  }

  Future<void> _attemptAutoLogin() async {
    try {
      final user = _auth.currentUser;
      if (user == null || !user.emailVerified) return;

      final profileComplete = await _isProfileComplete(user.uid);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => profileComplete
              ? const TopTabViewScreen()
              : const NameScreen(),
        ),
      );
    } catch (e) {
      await _prefs.setBool('remember_me', false);
      if (mounted) _showErrorMessage('Auto-login failed: ${e.toString()}');
    }
  }

  Future<bool> _isProfileComplete(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return false;

      final data = doc.data()!;
      final requiredFields = ['name', 'gender', 'goal', 'age', 'height', 'weight', 'level'];
      return requiredFields.every((field) =>
      data.containsKey(field) &&
          data[field]?.toString().isNotEmpty == true);
    } catch (e) {
      if (mounted) _showErrorMessage('Profile check failed');
      return false;
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        _showErrorMessage('Please verify your email first');
        return;
      }

      await _prefs.setBool('remember_me', _rememberMe);
      final profileComplete = await _isProfileComplete(userCredential.user!.uid);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => profileComplete
              ? const TopTabViewScreen()
              : const NameScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      await _prefs.setBool('remember_me', false);
      _showErrorMessage(e.message ?? 'Authentication failed');
    } catch (e) {
      await _prefs.setBool('remember_me', false);
      _showErrorMessage('Unexpected error occurred');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Keep all existing methods below exactly as they were
  Future<void> _sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _showSuccessMessage('Password reset email sent! Check your inbox.');
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e.message ?? 'Failed to send reset email');
    } catch (e) {
      _showErrorMessage('An error occurred. Please try again.');
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Reset Password',
              style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your email to receive a password reset link',
                  style: TextStyle(color: TColor.primaryText),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: TColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: TColor.secondaryText),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  if (emailController.text.isEmpty ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(emailController.text)) {
                    _showErrorMessage('Please enter a valid email');
                    return;
                  }
                  setState(() => isLoading = true);
                  await _sendPasswordResetEmail(emailController.text);
                  setState(() => isLoading = false);
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  'Send Link',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
              children: [
              const Spacer(),
          Image.asset(
            "assets/img/app_logo.png",
            width: MediaQuery.of(context).size.width * 0.7,
          ),
          const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: TColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail, // Direct reference to the method
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: TColor.primary),
                      suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: TColor.primary),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18))),
                  validator: (value) => _validatePassword(value),
                ),
            const SizedBox(height: 15),
            _buildRememberMeCheckbox(),
            const SizedBox(height: 15),
            _buildForgotPasswordButton(),
            const SizedBox(height: 15),
            _buildLoginButton(),
            const SizedBox(height: 20),
            _buildSignUpLink(),
            const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
          activeColor: TColor.primary,
        ),
        Text('Remember Me', style: TextStyle(color: TColor.primaryText)),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _showForgotPasswordDialog,
        child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ),
    );
  }

  Widget _buildLoginButton() {
    return _isLoading
        ? const CircularProgressIndicator()
        : RoundButton(
      title: 'Log In',
      type: RoundButtonType.primary,
      height: 50,
      fontSize: 14,
      radius: 25,
      fontWeight: FontWeight.w600,
      width: double.maxFinite,
      isPadding: true,
      onPressed: _login,
    );
  }

  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen())),
      child: Text.rich(
        TextSpan(
          text: 'Don\'t have an account? ',
          style: TextStyle(color: TColor.primaryText),
          children: [
            TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}