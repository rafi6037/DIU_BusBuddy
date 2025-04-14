import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle user login
  Future<void> _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackbar('Please enter both email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Navigate to home page on successful login
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled';
      }

      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar('An error occurred. Please try again later.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to handle password reset
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackbar('Please enter your email address for password reset');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      _showSuccessSnackbar('Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password reset failed';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email address';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address';
      }

      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar('An error occurred. Please try again later.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Lottie animation at the top
          Positioned(
            top: screenHeight * 0.1, // Adjust top position dynamically
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height:
                    screenHeight * 0.3, // Adjust animation height dynamically
                child: Lottie.asset(
                  'lib\\assets\\bus_animation.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                ),
              ),
            ),
          ),
          // Login form
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                  screenWidth * 0.05), // Adjust padding dynamically
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: screenHeight * 0.35), // Adjust space dynamically
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Email field
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 15),
                  // Password field
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 15),
                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _resetPassword,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Login Button
                  _isLoading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: _loginUser,
                          child: Container(
                            width: screenWidth *
                                0.5, // Set button width dynamically
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 15, 139, 83),
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: screenWidth *
                                      0.05, // Responsive text size
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  // Sign up option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
