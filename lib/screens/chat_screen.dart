import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flash_chat/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final Firestore _firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static const String routeId = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController messageTextController = TextEditingController();

  FirebaseUser loggedInUser;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
//    getMessages();
  }

  void getCurrentUser() async {
    try {
      final FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Using for in retrieving data ONE time
  /// snapshot.documents type: List<DocumentSnapshot>
  /// message type: DocumentSnapshot
//  void getMessages() async {
//    final QuerySnapshot snapshot =
//        await _firestore.collection('messages').getDocuments();

//    for (var message in snapshot.documents) {
//      print(message.data);
//    }

  /// another approach getting Map<String, dynamic> of data
//    snapshot.documents.forEach((snp) {
//      print(snp.data);
//    });
//  }

  void messagesStream() async {
    /// .snapshots() return Stream<QuerySnapshot>
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pop();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /// Writing QuerySnapshot in anchor bracket (StreamBuilder<QuerySnapshot>)
            /// auto-referred the data extracted from the asyncSnapshot
            /// has a data-type: QuerySnapshot
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': messageTextController.text,
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: ((_, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
        if (asyncSnapshot.hasError || !asyncSnapshot.hasData) {
          return Center(
            child: SpinKitDoubleBounce(
              color: Colors.white,
              size: 50.0,
            ),
          );
        }

        /// AsyncSnapshot asyncSnapshot contains ours QuerySnapshot-typed data
        /// using asyncSnapshot.data extracted it out
        final QuerySnapshot querySnapshot = asyncSnapshot.data;
        final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

        /// Using Expanded constraint the ListView
        /// inside the limited space
        return Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            onVerticalDragDown: ((detail) {
              print(
                  'directopn:  ${detail.localPosition.direction.toStringAsFixed(2)}');
              print('pi/2: ${(pi / 2).toStringAsFixed(2)}');
              print('-----------------');

              if (detail.localPosition.direction < 1.1) {
                FocusScope.of(context).unfocus();
              }
            }),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              itemCount: documentSnapshot.length,
              itemBuilder: ((_, index) {
                final message = documentSnapshot[index].data;
                return MessageBubble(
                  sender: message['sender'],
                  text: message['text'],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    this.sender,
    this.text,
  });

  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            borderRadius: BorderRadius.all(
              Radius.circular(
                30.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
