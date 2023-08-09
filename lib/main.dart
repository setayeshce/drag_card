import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag & Drop Sentence',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SentenceGame(),
    );
  }
}

class SentenceGame extends StatefulWidget {
  @override
  _SentenceGameState createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  late String sentence;
  List<String> originalWords = [];
  List<String> displayedWords = [];
  List<String?> sortedDisplayedWords = [];

  @override
  void initState() {
    super.initState();
    sentence = "Hello, my name is Alice";
    originalWords = convertSentenceToWords(sentence);
    displayedWords = List.from(originalWords);
    displayedWords.shuffle(Random());
    sortedDisplayedWords = List.filled(originalWords.length, null);
  }

  List<String> convertSentenceToWords(String sentence) {
    List<String> words = sentence.replaceAll(RegExp(r'[.,;!?]'), '').split(' ');
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 20,
          ),
          Text('compelete the sentence'),
          SizedBox(
            height: MediaQuery.of(context).padding.top * 0.5,
          ),
          Row(
            children: List.generate(sortedDisplayedWords.length, (index) {
              return Expanded(
                child: DragTarget<String>(
                  onAccept: (receivedWord) {
                    setState(() {
                      if (receivedWord == originalWords[index]) {
                        sortedDisplayedWords[index] = receivedWord;
                      } else if (sortedDisplayedWords.contains(receivedWord)) {
                        int originalIndex = originalWords.indexOf(receivedWord);
                        sortedDisplayedWords[originalIndex] = receivedWord;
                      }
                    });
                  },
                  builder: (context, incoming, rejected) {
                    Color color = Colors.grey;
                    if (sortedDisplayedWords[index] != null) {
                      color =
                          (sortedDisplayedWords[index] == originalWords[index])
                              ? Colors.green
                              : Colors.red;
                    }
                    return WordBox(
                        word: sortedDisplayedWords[index], bgColor: color);
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayedWords.length,
              itemBuilder: (context, index) {
                return Draggable<String>(
                  data: displayedWords[index],
                  child: WordBox(word: displayedWords[index]),
                  feedback:
                      WordBox(word: displayedWords[index], isDragging: true),
                  childWhenDragging:
                      WordBox(word: displayedWords[index], isGhost: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WordBox extends StatelessWidget {
  final String? word;
  final Color bgColor;
  final bool isGhost;
  final bool isDragging;

  const WordBox(
      {this.word,
      this.bgColor = Colors.white,
      this.isGhost = false,
      this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 100,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isGhost ? Colors.transparent : bgColor,
          borderRadius: BorderRadius.circular(10),
          border: isGhost ? Border.all(color: Colors.grey) : null,
          boxShadow: isDragging
              ? [BoxShadow(blurRadius: 10, color: Colors.black26)]
              : null,
        ),
        child: Center(
          child: Text(
            word ?? '',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
