import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'coseries.com',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  bool _speechEnable = false;
  String wordSpoken = "";
  double confidenceLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnable = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
      confidenceLevel = 0;
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(result) async {
    setState(() {
      wordSpoken = "${result.recognizedWords}";
      confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coseries"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                speechToText.isListening
                    ? "Listening..!"
                    : _speechEnable
                        ? "Tap to microphone to start Listening..!"
                        : "Speech not available",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                wordSpoken,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              ),
            )),
            if (speechToText.isNotListening && confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Text(
                  "Confidence: ${(confidenceLevel * 100).toStringAsFixed(1)}",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w200),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: speechToText.isListening ? stopListening : startListening,
        tooltip: "Listen",
        child: Icon(speechToText.isNotListening
            ? Icons.mic_off_outlined
            : Icons.mic_none_outlined),
      ),
    );
  }
}
