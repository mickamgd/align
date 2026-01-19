enum Player { x, o }

extension PlayerX on Player {
  Player get opponent => this == Player.x ? Player.o : Player.x;

  String get label => this == Player.x ? 'X' : 'O';
}
