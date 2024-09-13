class Storage {
  final Map<Type, Object> _storage = {};

  void put(Object object) {
    Type t = object.runtimeType;
    if (_storage.containsKey(t)) {
      throw ArgumentError("Storage contains $t type already.");
    }
    _storage.putIfAbsent(
      object.runtimeType,
      () => object,
    );
  }

  T get<T>() {
    return _storage.containsKey(T)
        ? _storage[T] as T
        : throw ArgumentError("Storage doesn\'t contain $T type.");
  }
}
