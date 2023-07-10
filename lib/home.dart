import 'package:flutter/material.dart';
import 'package:voice_assistant/colors.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'features_box.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'open_ai_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animate_do/animate_do.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<MyHomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = "";
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int delayTime = 200;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeek(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Pallete.whiteColor),
        titleTextStyle: const TextStyle(color: Pallete.whiteColor),
        title: const Text(
          'Sophia',
          style: TextStyle(fontFamily: 'Cera Pro'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  // virtual assistant picture
                  Center(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.assistantCircleColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(
                            'assets/images/assistantt.jpg',
                          ))),
                    ),
                  ),
                  // chat bubble
                ],
              ),
            ),
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    margin: const EdgeInsets.only(
                        top: 20, left: 40, right: 40, bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8.0),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            color: Pallete.mainFontColor,
                            fontSize: generatedContent == null ? 22 : 15,
                            fontFamily: 'Cera Pro'),
                        child: Text(
                          generatedContent == null
                              ? 'Hello, What Task can i do for you?'
                              : generatedContent!,
                        ),
                      ),
                    )),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 30),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(generatedImageUrl!)),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  //margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            //feactures
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: delayTime),
                    child: const FeaturesBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: "ChatGPT",
                      descText:
                          "A smarter way to stay organized and informed with ChatGPT",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: 2 * delayTime),
                    child: const FeaturesBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: "Dall-E",
                      descText:
                          "Get inspired and stay creative with your personal assistant powered by Dall-E",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: 3 * delayTime),
                    child: const FeaturesBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: "Smart Voice Assistant",
                      descText:
                          "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideInUp(
                  delay: Duration(milliseconds: 4 * delayTime),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 270,
                    height: 55,
                    child: TextField(
                      style: const TextStyle(color: Pallete.whiteColor),
                      controller: _controller,
                      cursorColor: Pallete.borderColor,
                      decoration: InputDecoration(
                        suffixIconColor: Pallete.secondSuggestionBoxColor,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (_controller.text.isNotEmpty) {
                              _controller.clear();
                              final speech = await openAIService
                                  .isPromptAPI(_controller.text.trim());
                              if (speech.contains('https')) {
                                generatedImageUrl = speech;
                                generatedContent = null;
                                setState(() {});
                              } else {
                                generatedImageUrl = null;
                                generatedContent = speech;
                                setState(() {});
                                await systemSpeek(speech);
                                setState(() {});
                              }
                            }
                          },
                          icon: Icon(Icons.send),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Pallete.borderColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Pallete.borderColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: 'Write something...',
                        hintStyle: const TextStyle(
                          color: Pallete.borderColor,
                          fontFamily: 'Cera Pro',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ZoomIn(
                  delay: Duration(milliseconds: 4 * delayTime),
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      backgroundColor: Pallete.secondSuggestionBoxColor,
                      onPressed: () async {
                        if (await speechToText.hasPermission &&
                            speechToText.isNotListening) {
                          await startListening();
                        } else if (speechToText.isListening) {
                          final speech =
                              await openAIService.isPromptAPI(lastWords);
                          if (speech.contains('https')) {
                            generatedImageUrl = speech;
                            generatedContent = null;
                            setState(() {});
                          } else {
                            generatedImageUrl = null;
                            generatedContent = speech;
                            setState(() {});
                            await systemSpeek(speech);
                          }
                          await stopListening();
                        } else {
                          initSpeechToText();
                        }
                      },
                      child: Icon(
                          speechToText.isListening ? Icons.stop : Icons.mic),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
