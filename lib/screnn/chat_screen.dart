import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatbotPage(),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDjnR4t4xfwYQ44yuE7MNcsOqBlEV289Nc'; //API KEY

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final FocusNode _focusNode = FocusNode();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isConnected = true;
  bool _isThinking = false;
  final List<String> _emojis = ['😊', '😄', '😎', '😉', '👍', '🎉', '🤖', '💬'];

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _loadHistory();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_messages);
    await prefs.setString('chat_history', encodedData);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('chat_history');
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        _messages.addAll(decodedData.map((e) => Map<String, String>.from(e)));
      });
    }
  }

  Future<void> _clearChat() async {
    setState(() {
      _messages.clear();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
  }

  String _getRandomEmoji() {
    final random = Random();
    return _emojis[random.nextInt(_emojis.length)];
  }

  bool _isMessageValid(String message) {
    final cleanedMessage = message.trim();
    return cleanedMessage.isNotEmpty;
  }

  String _buildConversationContext() {
    return _messages
        .map((msg) => '${msg["sender"]}: ${msg["message"]}')
        .join('\n');
  }

  Future<void> sendMessage(String message) async {
  setState(() {
    _messages.add({"sender": "user", "message": message});
    _isThinking = true;
    _controller.clear(); 
  });

  Future.microtask(() async {
    try {
      final conversationContext = _buildConversationContext();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {
              "parts": [
                {"text": "$conversationContext\nUser: $message"}
              ]
            }
          ]
        }),
      );

      print('Response body: ${response.body}'); 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage =
            data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? 
            'No response';

        final botMessageWithEmoji = '$botMessage ${_getRandomEmoji()}';

        setState(() {
          _messages.add({"sender": "bot", "message": botMessageWithEmoji});
        });
      } else {
        print('Error status: ${response.statusCode}');
        print('Error body: ${response.body}');
        setState(() {
          _messages.add({
            "sender": "bot",
            "message": "Error: ${response.statusCode} - ${response.body}"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "message": "Error: $e"});
      });
    } finally {
      setState(() {
        _isThinking = false;
      });
      await _saveHistory();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isThinking && index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Pensando...',
                          style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  );
                }

                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.greenAccent
                          : Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      message['message']!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: _isConnected ? Colors.greenAccent : Colors.grey,
                  onPressed: () {
                    final text = _controller.text;
                    if (_isMessageValid(text)) {
                      sendMessage(text.trim());
                    } else {
                      print('No se puede enviar el mensaje. Campo vacío.');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
