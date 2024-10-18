import 'package:flutter/material.dart';
import '/bloc/login_bloc.dart';
import '/helpers/user_info.dart';
import '/ui/wisata_page.dart';
import '/ui/registrasi_page.dart';
import '/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Helvetica', // Mengubah seluruh font aplikasi menjadi Helvetica
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Helvetica'),
          bodyMedium: TextStyle(fontFamily: 'Helvetica'),
        ),
      ),
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD06B), Color(0xFFFFA64B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100), // Add some top space
                  _welcomeText(),
                  const SizedBox(height: 30),
                  _emailTextField(),
                  const SizedBox(height: 20),
                  _passwordTextField(),
                  const SizedBox(height: 10),
                  _forgotPassword(),
                  const SizedBox(height: 30),
                  _buttonLogin(),
                  const SizedBox(height: 20),
                  _menuRegistrasi(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Welcome text
  Widget _welcomeText() {
    return Column(
      children: const [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Helvetica', // Menggunakan font Helvetica di sini juga
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Please sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontFamily: 'Helvetica', // Menggunakan font Helvetica di sini juga
          ),
        ),
      ],
    );
  }

  // Email Text Field
  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email or Mobile Number",
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.email, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontFamily: 'Helvetica'), // Ganti font menjadi Helvetica
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email or mobile number is required';
        }
        return null;
      },
    );
  }

  // Password Text Field
  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: const Icon(Icons.visibility, color: Colors.white),
          onPressed: () {},
        ),
      ),
      style: const TextStyle(color: Colors.white, fontFamily: 'Helvetica'), // Ganti font menjadi Helvetica
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password is required";
        }
        return null;
      },
    );
  }

  // Forgot Password text
  Widget _forgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Handle forgot password action
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.white, fontFamily: 'Helvetica'), // Ganti font menjadi Helvetica
        ),
      ),
    );
  }

  // Login Button
  Widget _buttonLogin() {
    return ElevatedButton(
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Helvetica'), // Ganti font menjadi Helvetica
      ),
    );
  }

  // Submit function
  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userId.toString()));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WisataPage()),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login failed, please try again",
          ),
        );
      }
    }, onError: (error) {
      print(error);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Login failed, please try again",
        ),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  // Registration Menu
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Don't have an account? Sign up",
          style: TextStyle(color: Colors.white70, fontFamily: 'Helvetica'), // Ganti font menjadi Helvetica
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
