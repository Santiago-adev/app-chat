import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  final Function(String) onSendMessage; // Callback para enviar el mensaje

  const MessageFieldBox({super.key, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    // Controlador para el campo de texto
    final textController = TextEditingController();

    // Estilos del input
    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    );

    // Control del foco
    final focusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        // Al dar clic fuera del input, cierre el teclado (Flutter moderno)
        onTapOutside: (_) {
          focusNode.unfocus();
        },

        // Foco
        focusNode: focusNode,

        // Inicialización del controlador
        controller: textController,

        // Estilos del input
        decoration: InputDecoration(
          hintText: 'Type your message here...',
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          filled: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {
              final textValue = textController.text.trim();

              if (textValue.isNotEmpty) {
                // Llamar al callback para enviar el mensaje
                onSendMessage(textValue);

                // Limpiar el campo después de enviar
                textController.clear();
              } else {
                print('El mensaje está vacío');
              }
            },
          ),
        ),

        // Enviar el mensaje al presionar "Enter"
        onFieldSubmitted: (value) {
          final textValue = value.trim();

          if (textValue.isNotEmpty) {
            onSendMessage(textValue);
            textController.clear(); // Limpia el campo
            focusNode.requestFocus(); // Mantiene el foco
          } else {
            print('El mensaje está vacío');
          }
        },
      ),
    );
  }
}
