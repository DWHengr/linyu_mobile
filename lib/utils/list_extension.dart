extension UsersListExtension<E extends Map<String, dynamic>> on List {
  bool include(Map value) {
    for (E e in this) {
      if (e['friendId'] == value['friendId']) return true;
    }
    return false;
  }

  bool delete(Map value) {
    for (E e in this) {
      if (e['friendId'] == value['friendId']) {
        return remove(e);
      }
    }
    return false;
  }
}
