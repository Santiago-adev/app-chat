import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/ImageMessageBubble.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/presentation/widgets/chat/my_message_bubble.dart';
import 'package:flutter_application_1/presentation/widgets/chat/other_message_bubble.dart';
import 'package:flutter_application_1/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final List<String> simulatedResponses = [
    '¡Eso suena interesante!',
    'Cuéntame más.',
    '¿De verdad?',
    'Entiendo, sigue hablando.',
    '¡Increíble!',
    'Si señor',
    'Como se encuentra usted'
  ]; // Respuestas simuladas
  bool isLoading = false;

  Future<void> _sendMessage(String message) async {
    setState(() {
      // Agrega el mensaje del usuario a la lista
      _messages.add({'type': 'user', 'text': message});
    });

    if (message.endsWith('?')) {
      // Responder con la API si termina en "?"
      setState(() {
        isLoading = true; // Mostrar el spinner
      });

      try {
        final response = await http.get(Uri.parse('https://yesno.wtf/api'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          setState(() {
            _messages.add({
              'type': 'bot',
              'text': null, // Texto no necesario, solo la imagen
              'image': data['image'] // URL de la imagen
            });
          });
        } else {
          setState(() {
            _messages.add({
              'type': 'bot',
              'text': 'Error al obtener respuesta de la API',
              'image': null,
            });
          });
        }
      } catch (e) {
        setState(() {
          _messages.add({
            'type': 'bot',
            'text': 'Hubo un error al conectarse a la API.',
            'image': null,
          });
        });
      } finally {
        setState(() {
          isLoading = false; // Ocultar el spinner
        });
      }
    } else {
      // Respuesta simulada si no termina con "?"
      final randomResponse =
          simulatedResponses[Random().nextInt(simulatedResponses.length)];

      await Future.delayed(const Duration(seconds: 1)); // Simular retraso
      setState(() {
        _messages.add({
          'type': 'bot',
          'text': randomResponse,
          'image': null,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://blog.index.pe/wp-content/uploads/2020/03/chat.jpeg'),
          ),
        ),
        title: const Text('Programa de Chat'),
        centerTitle: true,
      ),
      body: _ChatView(
        messages: _messages,
        onSendMessage: _sendMessage,
        isLoading: isLoading, // Pasar el estado de carga
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final Function(String) onSendMessage;
  final bool isLoading;

  const _ChatView({
    required this.messages,
    required this.onSendMessage,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  if (message['type'] == 'user') {
                    return MyMessageBubble(text: message['text']!);
                  } else if (message['image'] != null) {
                    return ImageMessageBubble(imageUrl: message['image']!);
                  } else {
                    return OtherMessageBubble(text: message['text']!);
                  }
                },
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            MessageFieldBox(
              onSendMessage: onSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
