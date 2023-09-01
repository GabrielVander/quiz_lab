// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
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
  String get localeName => 'pt_BR';

  static String m0(count, limit) =>
      "${Intl.plural(count, one: '1 Resposta', other: '${count} Respostas')} De ${limit}";

  static String m1(count) =>
      "${Intl.plural(count, one: '1 Resposta', other: '${count} Respostas')}";

  static String m2(date) => "${date}";

  static String m3(count) =>
      "${Intl.plural(count, zero: 'Nenhuma Questão', one: '1 Questão', other: '${count} Questões')}";

  static String m4(difficulty) => "${Intl.select(difficulty, {
            'easy': 'Fácil',
            'medium': 'Médio',
            'hard': 'Difícil',
            'other': 'Desconhecido',
          })}";

  static String m5(displayName) => "por ${displayName}";

  static String m6(failureReason) =>
      "Problemas ao salvar questão: ${failureReason}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addOptionLabel":
            MessageLookupByLibrary.simpleMessage("Adicionar Opção"),
        "answerAmountWithLimitLabel": m0,
        "answerAmountWithoutLimitLabel": m1,
        "answerQuestionButtonLabel":
            MessageLookupByLibrary.simpleMessage("Responder"),
        "assessmentsSectionDisplayName":
            MessageLookupByLibrary.simpleMessage("Avaliações"),
        "createLabel": MessageLookupByLibrary.simpleMessage("Criar"),
        "createQuestionTitle":
            MessageLookupByLibrary.simpleMessage("Criar Questão"),
        "dontHaveAnAccountPhrase":
            MessageLookupByLibrary.simpleMessage("Ainda não tem uma conta?"),
        "dueDateLabel": MessageLookupByLibrary.simpleMessage("Data Limite"),
        "dueDateValue": m2,
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "enterAnonymouslyButtonLabel":
            MessageLookupByLibrary.simpleMessage("Entrar anonimamente"),
        "genericErrorMessage":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "goBackLabel": MessageLookupByLibrary.simpleMessage("Voltar"),
        "goHomeLabel": MessageLookupByLibrary.simpleMessage("Página inicial"),
        "isOptionCorrectLabel": MessageLookupByLibrary.simpleMessage("Correta"),
        "isQuestionPublicLabel":
            MessageLookupByLibrary.simpleMessage("Pública"),
        "logInButtonLabel": MessageLookupByLibrary.simpleMessage("Entrar"),
        "loginPageDisplayTitle":
            MessageLookupByLibrary.simpleMessage("Entre com sua conta"),
        "loginPageSignUpButtonLabel":
            MessageLookupByLibrary.simpleMessage("Cadastre-se"),
        "mustBeSetMessage":
            MessageLookupByLibrary.simpleMessage("Deve Estar Preenchido"),
        "noConnection": MessageLookupByLibrary.simpleMessage("Sem Conexão"),
        "noDueDateLabel":
            MessageLookupByLibrary.simpleMessage("Sem Data Limite"),
        "noQuestions": MessageLookupByLibrary.simpleMessage("Nenhuma questão"),
        "notYetImplemented":
            MessageLookupByLibrary.simpleMessage("Ainda não implementado"),
        "openRandomQuestionButtonLabel":
            MessageLookupByLibrary.simpleMessage("Aleatória"),
        "optionInputLabel": MessageLookupByLibrary.simpleMessage("Opção"),
        "optionsTitle": MessageLookupByLibrary.simpleMessage("Opções"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Senha"),
        "questionAmountLabel": m3,
        "questionAnswerPageTitle":
            MessageLookupByLibrary.simpleMessage("Respondendo..."),
        "questionCategoriesLabel":
            MessageLookupByLibrary.simpleMessage("Categorias"),
        "questionDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Descrição"),
        "questionDifficultyLabel":
            MessageLookupByLibrary.simpleMessage("Dificuldade"),
        "questionDifficultyValue": m4,
        "questionDisplayCorrectAnswer":
            MessageLookupByLibrary.simpleMessage("Correto"),
        "questionDisplayIncorrectAnswer":
            MessageLookupByLibrary.simpleMessage("Incorreto"),
        "questionOwnerDisplayName": m5,
        "questionSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Questão salva"),
        "questionSavingFailure": m6,
        "questionSavingFailureNoCorrectOption":
            MessageLookupByLibrary.simpleMessage(
                "Problema ao salvar questão: Nenhumas das opções está marcada como correta"),
        "questionTitleLabel": MessageLookupByLibrary.simpleMessage("Título"),
        "questionsSectionDisplayName":
            MessageLookupByLibrary.simpleMessage("Questões"),
        "resultsSectionDisplayName":
            MessageLookupByLibrary.simpleMessage("Resultados"),
        "saveLabel": MessageLookupByLibrary.simpleMessage("Salvar"),
        "unableToDisplayQuestion": MessageLookupByLibrary.simpleMessage(
            "Não foi possível exibir a questão"),
        "unableToLogin":
            MessageLookupByLibrary.simpleMessage("Não foi possível entrar"),
        "unknownQuestionOwnerDisplayName":
            MessageLookupByLibrary.simpleMessage("Desconhecido"),
        "workInProgressMessage": MessageLookupByLibrary.simpleMessage(
            "Ainda Estamos Trabalhando Nisso!")
      };
}
