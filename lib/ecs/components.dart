import 'package:dartemis/dartemis.dart';

class Position extends Component {
  int x, y;

  Position(this.x, this.y);
}

class Renderable extends Component {
  String glyph;

  Renderable(this.glyph);
}

class LeftMover extends Component{}
