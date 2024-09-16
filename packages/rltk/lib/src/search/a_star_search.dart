import 'dart:collection';
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
  // Open set (priority queue) and closed set
  final openSet = PriorityQueue<Node>((a, b) => a.f.compareTo(b.f));
  final closedSet = HashSet<Point>();

  // Start node
  openSet.add(Node(start, 0, _heuristic(start, goal)));

  while (openSet.isNotEmpty) {
    // Get the node with the lowest f value
    final current = openSet.removeFirst();

    // If we've reached the goal, reconstruct the path
    if (current.point == goal) {
      return _reconstructPath(current);
    }

    closedSet.add(current.point);

    // Check neighbors
    for (final neighbor in _getNeighbors(map, current.point)) {
      if (map.isOpaque(neighbor.x, neighbor.y) ||
          map.isBlocked(neighbor.x, neighbor.y) ||
          closedSet.contains(neighbor)) {
        continue; // Skip non-walkable tiles and already visited nodes
      }

      final tentativeG = current.g + 1; // Assume uniform cost (1) to move

      // If this neighbor is already in the open set with a better g score, skip it
      Node? neighborNode = openSet.firstWhere((node) => node.point == neighbor,
          orElse: () => Node(neighbor, double.infinity, 0));

      if (tentativeG < neighborNode.g) {
        neighborNode
          ..g = tentativeG
          ..h = _heuristic(neighbor, goal)
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

// Heuristic function (Manhattan distance)
double _heuristic(Point<int> a, Point<int> b) {
  return ((a.x - b.x).abs() + (a.y - b.y).abs()).toDouble();
}

// Valid neighbors of the current point
List<Point<int>> _getNeighbors(BaseMap map, Point<int> p) {
  final neighbors = <Point<int>>[];
  if (p.x > 0) neighbors.add(Point<int>(p.x - 1, p.y)); // Left
  if (p.x < map.dimension().x - 1)
    neighbors.add(Point<int>(p.x + 1, p.y)); // Right
  if (p.y > 0) neighbors.add(Point<int>(p.x, p.y - 1)); // Up
  if (p.y < (map.dimension().x * map.dimension().y) ~/ map.dimension().x - 1) {
    neighbors.add(Point(p.x, p.y + 1)); // Down
  }
  return neighbors;
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
