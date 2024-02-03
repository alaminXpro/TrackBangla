import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:trackbangla/core/utils/chat.dart';
import 'package:trackbangla/core/utils/next_screen.dart';

import 'chat.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  Future<String?> getUserName(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final name = userDoc.data()?['name'] as String?;
    return name;
  }

  Future<String?> getAvater(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final url = userDoc.data()?['image url'] as String?;
    return url;
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = user.id;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    //final navigator = Navigator.of(context);
    Get.snackbar('Working', 'Please wait...');
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    nextScreenReplace(context, ChatPage(room: room));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('Users'),
        ),
        body: StreamBuilder<List<types.User>>(
          stream: FirebaseChatCore.instance.users(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No users'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    _handlePressed(user, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        FutureBuilder<String?>(
                          future: getAvater(user.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final url = snapshot.data ?? '';
                              return Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: CircleAvatar(
                                  backgroundColor:
                                  Colors.transparent,
                                  backgroundImage:
                                    NetworkImage(url)
                                    ,
                                  radius: 20,
                                  
                                ),
                              );
                            }
                          },
                        ),
                        FutureBuilder<String?>(
                          future: getUserName(user.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final name = snapshot.data ?? '';
                              return Text(name);
                            }
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
