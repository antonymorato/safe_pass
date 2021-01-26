import 'dart:math';

class PasswordGenerator {
  bool _letterGen;
  bool _numGen;
  bool _symGen;
  String _generatedValue;

  PasswordGenerator() {
    _letterGen = true;
    _numGen = false;
    _symGen = false;
    _generatedValue = "Press Generate";
  }

  void generate(int n) {
    _generatedValue = "";

    if (!_letterGen && !_numGen && !_symGen) {
      _generatedValue = "No character type selected";
      return;
    }

    for (n; n > 0; n--) {
      String toAppend;
      Random random = new Random();

      while (toAppend == null) {
        int selector = random.nextInt(3);

        if (selector == 0) {
          toAppend = _generateLetter();
        } else if (selector == 1) {
          toAppend = _generateNumber();
        } else {
          toAppend = _generateSymbol();
        }
      }

      _generatedValue += toAppend;
      toAppend = null;
    }
  }

  String _generateLetter() {
    if (!_letterGen) return null;

    int base = "a".codeUnitAt(0);
    int baseUpper = "A".codeUnitAt(0);
    int maxRand = ("z".codeUnitAt(0) - base) + 1;
    Random random = new Random();

    if (random.nextInt(2) == 0) {
      return String.fromCharCodes([random.nextInt(maxRand) + base]);
    } else {
      return String.fromCharCodes([random.nextInt(maxRand) + baseUpper]);
    }
  }

  String _generateNumber() {
    if (!_numGen) return null;

    int base = "0".codeUnitAt(0);
    int maxRand = ("9".codeUnitAt(0) - base) + 1;
    Random random = new Random();

    return String.fromCharCodes([random.nextInt(maxRand) + base]);
  }

  String _generateSymbol() {
    if (!_symGen) return null;

    int base = "!".codeUnitAt(0);
    int maxRand = (".".codeUnitAt(0) - base) + 1;
    Random random = new Random();

    return String.fromCharCodes([random.nextInt(maxRand) + base]);
  }

  void checkLetterGen(bool value) {
    _letterGen = value;
  }

  void checkNumGen(bool value) {
    _numGen = value;
  }

  void checkSymGen(bool value) {
    _symGen = value;
  }

  String getGeneratedValue() {
    return _generatedValue;
  }
}
