import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcare/screens/chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Map<String, dynamic>> chatData = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['name'],
            'image': doc['image'],
            'lastMessage': doc['lastMessage'],
            'time': doc['time'],
            'uid': doc['uid'], // Firebase user UID
          };
        }).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (Your existing UI code remains unchanged)

              // Update the ListTile builder
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: chatData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatData: chatData[index],
                            auth: _auth,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage("images/${chatData[index]['image']}"),
                    ),
                    title: Text(
                      chatData[index]['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      chatData[index]['lastMessage'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Text(
                      chatData[index]['time'],
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chatData;
  final FirebaseAuth auth;

  ChatScreen({required this.chatData, required this.auth});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatData['uid'])
          .collection('messages')
          .add({
        'text': messageText,
        'sender': widget.auth.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the input field after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatData['name']),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatData['uid'])
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  String text = message['text'];
                  String sender = message['sender'];

                  // Add your UI for displaying messages here
                  // You can customize the appearance based on the sender
                  // For example, you can use different colors for messages sent by the user and the other party.
                  messageWidgets.add(
                    ListTile(
                      title: Text(text),
                      subtitle: Text(sender == widget.auth.currentUser?.uid
                          ? 'You'
                          : widget.chatData['name']),
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
