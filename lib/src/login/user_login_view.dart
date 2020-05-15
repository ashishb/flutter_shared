import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/flutter_shared_extra.dart';
import 'package:flutter_shared/src/login/user_login_button.dart';

class UserLoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserLoginViewState();
}

class UserLoginViewState extends State<UserLoginView> {
  UserLoginViewState() {
    Utils.getAppName().then((name) {
      setState(() {
        appName = name;
      });
    });
  }

  AuthService auth = AuthService();
  String appName = '';

  Widget loginButtons(BuildContext context) {
    // IntrinsicWidth and CrossAxisAlignment.stretch make all children equal width
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserLoginButton(
            text: 'Login with Email',
            icon: Icons.email,
            type: 'email',
          ),
          const SizedBox(height: 4),
          UserLoginButton(
            text: 'Login with Phone',
            icon: Icons.phone,
            type: 'phone',
          ),
          const SizedBox(height: 4),
          UserLoginButton(
            text: 'Login with Google',
            icon: FontAwesome5Brands.google,
            type: 'google',
          ),
          const SizedBox(height: 4),
          UserLoginButton(
            text: 'Anonymous Login ',
            icon: Icons.person,
            type: 'anon',
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              appName,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text('Login to get started',
                style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 40),
            loginButtons(context),
          ],
        ),
      ),
    );
  }
}
