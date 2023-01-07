// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  static String m0(count, limit) =>
      "${Intl.plural(count, zero: '0 Answers', one: '1 Answer', other: '${count} Answers')} Out Of ${limit}";

  static String m1(count) =>
      "${Intl.plural(count, zero: '0 Answers', one: '1 Answer', other: '${count} Answers')}";

  static String m2(date) => "${date}";

  static String m3(count) =>
      "${Intl.plural(count, zero: 'No Questions', one: '1 Question', other: '${count} Questions')}";

  static String m4(difficulty) => "${Intl.select(difficulty, {
            'easy': 'Easy',
            'medium': 'Medium',
            'hard': 'Hard',
            'other': 'Unknown',
          })}";

  static String m5(failureReason) =>
      "Unable to save question: ${failureReason}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addOptionLabel": MessageLookupByLibrary.simpleMessage("Add Option"),
        "answerAmountWithLimitLabel": m0,
        "answerAmountWithoutLimitLabel": m1,
        "answerQuestionButtonLabel":
            MessageLookupByLibrary.simpleMessage("Answer"),
        "assessmentsSectionDisplayName":
            MessageLookupByLibrary.simpleMessage("Assessments"),
        "createLabel": MessageLookupByLibrary.simpleMessage("Create"),
        "createQuestionTitle":
            MessageLookupByLibrary.simpleMessage("Create Question"),
        "dueDateLabel": MessageLookupByLibrary.simpleMessage("Due Date"),
        "dueDateValue": m2,
        "goBackLabel": MessageLookupByLibrary.simpleMessage("Go Back"),
        "goHomeLabel": MessageLookupByLibrary.simpleMessage("Go home"),
        "isOptionCorrectLabel":
            MessageLookupByLibrary.simpleMessage("Is Correct"),
        "mustBeSetMessage": MessageLookupByLibrary.simpleMessage("Must Be Set"),
        "noConnection": MessageLookupByLibrary.simpleMessage("No Connection"),
        "noDueDateLabel": MessageLookupByLibrary.simpleMessage("No Due Date"),
        "noQuestions": MessageLookupByLibrary.simpleMessage("No questions"),
        "optionInputLabel": MessageLookupByLibrary.simpleMessage("Option"),
        "optionsTitle": MessageLookupByLibrary.simpleMessage("Options"),
        "questionAmountLabel": m3,
        "questionAnswerPageTitle":
            MessageLookupByLibrary.simpleMessage("Answering..."),
        "questionCategoriesLabel":
            MessageLookupByLibrary.simpleMessage("Categories"),
        "questionDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Description"),
        "questionDifficultyLabel":
            MessageLookupByLibrary.simpleMessage("Difficulty"),
        "questionDifficultyValue": m4,
        "questionDisplayCorrectAnswer":
            MessageLookupByLibrary.simpleMessage("Correct"),
        "questionDisplayIncorrectAnswer":
            MessageLookupByLibrary.simpleMessage("Incorrect"),
        "questionSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Question Saved"),
        "questionSavingFailure": m5,
        "questionSavingFailureNoCorrectOption":
            MessageLookupByLibrary.simpleMessage(
                "Unable to save question: No correct option"),
        "questionTitleLabel": MessageLookupByLibrary.simpleMessage("Title"),
        "questionsSectionDisplayName":
            MessageLookupByLibrary.simpleMessage("Questions"),
        "resultsSectionDisplayName":
            MessageLookupByLibrary.simpleMessage("Results"),
        "saveLabel": MessageLookupByLibrary.simpleMessage("Save"),
        "unableToDisplayQuestion":
            MessageLookupByLibrary.simpleMessage("Unable to display question"),
        "workInProgressMessage": MessageLookupByLibrary.simpleMessage(
            "We\'re still working on that!")
      };
}
