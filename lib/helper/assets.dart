import 'package:path/path.dart' as Path;

class Assets {
  static final String _asset = 'assets/audio/';

  static String getPath(String fileName) {
    return Path.join(_asset, fileName);
  }
}