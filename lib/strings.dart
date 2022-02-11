// TODO(robinlinden): Look into https://pub.dev/packages/intl for translation support.
// https://docs.flutter.dev/get-started/flutter-for/android-devs#where-do-i-store-strings-how-do-i-handle-localization
class Strings {
  // Shared.
  static const String defaultContactName = 'Unknown';
  static const String title = 'bTox (working title)';
  static const String addContact = 'Add contact';

  // Chat page.
  static const String message = 'Message';

  // Add contact page.
  static const String toxId = 'Tox ID';
  static const String defaultAddContactMessage = 'bTox!';
  static const String add = 'Add';
  static const String toxIdLengthError = 'The Tox ID must be 76 characters';
  static const String messageEmptyError = "The message can't be empty";

  // Drawer menu.
  static const String menuProfile = 'Profile';
  static const String menuQuit = 'Quit';
  static const String menuSettings = 'Settings';

  // Profile page.
  static const String nickLengthError =
      'Nickname must be between 1 and 32 characters';
  static const String statusMessageLengthError =
      'Status message may not exceed 256 characters';
  static const String profileTextFieldNick = 'Nickname';
  static const String profileTextFieldUserStatusMessage = 'Status message';
}
