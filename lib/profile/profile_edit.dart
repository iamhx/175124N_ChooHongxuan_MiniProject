import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/main.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileEditView();
}

class _ProfileEditView extends State<ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('loginBox');
    _usernameController.text = box.get('username', defaultValue: '');
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final userBox = Hive.box('userBox');
      final loginBox = Hive.box('loginBox');
      final currentUsername = loginBox.get('username');

      // Verify old password
      final userData = userBox.get(currentUsername);
      if (userData['password'] != _oldPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Current password is incorrect'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Check if new username already exists (if username was changed)
      if (_usernameController.text != currentUsername &&
          userBox.containsKey(_usernameController.text)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username already exists'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Update user data
      final newUserData = {
        'password': _newPasswordController.text.isEmpty
            ? userData['password']
            : _newPasswordController.text
      };

      // If username changed, delete old entry and create new one
      if (_usernameController.text != currentUsername) {
        await userBox.delete(currentUsername);
        await userBox.put(_usernameController.text, newUserData);
        await loginBox.put('username', _usernameController.text);
      } else {
        await userBox.put(currentUsername, newUserData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MainAppBar(title: "Edit Profile"),
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'New Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: !_isOldPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isOldPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isOldPasswordVisible =
                                      !_isOldPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_isNewPasswordVisible,
                          decoration: InputDecoration(
                            labelText:
                                'New Password (leave blank to keep current)',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isNewPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isNewPasswordVisible =
                                      !_isNewPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'New password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
