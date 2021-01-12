import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
// import 'package:flutter_localizations/flutter_localizations.dart';

class IVLocalizations {
  IVLocalizations(this.locale);

  final Locale locale;

  static IVLocalizations of(BuildContext context) {
    return Localizations.of<IVLocalizations>(context, IVLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'pt': {
      'title': 'Olá mundo',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}

class IVLocalizationsDelegate extends LocalizationsDelegate<IVLocalizations> {
  const IVLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<IVLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<IVLocalizations>(IVLocalizations(locale));
  }

  @override
  bool shouldReload(IVLocalizationsDelegate old) => false;
}
