import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/setting/setting_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/screen/login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "User";
  String _selectedLevel = "Beginner";
  String _selectedGoal = "Mass Gain";
  String _weight = "70 KG";
  String _height = "170 cm";
  String _age = "18";
  bool _isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() => _currentUser = user);
        _loadUserData();
      } else {
        setState(() => _isLoading = false);
      }
    });
  }

  void _loadUserData() async {
    if (_currentUser == null) return;

    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (!doc.exists) {
        await _firestore.collection('users').doc(_currentUser!.uid).set({
          'name': _name,
          'level': _selectedLevel,
          'goal': _selectedGoal,
          'weight': _weight,
          'height': _height,
          'age': _age,
          'lastLogin': FieldValue.serverTimestamp(),
        });
        doc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      }

      if (doc.exists) {
        setState(() {
          _name = doc['name']?.toString() ?? "User";
          _selectedLevel = doc['level']?.toString() ?? "Beginner";
          _selectedGoal = doc['goal']?.toString() ?? "Mass Gain";
          _weight = doc['weight']?.toString() ?? "70 KG";
          _height = doc['height']?.toString() ?? "170 cm";
          _age = doc['age']?.toString() ?? "18";
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _saveField(String field, dynamic value) async {
    if (_currentUser == null) return;

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        field: value,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating: ${e.toString()}')),
      );
    }
  }

  void _showLevelPicker() {
    String tempLevel = _selectedLevel;
    final List<String> levels = ["Beginner", "Intermediate", "Advanced"];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Level",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText)),
            const Divider(),
            ...levels.map((level) => RadioListTile(
              title: Text(level, style: const TextStyle(fontSize: 18)),
              value: level,
              groupValue: tempLevel,
              activeColor: Colors.orange,
              onChanged: (value) => tempLevel = value.toString(),
            )).toList(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                setState(() => _selectedLevel = tempLevel);
                _saveField('level', tempLevel);
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.exit_to_app, size: 40, color: Colors.orange),
            const SizedBox(height: 20),
            Text("Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: TextStyle(
                          color: TColor.primaryText.withOpacity(0.7),
                          fontSize: 16,
                        )),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text("Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalPicker() {
    String tempGoal = _selectedGoal;
    final goals = ["Weight Loss", "Muscle Gain", "Fat Loss", "Others"];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Goal",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText)),
            const Divider(),
            ...goals.map((goal) => RadioListTile(
              title: Text(goal, style: const TextStyle(fontSize: 18)),
              value: goal,
              groupValue: tempGoal,
              activeColor: Colors.orange,
              onChanged: (value) => tempGoal = value.toString(),
            )).toList(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                setState(() => _selectedGoal = tempGoal);
                _saveField('goal', tempGoal);
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNumberInputDialog(String title, String currentValue, String unit) async {
    final numericValue = currentValue.replaceAll(unit, "").trim();
    TextEditingController controller = TextEditingController(text: numericValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            suffixText: unit,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                if (controller.text.isEmpty) return;
                final newValue = "${controller.text} $unit";
                setState(() {
                  if (title == "Body Weight") _weight = newValue;
                  if (title == "Height") _height = newValue;
                });
                final firestoreField = title == "Body Weight" ? 'weight' : title.toLowerCase();
                _saveField(firestoreField, newValue);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  void _showChangeEmailDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Email"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_currentUser!.emailVerified)
              Column(
                children: [
                  const Text("Verify your current email first:",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                  TextButton(
                    onPressed: () async {
                      await _currentUser!.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verification email sent!')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Resend Verification Email"),
                  ),
                  const Divider(),
                ],
              ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "New Email Address",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (controller.text.isEmpty || !_currentUser!.emailVerified) return;

              final password = await showDialog<String>(
                context: context,
                builder: (context) {
                  final passwordController = TextEditingController();

                  return AlertDialog(
                    title: const Text("Confirm Password"),
                    content: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Enter Current Password",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => Navigator.pop(context, value),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final enteredPassword = passwordController.text;
                          Navigator.pop(context, enteredPassword);
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );

              if (password == null || password.isEmpty) return;

              try {
                final credential = EmailAuthProvider.credential(
                  email: _currentUser!.email!,
                  password: password,
                );
                await _currentUser!.reauthenticateWithCredential(credential);
                await _currentUser!.verifyBeforeUpdateEmail(controller.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification sent to new email!')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() async {
    final newPassController = TextEditingController();
    final currentPassController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (newPassController.text.isEmpty || currentPassController.text.isEmpty) return;

              try {
                final credential = EmailAuthProvider.credential(
                  email: _currentUser!.email!,
                  password: currentPassController.text,
                );
                await _currentUser!.reauthenticateWithCredential(credential);
                await _currentUser!.updatePassword(newPassController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully!')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset("assets/img/back.png", width: 18, height: 18)),
        title: Text(
          "Profile",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [

          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _currentUser?.email ?? "No email",
                      style: TextStyle(
                        color: TColor.primaryText.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _currentUser?.emailVerified ?? false
                          ? Icons.verified
                          : Icons.warning,
                      color: _currentUser?.emailVerified ?? false
                          ? Colors.green
                          : Colors.orange,
                      size: 16,
                    ),
                  ],
                ),
                if (!(_currentUser?.emailVerified ?? true))
                  TextButton(
                    onPressed: () async {
                      await _currentUser?.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verification email sent!')),
                      );
                    },
                    child: const Text('Resend Verification Email'),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _showChangeEmailDialog,
                        child: const Text("Change Email",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _showChangePasswordDialog,
                        child: const Text("Change Password",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          SettingRow(
            title: "Level",
            icon: "assets/img/level.png",
            value: _selectedLevel,
            onPressed: _showLevelPicker,
          ),
          SettingRow(
            title: "Goals",
            icon: "assets/img/goal.png",
            value: _selectedGoal,
            onPressed: _showGoalPicker,
          ),
          SettingRow(
            title: "Body Weight",
            icon: "assets/img/Weight.png",
            value: _weight,
            onPressed: () => _showNumberInputDialog("Body Weight", _weight, "KG"),
          ),
          SettingRow(
            title: "Height",
            icon: "assets/img/Height.png",
            value: _height,
            onPressed: () => _showNumberInputDialog("Height", _height, "cm"),
          ),
          SettingRow(
            title: "Age",
            icon: "assets/img/age.png",
            value: _age,
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => _NumberInputDialog(
                  title: "Age",
                  initialValue: _age,
                ),
              );
              if (result != null) {
                if (int.tryParse(result) == null || int.parse(result) < 1 || int.parse(result) > 120) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid age between 1-120')));
                  return;
                }
                setState(() => _age = result);
                _saveField('age', result);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _showLogoutConfirmation, // Changed to use confirmation dialog
              child: const Text("Log Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberInputDialog extends StatelessWidget {
  final String title;
  final String initialValue;

  const _NumberInputDialog({required this.title, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text("Edit $title"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (controller.text.isEmpty) return;
              Navigator.pop(context, controller.text);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}