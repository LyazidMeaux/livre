abstract class IsSillly {
  void makePeopleLaugh();
}

class Clown implements IsSillly {
  @override
  void makePeopleLaugh() {
    print('Ah Ah Ah');
  }
}

class Comedian implements IsSillly {
  @override
  void makePeopleLaugh() {
    print('Snif Snif');
  }
}
