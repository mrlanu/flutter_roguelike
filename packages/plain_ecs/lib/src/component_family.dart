class ComponentFamily {
  static final _componentFamilies = <Type, ComponentFamily>{};
  static int _nextBitIndex = 0;
  int _bitIndex;

  ComponentFamily() : _bitIndex = _nextBitIndex++;

  factory ComponentFamily.getFamily(Type type) =>
      _componentFamilies.putIfAbsent(type, ComponentFamily.new);

  static int getBitIndex(Type componentType) {
    return ComponentFamily.getFamily(componentType)._bitIndex;
  }
}
