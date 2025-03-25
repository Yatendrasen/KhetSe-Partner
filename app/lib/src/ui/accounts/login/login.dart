import 'dart:async';
import 'dart:io';
import 'package:admin/src/blocs/account/login_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/accounts/login/loading_button.dart';
import 'package:admin/src/ui/accounts/login/phone_number.dart';
import 'package:admin/src/ui/accounts/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final accountBloc = AccountBloc();
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khet Se - Partner"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16.0),
                const AppLogo(size: 128),
                const SizedBox(height: 16.0),
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Email / Username'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            }),
                        labelText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  LoadingButton(onPressed: () => login(context), text: 'Login'),
                const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     if(Platform.isIOS)
                //     IconButton(
                //         onPressed: () async {
                //           bool status = await widget.accountBloc.signInWithApple(context);
                //           if (status) {
                //             Navigator.popUntil(
                //                 context, ModalRoute.withName(Navigator.defaultRouteName));
                //           }
                //         },
                //         icon: const Icon(FontAwesomeIcons.apple)),
                //     IconButton(
                //         onPressed: () async {
                //           bool status =await widget.accountBloc.signInWithGoogle(context);
                //           if (status) {
                //             Navigator.popUntil(
                //                 context, ModalRoute.withName(Navigator.defaultRouteName));
                //           }
                //         },
                //         icon: const Icon(
                //           FontAwesomeIcons.google,
                //           color: Color(0xFFEA4335),
                //         )),
                //     IconButton(
                //         onPressed: () async {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => PhoneLogin(accountBloc: widget.accountBloc),
                //             ),
                //           );
                //         },
                //         icon: const Icon(
                //           FontAwesomeIcons.commentSms,
                //           color: Color(0xFF34B7F1),
                //         )),
                //     IconButton(
                //         onPressed: () async {
                //           bool status =await widget.accountBloc.signInWithFacebook(context);
                //           if (status) {
                //             Navigator.popUntil(
                //                 context, ModalRoute.withName(Navigator.defaultRouteName));
                //           }
                //         },
                //         icon: const Icon(
                //           FontAwesomeIcons.facebook,
                //           color: Color(0xFF3b5998),
                //         )),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      var loginData = new Map<String, dynamic>();
      loginData["username"] = usernameController.text;
      loginData["password"] = passwordController.text;
      _formKey.currentState!.save();
      bool status = await widget.accountBloc.login(context, loginData);
      if (status && Navigator.of(context) != null && Navigator.of(context).canPop()) {

      //if (status && Navigator.of(context).canPop()) {
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      }
      return status;
    }
  }
}

class SocialLoginPage extends StatefulWidget {
  final accountBloc = AccountBloc();
  SocialLoginPage({Key? key}) : super(key: key);

  @override
  State<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16.0),
            const AppLogo(size: 128),
            const SizedBox(height: 4.0),
            if(Platform.isIOS)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.black, foregroundColor: isDark ? Colors.black : Colors.white),
                  onPressed: () async {
                    bool status = await widget.accountBloc.signInWithApple(context);
                    if (status) {
                      Navigator.popUntil(
                          context, ModalRoute.withName(Navigator.defaultRouteName));
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.apple),
                  label: Text('Apple Login'),
              ),
            const SizedBox(height: 4.0),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEA4335), foregroundColor: Colors.white),
                onPressed: () async {
                  bool status =await widget.accountBloc.signInWithGoogle(context);
                  if (status) {
                    Navigator.popUntil(
                        context, ModalRoute.withName(Navigator.defaultRouteName));
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.google,
                ),
                label: Text('Google Login'),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF34B7F1), foregroundColor: Colors.white),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PhoneLogin(accountBloc: widget.accountBloc),
                    ),
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.commentSms,
                ),
                label: Text('SMS Login'),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3b5998), foregroundColor: Colors.white),
                onPressed: () async {
                  bool status =await widget.accountBloc.signInWithFacebook(context);
                  if (status) {
                    Navigator.popUntil(
                        context, ModalRoute.withName(Navigator.defaultRouteName));
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.facebook,
                ),
                label: Text('Facebook Login'),
            ),
          ],
        ),
      ),
    );
  }
}
