extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  E? lastWhereOrNull(bool Function(E) test) {
    if (this is! List) return null;

    for (E element in (this as List).reversed) {
      if (test(element)) return element;
    }
    return null;
  }
}
