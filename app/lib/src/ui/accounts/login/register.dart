import 'package:admin/src/blocs/account/login_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/accounts/login/loading_button.dart';
import 'package:admin/src/ui/accounts/logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final AccountBloc accountBloc;
  const RegisterPage({Key? key, required this.accountBloc}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  AppStateModel appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16.0),
            const AppLogo(size: 128),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter first name';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter last name';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: _obscureText,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                } else if(value.length < 6) {
                  return 'Please enter password at least 6 letters';
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
            const SizedBox(height: 16),
            LoadingButton(onPressed: () => register(context), text: 'Register'),
            const SizedBox(height: 16),
            TextButton(onPressed: () async {

              Navigator.of(context).pop();

            }, child: const Text('Already have an account? Sign In')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var register = <String, dynamic>{};
      register["username"] = usernameController.text;
      register["email"] = usernameController.text;
      register["password"] = passwordController.text;
      register["first_name"] = firstNameController.text;
      register["last_name"] = lastNameController.text;
      bool status = await widget.accountBloc.register(context, register);
      if (status) {
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      }
      return status;
    }
  }
}
