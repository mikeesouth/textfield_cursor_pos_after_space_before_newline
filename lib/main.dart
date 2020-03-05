import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _instructionText = 'The text field below has several lines. The problem is that when the cursor ' +
      'is placed at the end of line with trailing spaces, it will jump to the last' +
      'non-whitespace character. Also, when adding spaces programmatically to the end ' +
      'of a row (and setting the cursor position through the selection property on the ' +
      'controller) - the cursor position isnt updated.\n\n' +
      'Steps to reproduce the error in this minimal demo:\n' +
      '  1. Try to place the cursor at the end of line 6, note that it jumps from the real' +
      'end to the last non-whitespace character. Try to place the cursor at the end of line 7.' +
      'It actually keeps the cursor position at the end of the whitespaces, weird! Pressing ' +
      'the end of line 7 again will keep the cursor at the end, but clicking another line and ' +
      'then back to line 7 will again make the cursor jump to the last non-whitespace char.\n' +
      '  2. Try to place the cursor at the end of line 1 and click the floating action ' +
      'button. That FAB will add a space to the cursor position. Note that the cursor isnt ' +
      'moving - weird! Now place the cursor in the middle of a sentence, press the FAB. The ' +
      'cursor moves as expected. Now place the cursor at the end of line 7 (after all the ' +
      'whitespaces) and press the FAB, the cursor moves as expected!\n' +
      ' 3. Place the cursor at the end of the first line, after the colon. No spaces exists ' +
      'before the newline. Now press space (keyboard of FAB) multiple times. Spaces are added ' +
      'but cursor isnt moving. Add around 5-10 spaces. Cursor hasnt moved. Now erase the colon ' +
      'that is left of the cursor. It isnt erased? Press again, not erased? Press 10 times or ' +
      'more - finally it will be erased when all the (invisble) spaces are erased. Weird.\n' +
      '\n\n' +
      'Conclusion: whitespaces before newlines are trimmed in some way when the cursor is placed';
  final _textEditingController = TextEditingController(
    text: 'Line 1: Line without space at the end:\n' +
        'Line 2: Next line is empty\n' +
        '\n' +
        'Line 4: Next line is just 10 spaces\n' +
        '          \n' +
        'Line 6: This line ends with 5 spaces     \n' +
        'Line 7: This line ends with 5 spaces but no newline    ',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_instructionText),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade100,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    maxLines: null,
                    controller: _textEditingController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSpaceToTextEditingController,
        tooltip: 'Add space to cursor pos!',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addSpaceToTextEditingController() {
    var selection = _textEditingController.selection;
    var cursorPos = selection.baseOffset;

    if (cursorPos == -1) {
      print('!! Could not determine cursor position in text field!');
      return;
    }

    if (selection.extentOffset != cursorPos) {
      print(
          '!! A range selection was detected, please set the cursor pos without a selection');
      return;
    }
    final text = _textEditingController.text;
    final textBeforeCursor = text.substring(0, cursorPos);
    final textAfterCursor = text.substring(cursorPos, text.length);

    setState(() {
      _textEditingController.value = TextEditingValue(
        text: textBeforeCursor + ' ' + textAfterCursor,
        selection: TextSelection.collapsed(offset: cursorPos + 1),
      );
    });
  }
}
