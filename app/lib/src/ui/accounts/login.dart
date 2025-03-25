import 'package:admin/src/models/app_state_model.dart';
import 'package:flex_color_scheme/src/flex_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'logo.dart';

class LoginPageOld extends StatefulWidget {
  @override
  _LoginPageOldState createState() => _LoginPageOldState();
}

class _LoginPageOldState extends State<LoginPageOld> {

  bool isLoading = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
            children: [
              AppLogo(size: 128),
              SizedBox(height: 32),
              const SizedBox(height: 16),TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),TextFormField(
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
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        }
                    ),
                    labelText: 'Password'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    ),
                    elevation: 0.0,
                    minimumSize: Size(400.0, 48.0),
                    padding: EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    var login = new Map<String, dynamic>();
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      login["username"] = usernameController.text;
                      login["password"] = passwordController.text;
                      setState(() {
                        isLoading = true;
                      });
                      model.login(login);
                    }
                  },
                  child: Text('LOGIN')
              )
            ],
          ),
        );
      }
        ),
    );
  }
}
