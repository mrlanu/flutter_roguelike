class PriorityQueue<T> {
  final List<T> _heap = [];
  final int Function(T, T) _comparator;

  PriorityQueue(this._comparator);

  bool get isEmpty => _heap.isEmpty;
  bool get isNotEmpty => _heap.isNotEmpty;

  void add(T element) {
    _heap.add(element);
    _bubbleUp(_heap.length - 1);
  }

  T removeFirst() {
    if (_heap.isEmpty) {
      throw StateError('Priority queue is empty');
    }
    final T result = _heap.first;
    final T last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _bubbleDown(0);
    }
    return result;
  }

  T get peek {
    if (_heap.isEmpty) {
      throw StateError('Priority queue is empty');
    }
    return _heap.first;
  }

  T firstWhere(bool Function(T) test, {T Function()? orElse}) {
    for (var element in _heap) {
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError('No element satisfies the condition');
  }

  bool contains(T element) {
    return _heap.contains(element);
  }

  void _bubbleUp(int index) {
    while (index > 0) {
      final int parentIndex = (index - 1) >> 1;
      if (_comparator(_heap[index], _heap[parentIndex]) >= 0) {
        break;
      }
      _swap(index, parentIndex);
      index = parentIndex;
    }
  }

  void _bubbleDown(int index) {
    final int length = _heap.length;
    int leftChildIndex = (index << 1) + 1;

    while (leftChildIndex < length) {
      final int rightChildIndex = leftChildIndex + 1;
      int minChildIndex = leftChildIndex;

      if (rightChildIndex < length &&
          _comparator(_heap[rightChildIndex], _heap[leftChildIndex]) < 0) {
        minChildIndex = rightChildIndex;
      }

      if (_comparator(_heap[index], _heap[minChildIndex]) <= 0) {
        break;
      }

      _swap(index, minChildIndex);
      index = minChildIndex;
      leftChildIndex = (index << 1) + 1;
    }
  }

  void _swap(int i, int j) {
    final T temp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = temp;
  }
}
