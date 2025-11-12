import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _text = 'Tap the mic to speak in any of 10 Kenyan languages.';
  String _translated = 'Translation will appear here...';

  // v0.2: Real demo translations for 10 languages (expand to 68 later)
  final Map<String, Map<String, String>> translations = {
    'mambo vipi': {
      'luo': 'Iyo maber! (Dholuo)',
      'kikuyu': 'Mwarĩ mwega! (Kikuyu)',
      'kamba': 'Mwaĩ! (Kamba)',
      'luhya': 'Murathĩ? (Luhya)',
      'kalenjin': 'Kipkemei! (Kalenjin)',
      'maasai': 'Enkaita! (Maasai)',
      'somali': 'Sidee tahay? (Somali)',
      'meru': 'Mwega! (Meru)',
      'kisii': 'Oro etot! (Kisii)',
      'swahili': 'Habari yako? (Swahili)',
    },
    'nimechoka': {
      'luo': 'Asechoka (Dholuo)',
      'kikuyu': 'Ndacemire (Kikuyu)',
      'kamba': 'Nĩsemĩka (Kamba)',
      'luhya': 'Nĩngeĩka (Luhya)',
      'kalenjin': 'Achepko (Kalenjin)',
      'maasai': 'Naita (Maasai)',
      'somali': 'Waan daalan (Somali)',
      'meru': 'Njĩsemĩre (Meru)',
      'kisii': 'Nĩngeĩka (Kisii)',
      'swahili': 'Nimechoka (Swahili)',
    },
    // Add Sheng: "si uko na mabanga" → "Je, una pesa?"
    'si uko na mabanga': {
      'swahili': 'Je, una pesa? (Formal Swahili)',
      'luo': 'Donge in gi mbeca? (Dholuo)',
    },
  };

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _tts.setLanguage('sw-KE');
    _tts.setSpeechRate(0.8);
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            _translateAndSpeak(result.recognizedWords.toLowerCase());
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _translateAndSpeak(String input) {
    String lowerInput = input.toLowerCase();
    String targetLang = 'luo'; // Default; add dropdown later
    String translation = 'Lughafy: Learning more phrases...';

    for (var entry in translations.entries) {
      if (lowerInput.contains(entry.key)) {
        translation = entry.value[targetLang] ?? entry.value['swahili'] ?? translation;
        break;
      }
    }

    setState(() => _translated = translation);
    _tts.speak(translation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lughafy', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.translate, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(_text, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Text(_translated, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            FloatingActionButton.large(
              onPressed: _startListening,
              backgroundColor: _isListening ? Colors.red : Colors.green,
              child: Icon(_isListening ? Icons.stop : Icons.mic),
            ),
            const SizedBox(height: 10),
            const Text('Tap mic to translate (v0.2)', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
