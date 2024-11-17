import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=TU_API'; // API KEY

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final FocusNode _focusNode = FocusNode();
  final scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true;
  bool _isThinking = false;

  // Speech-to-Text and Text-to-Speech
  final FlutterTts _flutterTts = FlutterTts();
  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _loadHistory();

    _speechToText = stt.SpeechToText();
    _initializeTts();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.awaitSpeakCompletion(true);
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

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({"sender": "user", "message": message});
      _isThinking = true;
      _controller.clear();
    });

    try {
      final conversationContext = _messages
          .map((msg) => '${msg["sender"]}: ${msg["message"]}')
          .join('\n');

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage = 
          (data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? 'No response')
            .replaceAll('*', ''); 


        setState(() {
          _messages.add({"sender": "bot", "message": botMessage});
        });

        await _flutterTts.speak(botMessage); 
      } else {
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
      _scrollToBottom();
    }
  }

  Future<void> _startListening() async {
    if (!_isListening && await _speechToText.initialize()) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        if (result.finalResult) {
          sendMessage(result.recognizedWords);
          setState(() => _isListening = false);
        }
      });
    }
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    _speechToText.stop();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot con Voz'),
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
              controller: scrollController,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
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
          Row(
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
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: _isListening ? _stopListening : _startListening,
                color: _isListening ? Colors.red : const Color.fromARGB(255, 26, 110, 28),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    sendMessage(text);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
