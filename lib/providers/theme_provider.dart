import 'package:flutter/material.dart';
import '../themes/default_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData temaActual;
  bool _isDarkMode;

  ThemeProvider({required bool isDarkMode})
      : _isDarkMode = isDarkMode,
        temaActual =
            (isDarkMode) ? DefaultTheme.darkTheme : DefaultTheme.lightTheme;

  bool get isDarkMode => _isDarkMode;

  void setLight() {
    print('setLight');
    _isDarkMode = false;
    temaActual = DefaultTheme.lightTheme;
    notifyListeners();
  }

  void setDark() {
    print('setDark');
    _isDarkMode = true;
    temaActual = DefaultTheme.darkTheme;
    notifyListeners();
  }
}



/*import 'package:flutter/material.dart';
import '../themes/default_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData temaActual;

  ThemeProvider({required bool isDarkMode})
      : temaActual =
            (isDarkMode) ? DefaultTheme.darkTheme : DefaultTheme.lightTheme;

  setLight() {
    print('setLight');
    temaActual = DefaultTheme.lightTheme;
    notifyListeners();
  }

  setDark() {
    print('setLight');
    temaActual = DefaultTheme.darkTheme;
    notifyListeners();
  }
}*/
