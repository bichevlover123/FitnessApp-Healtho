import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/name_screen.dart';
import 'package:healtho_gym/screen/login/sign_up_screen.dart';

/// Login screen for user authentication
/// This screen allows users to:
/// - Enter their email and password
/// - Remember login credentials
/// - Reset forgotten passwords
/// - Navigate to sign up screen
/// - Log in and navigate to the main app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Password visibility toggle
  bool _obscurePassword = true;

  /// Loading state indicator
  bool _isLoading = false;

  /// Remember me checkbox state
  bool _rememberMe = false;

  /// Shared preferences instance
  late SharedPreferences _prefs;

  /// Firebase services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Initialize app and load preferences
    _initializeApp();
  }

  /// Initialize app preferences and attempt auto-login if applicable
  Future<void> _initializeApp() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadRememberMePreference();
      if (_rememberMe) await _attemptAutoLogin();
    } catch (e) {
      if (mounted) _showErrorMessage('Initialization error: ${e.toString()}');
    }
  }

  /// Load remember me preference from shared preferences
  Future<void> _loadRememberMePreference() async {
    setState(() => _rememberMe = _prefs.getBool('remember_me') ?? false);
  }

  /// Attempt automatic login if remember me is enabled
  Future<void> _attemptAutoLogin() async {
    try {
      final user = _auth.currentUser;
      if (user == null || !user.emailVerified) return;

      final profileComplete = await _isProfileComplete(user.uid);
      if (!mounted) return;

      // Navigate to appropriate screen based on profile completion
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

  /// Check if user profile is complete
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

  /// Perform login with email and password
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

      // Save remember me preference
      await _prefs.setBool('remember_me', _rememberMe);

      // Check if profile is complete
      final profileComplete = await _isProfileComplete(userCredential.user!.uid);

      if (!mounted) return;
      // Navigate to appropriate screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => profileComplete
              ? const TopTabViewScreen()
              : const NameScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      await _prefs.setBool('remember_me', false);
      _showErrorMessage(e.message ?? 'Authentication failed');
    } catch (e) {
      // Handle other errors
      await _prefs.setBool('remember_me', false);
      _showErrorMessage('Unexpected error occurred');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Send password reset email
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

  /// Show forgot password dialog
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

  /// Show error message snackbar
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Show success message snackbar
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
              // App logo
              Image.asset(
                "assets/img/app_logo.png",
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 40),
              // Email input field
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
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              // Password input field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: TColor.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: TColor.primary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                validator: (value) => _validatePassword(value),
              ),
              const SizedBox(height: 15),
              // Remember me checkbox
              _buildRememberMeCheckbox(),
              const SizedBox(height: 15),
              // Forgot password button
              _buildForgotPasswordButton(),
              const SizedBox(height: 15),
              // Login button
              _buildLoginButton(),
              const SizedBox(height: 20),
              // Sign up link
              _buildSignUpLink(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build remember me checkbox
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

  /// Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  /// Validate password strength
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Build forgot password button
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
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Build login button
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

  /// Build sign up link
  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      ),
      child: Text.rich(
        TextSpan(
          text: 'Don\'t have an account? ',
          style: TextStyle(color: TColor.primaryText),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}