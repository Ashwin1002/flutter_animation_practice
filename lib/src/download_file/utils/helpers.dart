String commentBricks({String symbol = ':', int brick = 10}) {
  return List.generate(brick, (index) => symbol).join();
}
