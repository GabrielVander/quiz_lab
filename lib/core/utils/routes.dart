enum Routes {
  home(name: 'home', path: '/'),
  createQuestion(name: 'createQuestion', path: '/question/new'),
  displayQuestion(name: 'displayQuestion', path: '/question/:id');

  const Routes({required this.name, required this.path});

  final String name;
  final String path;
}
