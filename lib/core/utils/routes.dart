enum Routes {
  home(name: 'home', path: '/'),
  createQuestion(name: 'createQuestion', path: '/question/new'),
  displayQuestion(name: 'displayQuestion', path: '/question/:id'),
  login(name: 'login', path: '/login');

  const Routes({required this.name, required this.path});

  final String name;
  final String path;
}
