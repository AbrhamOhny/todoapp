import 'package:flutter/material.dart';
import 'package:todoapp/controller/pages.dart';
import 'package:todoapp/main.dart';

class ResetCredentialsPage extends StatefulWidget {
  const ResetCredentialsPage({super.key});

  @override
  State<ResetCredentialsPage> createState() => _ResetCredentialsState();
}

class _ResetCredentialsState extends State<ResetCredentialsPage> {
  int pageIndex = 0;
  late Widget confirmationPage;
  late Widget mainPage;
  late List<Widget> pageController;

  @override
  Widget build(BuildContext context) {
    confirmationPage = Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15,
        children: [
          Text(
            "By resetting your credentials, will result in wiping out currently saved data. Do you want to continue?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () => {
              setState(() {
                pageIndex = 1;
              }),
            },
            child: Text("Continue"),
          ),
          TextButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: Text("Cancel"),
          ),
        ],
      ),
    );
    mainPage = Padding(
      padding: pagesPadding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          spacing: 15,
          children: [
            Text("Reset successful!"),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  currentUser.reset();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => NavigationHandler(),
                    ),
                  );
                },
                child: Text(
                  "Back to register page",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    pageController = [confirmationPage, mainPage];
    return Scaffold(body: pageController[pageIndex]);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: pagesPadding,
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: itemsPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 15,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                    counter: Wrap(
                      children: [
                        Text("Forgot your credentials? "),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResetCredentialsPage(),
                                ),
                              );
                            },
                            child: Text(
                              "click here",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: pagesPadding,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentUser.username == _usernameController.text &&
                          currentUser.password == _passwordController.text) {
                        currentUser.isLoggedIn = true;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainApp()),
                        );
                      } else {
                        // Handle login failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid username or password'),
                          ),
                        );
                        return;
                      }
                    },
                    child: Text('Procceed'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: pagesPadding,
            child: Text(
              'Register',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: itemsPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 15,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: pagesPadding,
                  child: ElevatedButton(
                    onPressed: () {
                      registerHandler(
                        context,
                        _usernameController,
                        _passwordController,
                        _confirmPasswordController,
                      );
                    },
                    child: Text('Procceed'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
