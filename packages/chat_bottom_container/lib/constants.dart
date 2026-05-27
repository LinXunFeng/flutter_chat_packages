/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-07-28 14:17:01
 */

class ChatBottomContainerPrefKey {
  static const String prefix = 'chat_bottom_container_';

  /// Non-directional keyboard height
  /// (updates in both portrait and landscape orientations)
  static const keyboardHeight = '${prefix}keyboard_height';

  /// Portrait keyboard height
  static const keyboardHeightPortrait = '${prefix}keyboard_height_portrait';

  /// Landscape keyboard height
  static const keyboardHeightLandscape = '${prefix}keyboard_height_landscape';
}
