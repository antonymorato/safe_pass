import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_pass/util/clipboard_util.dart';

class PasswordListTile extends StatefulWidget {
  PasswordListTile(this._passwordName, this._password, {Key key})
      : super(key: key);
  String _passwordName;
  String _password;
  @override
  _PasswordListTileState createState() => _PasswordListTileState();
}

class _PasswordListTileState extends State<PasswordListTile> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.greenAccent, borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  widget._passwordName,
                  style: TextStyle(color: Colors.white),
                ),
                Visibility(
                    visible: _visible,
                    child: SelectableText(widget._password,
                        style: TextStyle(color: Colors.white)))
              ],
            ),
          ),
          IconButton(
              icon: _visible == false
                  ? Icon(Icons.visibility_off, color: Colors.white)
                  : Icon(Icons.visibility, color: Colors.white),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              }),
          IconButton(
              icon: Icon(Icons.copy, color: Colors.white),
              onPressed: () {
                ClipboardUtil.copyToClipboard(widget._password);
                ScaffoldMessenger.of(context)
                    .showSnackBar(ClipboardUtil.copiedSnackBar());
              })
        ],
      ),
    );
  }
}
