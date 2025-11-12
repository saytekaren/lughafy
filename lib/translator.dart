import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'translator_engine.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});
  @override State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final LughafyEngine _engine = LughafyEngine();
  final ImagePicker _picker = ImagePicker();

  String _text = "Speak or scan...";
  String _translated = "";

  @override
  void initState() {
    super.initState();
    _engine.init();
    _tts.setLanguage('sw-KE');
  }

  void _listen() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (result) {
        setState(() => _text = result.recognizedWords);
        _translate(_text);
      });
    }
  }

  void _scan() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizer = GoogleMlKit.vision.textRecognizer();
      final recognized = await recognizer.processImage(inputImage);
      setState(() => _text = recognized.text);
      _translate(recognized.text);
    }
  }

  void _translate(String input) async {
    final result = await _engine.translate(input, "luo");
    setState(() => _translated = result);
    _tts.speak(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LUGHAFY v1.0')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(_text, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(_translated, style: const TextStyle(fontSize: 24, color: Colors.green)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _listen,
                  child: const Icon(Icons.mic),
                ),
                FloatingActionButton(
                  onPressed: _scan,
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
