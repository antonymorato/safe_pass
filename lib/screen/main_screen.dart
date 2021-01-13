import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_pass/util/password_generator.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin<MainScreen> {
  final _storage = FlutterSecureStorage();

  String _password;
  bool _lettersCheckBox = false;
  bool _numbersCheckBox = false;
  bool _symbolsCheckBox = false;
  double _passwordLength = 6.0;
  Map<String, String> _savedPasswords;
  TabController _tabBarController;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabBarController =
        TabController(initialIndex: _selectedIndex, length: 2, vsync: this);
    _tabBarController.addListener(() {
      setState(() {
        _selectedIndex = _tabBarController.index;
      });
      print("Selected Index: " + _tabBarController.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe pass'),
        bottom: TabBar(controller: _tabBarController, tabs: [
          Tab(
            text: 'Generator',
            icon: Icon(Icons.lock),
          ),
          Tab(
            text: 'Saved',
            icon: Icon(Icons.save),
          )
        ]),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: double.infinity,
        height: double.infinity,
        child: TabBarView(controller: _tabBarController, children: [
          _generatePasswordTab(),
          _savedPasswordsTab()
          // _savedPasswordsTab(),
        ]),
      ),
    );
  }

  _savedPasswordsTab() {
    return _savedPasswords != null
        ? ListView()
        : Container(
            alignment: Alignment.center,
            child: Text('Nothing saved yet'),
          );
  }

  _generatePasswordTab() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: SelectableText(
              _password ?? '',
              onTap: _copyToClipboard,
            ),
          ),
        ),
        FlatButton(
            onPressed: _generatePassword, child: Text('Generate password')),
        _lengthSlider(),
        CheckboxListTile(
            title: Text('Use numbers'),
            value: _numbersCheckBox,
            onChanged: (value) {
              setState(() {
                _numbersCheckBox = value;
              });
            }),
        CheckboxListTile(
            title: Text('Use symbols'),
            value: _symbolsCheckBox,
            onChanged: (value) {
              setState(() {
                _symbolsCheckBox = value;
              });
            }),
        CheckboxListTile(
            title: Text('Use letters'),
            value: _lettersCheckBox,
            onChanged: (value) {
              setState(() {
                _lettersCheckBox = value;
              });
            }),
      ],
    );
  }

  _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Password was copied to clipboard')));
  }

  _lengthSlider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Slider(
            value: _passwordLength,
            onChanged: (double value) {
              setState(() {
                _passwordLength = value;
              });
            },
            label: "Number of characters",
            divisions: 64,
            min: 6.0,
            max: 64.0,
          ),
        ),
        Container(
          width: 50.0,
          child: Text(
            _passwordLength.round().toString(),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  _generatePassword() {
    var generator = PasswordGenerator()
      ..checkNumGen(_numbersCheckBox)
      ..checkLetterGen(_lettersCheckBox)
      ..checkSymGen(_symbolsCheckBox);
    generator.generate(_passwordLength.round());
    setState(() {
      _password = generator.getGeneratedValue();
    });
  }
}
