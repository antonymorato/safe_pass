import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_pass/util/clipboard_util.dart';
import 'package:safe_pass/util/password_generator.dart';

import 'widgets/password_list_tile.dart';

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
  List<Widget> _savedPasswords;
  TabController _tabBarController;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _readSavedPasswords();
    _tabBarController =
        TabController(initialIndex: _selectedIndex, length: 2, vsync: this);
    _tabBarController.addListener(() {
      setState(() {
        _selectedIndex = _tabBarController.index;
      });
      print("Selected Index: " + _tabBarController.index.toString());
    });
  }

  _readSavedPasswords() async {
    try {
      var passMap = await _storage.readAll(aOptions: AndroidOptions());
      List<Widget> tempList = [];
      passMap.forEach((key, value) {
        print('key $key value $value');
        tempList.add(PasswordListTile(key, value)
            // Container(
            // margin: EdgeInsets.only(top: 5, bottom: 5),
            // child: Column(
            //   children: [
            //     Text(key),
            //     SelectableText(
            //       value,
            //       onTap: _copyToClipboard,
            //     )
            // ],
            // ),
            );
      });
      setState(() {
        _savedPasswords = tempList;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String _passName;
  _savePassword() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter password association'),
                TextField(
                  onChanged: (value) => setState(() {
                    _passName = value;
                  }),
                ),
                SizedBox(height: 10),
                Text('Your password'),
                TextField(
                  onChanged: (value) => setState(() {
                    _password = value;
                  }),
                ),
                SizedBox(height: 10),
                FlatButton(
                    onPressed: () {
                      _storage.write(key: _passName, value: _password);
                      _readSavedPasswords();
                      Navigator.of(context).pop();
                    },
                    child: Text('save'))
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          Visibility(
            visible: _password != null &&
                _password.compareTo('No character type selected') != 0,
            child: IconButton(
                icon: Icon(Icons.save_alt_sharp), onPressed: _savePassword),
          ),
          IconButton(icon: Icon(Icons.settings), onPressed: () {})
        ],
        title: Text(
          'Safe pass',
          style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.onPrimary),
        ),
        bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _tabBarController,
            tabs: [
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
        ? ListView.builder(
            itemCount: _savedPasswords.length,
            itemBuilder: (context, index) {
              return _savedPasswords[index];
            })
        : Container(
            alignment: Alignment.center,
            child: Text('Nothing saved yet'),
          );
  }

  _generatePasswordTab() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  color: Colors.greenAccent,
                  // height: 200,
                  alignment: Alignment.center,
                  child: SelectableText(
                    _password ?? '',
                    onTap: _copyToClipBoard,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                child: FlatButton(
                    onPressed: _generatePassword,
                    child: Text('Generate password')),
              ),
              Flexible(child: _lengthSlider()),
              Flexible(
                child: CheckboxListTile(
                    title: Text('Use numbers'),
                    value: _numbersCheckBox,
                    onChanged: (value) {
                      setState(() {
                        _numbersCheckBox = value;
                      });
                    }),
              ),
              Flexible(
                child: CheckboxListTile(
                    title: Text('Use symbols'),
                    value: _symbolsCheckBox,
                    onChanged: (value) {
                      setState(() {
                        _symbolsCheckBox = value;
                      });
                    }),
              ),
              Flexible(
                child: CheckboxListTile(
                    title: Text('Use letters'),
                    value: _lettersCheckBox,
                    onChanged: (value) {
                      setState(() {
                        _lettersCheckBox = value;
                      });
                    }),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  _copyToClipBoard() async {
    ClipboardUtil.copyToClipboard(_password);
    ScaffoldMessenger.of(context).showSnackBar(ClipboardUtil.copiedSnackBar());
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
