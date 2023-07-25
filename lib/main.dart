import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:server_project/data.dart';

void main() {
  getstudents();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme:
            InputDecorationTheme(border: OutlineInputBorder()),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Color(0xff16E5A7)),
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Android expert"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => _AddStudentForm()));
              setState(() {});
            },
            label: Row(
              children: [Icon(Icons.add), Text("Add Student")],
            )),
        body: FutureBuilder<List<StudentData>>(
          future: getstudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  padding: EdgeInsets.only(bottom: 84),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _Student(
                      data: snapshot.data![index],
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class _Student extends StatelessWidget {
  final StudentData data;

  const _Student({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
          ]),
      child: Row(children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
          child: Text(
            data.firstName.characters.first,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 24),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.firstName + " " + data.lastName),
              SizedBox(
                height: 8,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey.shade200),
                  child: Text(
                    data.course,
                    style: TextStyle(fontSize: 10),
                  ))
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              color: Colors.grey,
            ),
            Text(
              data.score.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )
      ]),
    );
  }
}

class _AddStudentForm extends StatelessWidget {
  final TextEditingController _firstnamecontrooller = TextEditingController();
  final TextEditingController _lastnamecontrooller = TextEditingController();
  final TextEditingController _courdsecontrooller = TextEditingController();
  final TextEditingController _scorecontrooller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add student"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final newStudentdata = await saveStudent(
                _firstnamecontrooller.text,
                _lastnamecontrooller.text,
                _courdsecontrooller.text,
                int.parse(_scorecontrooller.text));
            Navigator.pop(context, newStudentdata);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        label: Row(
          children: [Icon(Icons.check), Text("save")],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _textfield("firstname", _firstnamecontrooller, TextInputType.text),
            SizedBox(
              height: 8,
            ),
            _textfield("lastname", _lastnamecontrooller, TextInputType.text),
            SizedBox(
              height: 8,
            ),
            _textfield("course", _courdsecontrooller, TextInputType.text),
            SizedBox(
              height: 8,
            ),
            _textfield("score", _scorecontrooller, TextInputType.number)
          ],
        ),
      ),
    );
  }

  TextField _textfield(value, controller, type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        label: Text(value),
      ),
    );
  }
}
