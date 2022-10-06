// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `No Connection`
  String get noConnection {
    return Intl.message(
      'No Connection',
      name: 'noConnection',
      desc: 'No connection message',
      args: [],
    );
  }

  /// `We're still working on that!`
  String get workInProgressMessage {
    return Intl.message(
      'We\'re still working on that!',
      name: 'workInProgressMessage',
      desc: 'Work-In-Progress message',
      args: [],
    );
  }

  /// `Assessments`
  String get assessmentsSectionDisplayName {
    return Intl.message(
      'Assessments',
      name: 'assessmentsSectionDisplayName',
      desc: 'Title display regarding assessments',
      args: [],
    );
  }

  /// `Questions`
  String get questionsSectionDisplayName {
    return Intl.message(
      'Questions',
      name: 'questionsSectionDisplayName',
      desc: 'Title display regarding questions',
      args: [],
    );
  }

  /// `Result`
  String get resultsSectionDisplayName {
    return Intl.message(
      'Result',
      name: 'resultsSectionDisplayName',
      desc: 'Title display regarding results',
      args: [],
    );
  }

  /// `{count, plural, zero {No Questions} one {1 Question} other {{count} Questions}}`
  String questionAmountLabel(num count) {
    return Intl.plural(
      count,
      zero: 'No Questions',
      one: '1 Question',
      other: '$count Questions',
      name: 'questionAmountLabel',
      desc: 'Question count',
      args: [count],
    );
  }

  /// `{count, plural, zero {0 Answers} one {1 Answer} other {{count} Answers}} Out Of {limit}`
  String answerAmountWithLimitLabel(num count, num limit) {
    return Intl.message(
      '${Intl.plural(count, zero: '0 Answers', one: '1 Answer', other: '$count Answers')} Out Of $limit',
      name: 'answerAmountWithLimitLabel',
      desc: 'Answer count with limit',
      args: [count, limit],
    );
  }

  /// `{count, plural, zero {0 Answers} one {1 Answer} other {{count} Answers}}`
  String answerAmountWithoutLimitLabel(num count) {
    return Intl.plural(
      count,
      zero: '0 Answers',
      one: '1 Answer',
      other: '$count Answers',
      name: 'answerAmountWithoutLimitLabel',
      desc: 'Answer count without limit',
      args: [count],
    );
  }

  /// `No Due Date`
  String get noDueDateLabel {
    return Intl.message(
      'No Due Date',
      name: 'noDueDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get dueDateLabel {
    return Intl.message(
      'Due Date',
      name: 'dueDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `{date}`
  String dueDateValue(DateTime date) {
    return Intl.message(
      '$date',
      name: 'dueDateValue',
      desc: 'Assessment\'s actual due date value',
      args: [date],
    );
  }

  /// `Categories`
  String get questionCategoriesLabel {
    return Intl.message(
      'Categories',
      name: 'questionCategoriesLabel',
      desc: 'Question categories label',
      args: [],
    );
  }

  /// `Difficulty`
  String get questionDifficultyLabel {
    return Intl.message(
      'Difficulty',
      name: 'questionDifficultyLabel',
      desc: 'Question difficulty label',
      args: [],
    );
  }

  /// `{difficulty, select, easy {Easy} medium {Medium} hard {Hard} other {Unknown}}`
  String questionDifficultyValue(String difficulty) {
    return Intl.select(
      difficulty,
      {
        'easy': 'Easy',
        'medium': 'Medium',
        'hard': 'Hard',
        'other': 'Unknown',
      },
      name: 'questionDifficultyValue',
      desc: 'Question\'s difficulty value',
      args: [difficulty],
    );
  }

  /// `Create Question`
  String get createQuestionTitle {
    return Intl.message(
      'Create Question',
      name: 'createQuestionTitle',
      desc: 'Question creation page\'s title',
      args: [],
    );
  }

  /// `Short Description`
  String get questionShortDescriptionLabel {
    return Intl.message(
      'Short Description',
      name: 'questionShortDescriptionLabel',
      desc: 'Question\'s short description label',
      args: [],
    );
  }

  /// `Description`
  String get questionDescriptionLabel {
    return Intl.message(
      'Description',
      name: 'questionDescriptionLabel',
      desc: 'Question\'s description label',
      args: [],
    );
  }

  /// `Go Back`
  String get goBackLabel {
    return Intl.message(
      'Go Back',
      name: 'goBackLabel',
      desc: 'Generic go back label',
      args: [],
    );
  }

  /// `Create`
  String get createLabel {
    return Intl.message(
      'Create',
      name: 'createLabel',
      desc: 'Generic create label',
      args: [],
    );
  }

  /// `Save`
  String get saveLabel {
    return Intl.message(
      'Save',
      name: 'saveLabel',
      desc: 'Generic save label',
      args: [],
    );
  }

  /// `Options`
  String get optionsTitle {
    return Intl.message(
      'Options',
      name: 'optionsTitle',
      desc: 'Options title',
      args: [],
    );
  }

  /// `Option`
  String get optionInputLabel {
    return Intl.message(
      'Option',
      name: 'optionInputLabel',
      desc: 'Option input label',
      args: [],
    );
  }

  /// `Is Correct`
  String get isOptionCorrectLabel {
    return Intl.message(
      'Is Correct',
      name: 'isOptionCorrectLabel',
      desc: 'Is the current option correct label',
      args: [],
    );
  }

  /// `Add Option`
  String get addOptionLabel {
    return Intl.message(
      'Add Option',
      name: 'addOptionLabel',
      desc: 'Add option label',
      args: [],
    );
  }

  /// `Must Be Set`
  String get mustBeSetMessage {
    return Intl.message(
      'Must Be Set',
      name: 'mustBeSetMessage',
      desc: 'Generic message for required fields',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
