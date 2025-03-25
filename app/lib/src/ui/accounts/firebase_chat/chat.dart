import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/accounts/firebase_chat/chat_room.dart';
import 'package:admin/src/ui/accounts/firebase_chat/firebase_chat_core.dart';
import 'package:admin/src/ui/accounts/firebase_chat/rooms.dart';
import 'package:admin/src/ui/accounts/login/login.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/theme_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:scoped_model/scoped_model.dart';

class TestChat extends StatefulWidget {
  const TestChat({Key? key}) : super(key: key);
  @override
  State<TestChat> createState() => _TestChatState();
}

class _TestChatState extends State<TestChat> {

  @override
  void initState() {
    print("chat..........");
    configureFcm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Chat")
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FireBaseChat(otherUserId: '0wQCAZG5lMOG5vZEPrtglZZ0HHU2'),
              ),
            );
          }, child: Text(AppLocalizations.of(context)
        .translate("chat_with_some_one"),)),
          ElevatedButton(onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoomsPage(),
              ),
            );
          }, child: Text(AppLocalizations.of(context)
        .translate("chat_room"),)),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
              return model.user != null && model.user!.id == 0 ? ElevatedButton(onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }, child: Text(AppLocalizations.of(context)
                  .translate("login"),)) : ElevatedButton(onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await model.logout();
              }, child: Text(AppLocalizations.of(context)
                  .translate("logout"),));
            }
          ),
          ElevatedButton(onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ThemeSettingsPage(),
              ),
            );
          }, child: Text(AppLocalizations.of(context)
              .translate("theme"),)),
        ],
      ),
    );
  }

  Future<void> configureFcm() async {

    await Future.delayed(Duration(seconds: 3));

    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(announcement: true, criticalAlert: true);
    } catch(e) {}

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {_onMessage(message);});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {_onMessage(message);});

    FirebaseMessaging.instance.getToken().then((String? token) {
      if(token != null) {
        //TODO Update token in server
        //print(token);
      }
    });

    FirebaseMessaging.instance.subscribeToTopic('all');

  }

  void _onMessage(RemoteMessage message) {
    //print(message);
    if (message.data.isNotEmpty) {
      //
    }
  }
}

class FireBaseChat extends StatefulWidget {
  final String otherUserId;
  const FireBaseChat({Key? key, required this.otherUserId}) : super(key: key);

  @override
  State<FireBaseChat> createState() => _FireBaseChatState();
}

class _FireBaseChatState extends State<FireBaseChat> {

  bool _error = false;
  bool _initialized = false;
  User? _user;
  types.User? _otherUser;
  types.Room? room;
  String _userId = '10';

  @override
  void initState() {
    print("Chat tab ");
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            bottom: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(AppLocalizations.of(context)
              .translate("not_authenticated"),),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => SocialLoginPage(),
                    ),
                  );
                },
                child:  Text(AppLocalizations.of(context)
                    .translate("login"),),
              ),
            ],
          ),
        ),
      );
    } else if (room != null) {
      return ChatRoomPage(room: room!);
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> initializeFlutterFire() async {

    try {

      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });

      //TODO replace id with widget.otherUserId after testing
      _otherUser = await FirebaseChatCore.instance.user(widget.otherUserId);

      if(_otherUser != null) {
        room = await FirebaseChatCore.instance.createRoom(_otherUser!);
      } else {
        //Chat not possible unless other user create account in firebase and update firebase uid in wordpress database
        //TODO Show error message
      }

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

}

