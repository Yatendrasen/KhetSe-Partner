import 'dart:io';
import 'package:admin/src/blocs/account/login_bloc.dart';
import 'package:admin/src/ui/accounts/login/loading_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerification extends StatefulWidget {
  final String phoneNumber;
  final String prefixCode;
  final AccountBloc accountBloc;
  const OTPVerification({Key? key, required this.phoneNumber, required this.prefixCode, required this.accountBloc}) : super(key: key);
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  late Timer _timer;
  int _start = 30;
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;
  PhoneAuthCredential? _credential;
  
  var onTapRecognizer;
  TextEditingController otpTextController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
    verifyPhoneNumber();
    startTimer();
  }

  @override
  void dispose() {
    errorController.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Verify Number',
                      style: TextStyle(
                          fontSize: 30,
                          //color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Incorrect OTP', style: TextStyle(
                            //color: Colors.black,
                            fontSize: 15, height: 1.5)),
                        Text(widget.prefixCode + ' ' + widget.phoneNumber, style: const TextStyle(
                            //color: Colors.black87,
                            fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          child: SizedBox(
                            height: 90,
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v != null && v.length < 6) {
                                  //return appStateModel.blocks.localeText.pleaseEnterOtp;
                                  return null;
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                inactiveFillColor: Colors.transparent,
                                disabledColor: Theme.of(context).disabledColor,
                                selectedColor: Theme.of(context).colorScheme.secondary,
                                activeColor: Theme.of(context).colorScheme.secondary,
                                selectedFillColor: isDark ? Colors.black : Colors.white,
                                shape: PinCodeFieldShape.box,
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 45,
                                activeFillColor: isDark ? Colors.black : Colors.white,
                              ),
                              animationDuration: const Duration(milliseconds: 300),
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              //backgroundColor: Colors.transparent,
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: otpTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {

                              },
                              beforeTextPaste: (text) {
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          )),
                    ),
                    Row(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "Didn't Receive Code?",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
                              children: [

                              ]),
                        ),
                        _start == 0 ? TextButton(onPressed: () {
                          setState(() {_start = 30;});
                          startTimer();
                          verifyPhoneNumber();
                        }, child: Text('Resend OTP', style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),)) : TextButton(onPressed: () {}, child: Text(_start.toString().padLeft(2, '0'), style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),),),
                      ],
                    ),

                    const SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: LoadingButton(onPressed: () => login(context), text: 'Login'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> verifyPhoneNumber() async {
    try {

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.prefixCode + widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          _credential = credential;
        },
        verificationFailed: (FirebaseAuthException e) {

          String error = 'Verification failed';

          if (e.code == 'invalid-phone-number') {
            error = "The provided phone number is not valid.";
          }

          SnackBar snackBar = SnackBar(
            content: Text(error),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // Handle other errors
        },
        codeSent: (String verId, int? resendToken) async {

          verificationId = verId;

        },
        codeAutoRetrievalTimeout: (String verificationId) {

        },
      );

    } catch (e) {

    }
  }

  loginWithPhoneNumber(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    if(_credential != null/* && auth.currentUser == null*/) {
      auth.signInWithCredential(_credential!);
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otpTextController.text);
      auth.signInWithCredential(credential);
    }

    bool status = await loginWordpress();
    return status;
  }

  Future<bool> loginWordpress() async {
    var data = new Map<String, dynamic>();
    data["smsOTP"] = otpTextController.text;
    data["verificationId"] = verificationId;
    data["phoneNumber"] = widget.phoneNumber;
    bool status = await widget.accountBloc.submitLogin(data);
    if (status) {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }
    return status;
  }

  login(BuildContext context) async {
    if(formKey.currentState!.validate()) {
      if (otpTextController.text.length > 6) {
        errorController.add(ErrorAnimationType
            .shake); // Triggering error shake animation
        setState(() {
          hasError = true;
        });
      } else {
        await loginWithPhoneNumber(context);
      }
    }
    return;
  }
}

