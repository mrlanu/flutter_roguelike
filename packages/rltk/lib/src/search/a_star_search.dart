import 'dart:math';

import 'package:rltk/rltk.dart';

// Node class to store A* information for each point
class Node {
  Node(this.point, this.g, this.h, [this.parent]);

  Point<int> point;
  double g; // cost from start to this node
  double h; // heuristic cost from this node to the end
  Node? parent;

  double get f => g + h; // total cost (g + h)
}

// A* algorithm implementation
List<Point<int>> aStar(
  BaseMap map,
  Point<int> start,
  Point<int> goal,
) {
  final openSet = PriorityQueue<Node>((a, b) => a.f.compareTo(b.f));
  final startNode = Node(start, 0, _heuristic(start, goal));
  openSet.add(startNode);

  // Set of closed nodes
  final closedSet = <Point>{};

  // Directions for horizontal, vertical, and diagonal moves
  final directions = [
    const Point(0, -1), // Up
    const Point(0, 1), // Down
    const Point(-1, 0), // Left
    const Point(1, 0), // Right
    const Point(-1, -1), // Up-left diagonal
    const Point(1, -1), // Up-right diagonal
    const Point(-1, 1), // Down-left diagonal
    const Point(1, 1), // Down-right diagonal
  ];

  while (openSet.isNotEmpty) {
    final current = openSet.removeFirst();

    if (current.point == goal) {
      return _reconstructPath(current);
    }

    closedSet.add(current.point);

    for (final dir in directions) {
      final neighborPoint =
          Point<int>(current.point.x + dir.x, current.point.y + dir.y);

      if (neighborPoint.x < 0 ||
          neighborPoint.x >= map.dimension().x ||
          neighborPoint.y < 0 ||
          neighborPoint.y >= map.dimension().y) {
        continue; // Skip out-of-bounds neighbors
      }

      if (map.isBlocked(neighborPoint.x, neighborPoint.y) ||
          closedSet.contains(neighborPoint)) {
        continue; // Skip walls and already evaluated nodes
      }

      // Calculate new g score
      final tentativeG =
          current.g + (dir.x.abs() + dir.y.abs() == 2 ? sqrt(2) : 1);

      // If this neighbor is already in the open set with a better g score, skip it
      Node? neighborNode = openSet.firstWhere(
        (node) => node.point == neighborPoint,
        orElse: () => Node(neighborPoint, double.infinity, 0),
      );

      if (tentativeG < neighborNode.g) {
        neighborNode
          ..g = tentativeG
          ..h = _heuristic(neighborPoint, goal)
          ..parent = current;

        if (!openSet.contains(neighborNode)) {
          openSet.add(neighborNode);
        }
      }
    }
  }

  // No path found
  return [];
}

// diagonal distance (Chebyshev heuristic)
double _heuristic(Point a, Point b) {
  final dx = (a.x - b.x).abs();
  final dy = (a.y - b.y).abs();
  return max(dx, dy).toDouble();
}

// Helper function to reconstruct the path from the goal to the start
List<Point<int>> _reconstructPath(Node? current) {
  final path = <Point<int>>[];
  while (current != null) {
    path.add(current.point);
    current = current.parent;
  }
  return path.reversed.toList();
}
