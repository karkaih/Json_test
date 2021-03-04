import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/bYKKPeXRcO?indent=2");
    var jsonData = json.decode(data.body);

    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u["index"], u["about"], u["name"], u["picture"],
          u["company"], u["email"]);
      users.add(user);
    }

    print("the count is " + users.length.toString());

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading........."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: asyncSnapshot.data.length,
                  itemBuilder: (BuildContext context, int position) {
                    return ListTile(
                      title: Text(asyncSnapshot.data[position].name),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            asyncSnapshot.data[position].picture +
                                asyncSnapshot.data[position].index.toString() +
                                ".jpg"),
                      ),
                      subtitle: Text(asyncSnapshot.data[position].email),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    About(asyncSnapshot.data[position])));
                      },
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class User {
  final int index;
  final String about;
  final String name;
  final String picture;
  final String company;
  final String email;

  User(this.index, this.about, this.name, this.picture, this.company,
      this.email);
}

class About extends StatelessWidget {
  final User user;

  About(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome "+user.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(user.about)),
        ));
  }
}
