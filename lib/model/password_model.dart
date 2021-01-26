import 'package:floor/floor.dart';

@entity
class PasswordModel {
  @PrimaryKey(autoGenerate: true)
  int _id;
  String _passwordName;
  String _password;
}
