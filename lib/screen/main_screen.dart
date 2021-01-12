import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _storage = FlutterSecureStorage();
  String _password;
  bool _lettersCheckBox = false;
  bool _numbersCheckBox = false;
  bool _symbolsCheckBox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(tabs: [
          Tab(
            icon: Icon(Icons.accessible_sharp),
          ),
          Tab(
            icon: Icon(Icons.save),
          )
        ]),
      ),
      body: TabBarView(children: []),
    );
  }

  _savedPasswordsTab() {
    return ListView(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SelectableText(_password ?? ''),
          ),
        ),
        CheckboxListTile(
            value: _numbersCheckBox,
            onChanged: (value) => _numbersCheckBox = value),
        CheckboxListTile(
            value: _symbolsCheckBox,
            onChanged: (value) => _symbolsCheckBox = value),
        CheckboxListTile(
            value: _numbersCheckBox,
            onChanged: (value) => _numbersCheckBox = value),
      ],
    );
  }
}
