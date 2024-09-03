class BitSet {
  final int size;
  final List<bool> _bits;

  BitSet(this.size) : _bits = List.filled(size, false);

  void set(int index) {
    _bits[index] = true;
  }

  void clear(int index) {
    _bits[index] = false;
  }

  bool isSet(int index) {
    return _bits[index];
  }

  void toggle(int index) {
    _bits[index] = !_bits[index];
  }

  void reset() {
    for (var i = 0; i < size; i++) {
      _bits[i] = false;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BitSet) return false;
    if (size != other.size) return false;

    for (var i = 0; i < size; i++) {
      if (_bits[i] != other._bits[i]) {
        return false;
      }
    }

    return true;
  }

  BitSet operator &(BitSet other) {
    // Ensure the other bitset is the same size or the smaller size is used
    final minSize = size < other.size ? size : other.size;
    final result = BitSet(minSize);

    for (var i = 0; i < minSize; i++) {
      result._bits[i] = _bits[i] && other._bits[i];
    }

    return result;
  }

  BitSet operator |(BitSet other) {
    final maxSize = size > other.size ? size : other.size;
    final result = BitSet(maxSize);

    for (var i = 0; i < size; i++) {
      result._bits[i] = _bits[i];
    }
    for (var i = 0; i < other.size; i++) {
      result._bits[i] = result._bits[i] || other._bits[i];
    }

    return result;
  }

  BitSet operator ^(BitSet other) {
    final maxSize = size > other.size ? size : other.size;
    final result = BitSet(maxSize);

    for (var i = 0; i < size; i++) {
      result._bits[i] = _bits[i] && !other._bits[i];
    }
    for (var i = 0; i < other.size; i++) {
      result._bits[i] = result._bits[i] || (!result._bits[i] && other._bits[i]);
    }

    return result;
  }

  BitSet operator ~() {
    final result = BitSet(size);

    for (var i = 0; i < size; i++) {
      result._bits[i] = !_bits[i];
    }

    return result;
  }

  @override
  String toString() {
    return _bits.reversed.map((bit) => bit ? '1' : '0').join();
  }
}
