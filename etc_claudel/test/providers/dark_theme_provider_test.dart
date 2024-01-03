import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:etc_claudel/Services/dark_theme_prefs.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';



// Mock DarkThemePrefs
class MockDarkThemePrefs extends Mock implements DarkThemePrefs {}

void main() {
  group('DarkThemeProvider Tests', () {
    test('Initialize DarkThemeProvider with dark theme disabled', () {
      final mockDarkThemePrefs = MockDarkThemePrefs();
      final darkThemeProvider = DarkThemeProvider();
      darkThemeProvider.darkThemePrefs = mockDarkThemePrefs;

      expect(darkThemeProvider.getDarkTheme, false);
    });

    test('Enable dark theme and notify listeners', () async {
      final mockDarkThemePrefs = MockDarkThemePrefs();
      final darkThemeProvider = DarkThemeProvider();
      darkThemeProvider.darkThemePrefs = mockDarkThemePrefs;

        
      darkThemeProvider.darkThemePrefs.setDarkTheme(true);

      expect(darkThemeProvider.getDarkTheme, true);
      verify(mockDarkThemePrefs.setDarkTheme(true));
      verify(darkThemeProvider.notifyListeners());
    });

    test('Disable dark theme and notify listeners', () async {
      final mockDarkThemePrefs = MockDarkThemePrefs();
      final darkThemeProvider = DarkThemeProvider();
      darkThemeProvider.darkThemePrefs = mockDarkThemePrefs;

       darkThemeProvider.darkThemePrefs.setDarkTheme(false);

      expect(darkThemeProvider.getDarkTheme, false);
      verify(mockDarkThemePrefs.setDarkTheme(false));
      verify(darkThemeProvider.notifyListeners());
    });
  });
}