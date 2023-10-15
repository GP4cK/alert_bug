import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void openAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(content: MyTextField());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(),
            SizedBox(height: 24),
            Text('Tap the FAB and type "abc"'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAlert(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyTextController extends TextEditingController {
  static const textToReplace = 'abc';

  static final replacement = TextSpan(children: [
    WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      baseline: TextBaseline.ideographic,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.blue),
        ),
        child: const Text(textToReplace),
      ),
    ),
    // Adds invisible characters to the end of the span to make sure the
    // cursor is at the right place
    // https://stackoverflow.com/questions/66304688/cursor-wrong-position-after-text-replacing-with-textspan.
    TextSpan(text: '\u200b' * (textToReplace.length - 1)),
  ]);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    return TextSpan(
      children: text
          .split(textToReplace)
          .map((str) =>
              TextSpan(text: str, style: const TextStyle(color: Colors.black)))
          .separated(replacement)
          .toList(),
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final controller = MyTextController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
    );
  }
}

extension<T> on Iterable<T> {
  /// Puts [separator] between every element.
  ///
  /// Example:
  ///
  /// ```dart
  /// final list1 = <int>[].separated(2); // [];
  /// final list2 = [0].separated(2); // [0];
  /// final list3 = [0, 0].separated(2); // [0, 2, 0];
  /// ```
  Iterable<T> separated(T separator) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield separator;
        yield iterator.current;
      }
    }
  }
}
