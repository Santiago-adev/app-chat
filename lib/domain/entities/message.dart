// crear una variable de tipo enumeracion

enum FromWho {mine, hers}

// cuerpo a capturar el mensaje

class Message {
  final String text;
  final String? imageUrl;
  final FromWho fromWho;

  Message({
    required this.text, 
    this.imageUrl, 
    required this.fromWho
  });
}
