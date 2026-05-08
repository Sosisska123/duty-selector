enum DutySelectionType {
  byHand('Вручную', 'Вручную', 'Выбрать из списка'),
  next2('Следующие 2 по списку', 'След. 2', 'Выбрать следующих 2 по списку'),
  next4('Следующие 4 по списку', 'След. 4', 'Выбрать следующих 4 по списку'),
  random('Рандом', 'Рандом', 'Выбрать 2 случайных (ПОКА НЕ РАБОТАЕТ)');

  final String name;
  final String shortName;
  final String description;

  const DutySelectionType(this.name, this.shortName, this.description);
}
