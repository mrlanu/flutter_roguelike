import 'package:plain_ecs/plain_ecs.dart';

extension RecordExtension1<T1 extends Component> on (List<T1>,) {
  List<(T1,)> join() {
    final result = <(T1,)>[];

    // Iterate over list1 and check if entity exists in list2
    for (var component1 in this.$1) {
      result.add((component1,));
    }
    return result;
  }
}

extension RecordExtension2<T1 extends Component, T2 extends Component> on (
  List<T1>, List<T2>) {
  List<(T1, T2)> join() {
    final result = <(T1, T2)>[];

    // Convert second list to a map for efficient lookup by entity
    Map<int, T2> entityMap = {
      for (var component in this.$2) component.entity: component
    };

    // Iterate over list1 and check if entity exists in list2
    for (var component1 in this.$1) {
      if (entityMap.containsKey(component1.entity)) {
        result.add((component1, entityMap[component1.entity]!));
      }
    }

    return result;
  }
}

extension RecordExtension3<T1 extends Component, T2 extends Component,
    T3 extends Component> on (List<T1>, List<T2>, List<T3>) {
  List<(T1, T2, T3)> join() {
    final result = <(T1, T2, T3)>[];

    // Convert list2 and list3 to maps for efficient lookup by entity
    Map<int, T2> map2 = {
      for (var component in this.$2) component.entity: component
    };
    Map<int, T3> map3 = {
      for (var component in this.$3) component.entity: component
    };

    // Iterate over list1 and check if entity exists in both map2 and map3
    for (var component1 in this.$1) {
      if (map2.containsKey(component1.entity) &&
          map3.containsKey(component1.entity)) {
        result.add(
            (component1, map2[component1.entity]!, map3[component1.entity]!));
      }
    }

    return result;
  }
}
