import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnkiDroidAPI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_ankidroid_api demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DemoPage(title: 'flutter_ankidroid_api demo'),
    );
  }
}

class DemoPage extends StatefulWidget {
  DemoPage({this.title});
  final String title;

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  TextEditingController _deckController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  String _deck = "";
  String _subject = "";
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "You can edit the the appropriate below to test adding a note to AnkiDroid",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 50),
              TextFormField(
                decoration: InputDecoration(labelText: "Deck"),
                controller: _deckController,
                onChanged: (deck) {
                  _deck = deck;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Front"),
                controller: _subjectController,
                onChanged: (subject) {
                  _subject = subject;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Back"),
                controller: _textController,
                onChanged: (text) {
                  _text = text;
                },
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  requestPermissions();
                  addNote(_deck, "", "", _subject, _text, "", "");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Add note to AnkiDroid with subject',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

main() {
  runApp(AnkiDroidAPI());
}

Future<void> requestPermissions() async {
  const platform = const MethodChannel('com.lrorpilla.api/ankidroid');
  await platform.invokeMethod('requestPermissions');
}

Future<void> addNote(
  String deck,
  String image,
  String audio,
  String sentence,
  String answer,
  String meaning,
  String reading,
) async {
  const platform = const MethodChannel('com.lrorpilla.api/ankidroid');

  try {
    await platform.invokeMethod('addNote', <String, dynamic>{
      'deck': deck,
      'image': image,
      'audio': audio,
      'sentence': sentence,
      'answer': answer,
      'meaning': meaning,
      'reading': reading,
    });
  } on PlatformException catch (e) {
    print("Failed to add note via AnkiDroid API");
    print(e);
  }
}
