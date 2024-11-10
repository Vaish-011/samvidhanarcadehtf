import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(id: "1", firstName: "Gemini");

  final List<String> constitutionKeywords = [
    "constitution", "law", "rights", "amendment", "article", "judiciary",
    "legal", "schedules", "fundamental rights", "directive principles",
    "preamble", "fundamental duties", "legislature", "executive", "judicial",
    "parliament", "democracy", "citizenship", "sovereignty", "justice",
    "liberty", "equality", "fraternity", "federalism", "union", "state",
    "government", "acts", "bills", "committees", "election", "president",
    "prime minister", "supreme court", "high court", "parliamentary system"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Constitution Chat Bot"),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bacgroungimage.png',
              fit: BoxFit.cover,
            ),
          ),
          // Chat interface
          DashChat(
            inputOptions: InputOptions(
              trailing: [
                IconButton(
                  onPressed: _sendMediaMessage,
                  icon: const Icon(Icons.image),
                ),
              ],
              inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                hintText: "Ask a question...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            currentUser: currentUser,
            onSend: _sendMessage,
            messages: messages,
            messageOptions: MessageOptions(
              messageTextBuilder: (message, previousMessage, nextMessage) =>
                  _buildFormattedMessage(message.text),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    String question = chatMessage.text.trim().toLowerCase();

    if (question.contains("ok thanks") || question.contains("thank you") || question.contains("thanks")) {
      _addResponseMessage("You're very welcome! 😊 It's my pleasure to assist you. Don't hesitate to ask anything!");
      return;
    }

    if (question.contains("thanks a lot") || question.contains("many thanks") || question.contains("thank you so much")) {
      _addResponseMessage("I really appreciate it! 😄 Thank you so much for your kind words!");
      return;
    }

    if (question.contains("you're awesome") || question.contains("you're great")) {
      _addResponseMessage("Aww, thank you! 🙏 You're amazing too! Feel free to reach out if you need anything.");
      return;
    }

    if (question == "hi" || question == "hello") {
      _addResponseMessage("Hi, how can I help you? 😊 Please ask your question.");
      return;
    }

    bool isConstitutionRelated = constitutionKeywords.any((keyword) => question.contains(keyword));

    if (!isConstitutionRelated) {
      _addResponseMessage("Sorry, I can only help with questions related to the Constitution. Please ask something relevant.");
      return;
    }

    try {
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        final file = File(chatMessage.medias!.first.url);
        if (file.existsSync()) {
          images = [await file.readAsBytes()];
        } else {
          _addResponseMessage("Failed to load the selected image.");
          return;
        }
      }

      StringBuffer responseBuffer = StringBuffer();
      gemini.streamGenerateContent(question, images: images).listen((event) {
        for (var part in event.content?.parts ?? []) {
          responseBuffer.write(part.text);
        }
      }, onDone: () {
        setState(() {
          messages.insert(0, ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: responseBuffer.toString(),
          ));
        });
      }, onError: (error) {
        print("Error in API call: $error");
        _addResponseMessage("An error occurred. Please try again.");
      });
    } catch (e) {
      print("Exception caught: $e");
      _addResponseMessage("An unexpected error occurred.");
    }
  }

  Widget _buildFormattedMessage(String text) {
    final spans = <TextSpan>[];
    final parts = text.split(RegExp(r"(\*\*[^*]+\*\*)"));
    for (var part in parts) {
      if (part.startsWith("**") && part.endsWith("**")) {
        spans.add(TextSpan(
          text: part.substring(2, part.length - 2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else {
        spans.add(TextSpan(text: part));
      }
    }
    return RichText(text: TextSpan(children: spans, style: const TextStyle(color: Colors.black)));
  }

  Future<void> _sendMediaMessage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Summarize this image:",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _addResponseMessage(String text) {
    setState(() {
      messages.insert(0, ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: text,
      ));
    });
  }
}


















