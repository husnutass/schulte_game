import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _appState createState() => _appState();
}

// ignore: camel_case_types
class _appState extends State<MyApp> {
  var activeState = 1;
  var date;
  int numberNeeded = 1;

  List items = List.generate(16, (index) => index + 1);

  List visibility = List.generate(16, (index) => true);

  bool onTapped(int val, context) {
    if (val == 16 && val == numberNeeded) {
      var lastDate = DateTime.now().millisecondsSinceEpoch;
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tebrikler!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Skorunuz:'),
                  Text(
                    (((lastDate - date) / 1000)).round().toString() + ' saniye',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Kapat',
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  setState(() {
                    visibility = List.generate(16, (index) => true);
                    numberNeeded = 1;
                    this.activeState = 1;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('Tekrar'),
                color: Colors.amberAccent,
                onPressed: () {
                  setState(() {
                    visibility = List.generate(16, (index) => true);
                    numberNeeded = 1;
                    date = DateTime.now().millisecondsSinceEpoch;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (val == numberNeeded) {
      numberNeeded++;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    items.shuffle();

    return MaterialApp(
      title: 'Schulte Table',
      theme: ThemeData.dark(),
      home: myHome(context: context),
    );
  }

  Scaffold myHome({BuildContext context}) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schulte Table'),
      ),
      body: activeState == 1 ? startButton() : gridBody(),
    );
  }

  Container gridBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Center(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (onTapped(items[index], context)) {
                          visibility[index] = false;
                        }
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: visibility[index] ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Card(
                        color: Colors.amber,
                        child: ListTile(
                            title: Center(
                          child: Text(
                            items[index].toString(),
                            style: TextStyle(fontSize: 26),
                          ),
                        )),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
        ),
      ),
    );
  }

  Container startButton() {
    return Container(
      child: Center(
        child: FlatButton(
          child: Text(
            "BAŞLA",
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            setState(() {
              this.activeState = 2;
              this.date = DateTime.now().millisecondsSinceEpoch;
            });
          },
          color: Colors.amber,
          minWidth: 200,
          height: 200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
