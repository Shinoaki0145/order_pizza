import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTag;

  const RegisterPage({super.key, required this.onTag});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    final messenger = ScaffoldMessenger.of(context);
    // Basic validation (you can expand this as needed)
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        messenger.showSnackBar(
          const SnackBar(content: Text("Email already used"))
        );
        return;
      }
      else if (e.code == 'invalid-email') {
        messenger.showSnackBar(
            const SnackBar(content: Text("Invalid email"))
        );
        return;
      }
      else if (e.code == 'weak-password') {
        messenger.showSnackBar(
            const SnackBar(content: Text("Weak password"))
        );
        return;
      }
    }

    if (!context.mounted) return;

    // Simulate successful sign-up (replace with actual authentication logic)
    // For example, you might call an API here

    // Navigate back to LoginPage by toggling the state
    if (widget.onTag != null) {
      widget.onTag!(); // This toggles to LoginPage via LoginOrRegister
    } else {
      // Fallback: Directly navigate to LoginPage if onTag is null
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(onTag: widget.onTag),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            // logo
            const SizedBox(height: 70),
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),

            // message, app slogan
            Text(
              "Let's create an account",
              style: TextStyle(
                fontSize: 26,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // confirm password textfield
            MyTextField(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              obscureText: true,
            ),

            const SizedBox(height: 25),

            // sign up button
            MyButton(
              text: "Sign Up",
              onTap: signUp, // Updated to call signUp function
            ),

            const SizedBox(height: 25),

            // already a member? sign in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "already a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTag,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}