class Cita {
  String _title;
  String _description;

  Cita(this._title, this._description);

  String get title => _title;
  String get description => _description;

  set title(String newTitle) {
    _title = newTitle;
  }

  set description(String newDescription) {
    _description = newDescription;
  }
}