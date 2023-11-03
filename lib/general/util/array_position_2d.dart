class ArrayPosition2D {
  ArrayPosition2D({required this.row, required this.col});

  final int row;
  final int col;

  factory ArrayPosition2D.argmax(List<dynamic> qValues) {
    int row = 0;
    int col = 0;
    double maxValue = qValues[row][col];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (qValues[i][j] > maxValue) {
          row = i;
          col = j;
          maxValue = qValues[i][j];
        }
      }
    }
    return ArrayPosition2D(row: row, col: col);
  }
}
