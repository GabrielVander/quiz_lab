enum Routes {
  assessments(name: 'assessments', path: '/assessments'),
  questionsOverview(name: 'questionsOverview', path: '/questions'),
  resultsOverview(name: 'resultsOverview', path: '/results'),
  createQuestion(name: 'createQuestion', path: 'new'),
  displayQuestion(name: 'displayQuestion', path: ':id'),
  login(name: 'login', path: '/login'),
  configuration(name: 'configuration', path: '/configuration');

  const Routes({required this.name, required this.path});

  final String name;
  final String path;
}
