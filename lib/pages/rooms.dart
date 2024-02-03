import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:trackbangla/core/utils/chat.dart';
import 'package:trackbangla/core/utils/next_screen.dart';
import 'package:trackbangla/pages/sign_in.dart';

import 'chat.dart';
import 'users.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  late String other;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> getUserName(types.Room room) async {
    late String otherUserUid;
    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        otherUserUid = otherUser.id;
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserUid)
        .get();
    final name = userDoc.data()?['name'] as String?;
    return name;
  }

  Future<String?> getAvater(types.Room room) async {
    late String otherUserUid;
    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        otherUserUid = otherUser.id;
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserUid)
        .get();
    final avater = userDoc.data()?['image url'] as String?;
    return avater;
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 20),
            onPressed: _user == null
                ? null
                : () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     fullscreenDialog: true,
                    //     builder: (context) => const UsersPage(),
                    //   ),
                    // );
                    nextScreen(context, const UsersPage());
                  },
          ),
        ],
      ),
      body: _user == null
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not authenticated'),
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     fullscreenDialog: true,
                      //     builder: (context) => const LoginPage(),
                      //   ),
                      // );
                      nextScreenPopup(
                          context,
                          SignInPage(
                            tag: 'popup',
                          ));
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: const Text('No rooms'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              room: room,
                            ),
                          ),
                        );
                        //nextScreen(context, ChatPage(room: room));
                      },
                      onLongPress: () async {
                        await FirebaseChatCore.instance.deleteRoom(room.id);
                        //refrese room page
                        //setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            FutureBuilder<String?>(
                              future: getAvater(room),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                }
                                return Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          NetworkImage(snapshot.data ?? ''),
                                      radius: 20,
                                    ));
                              },
                            ),
                            FutureBuilder<String?>(
                              future: getUserName(room),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                }
                                return Text(snapshot.data ?? '');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
