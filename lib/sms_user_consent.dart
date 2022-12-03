import 'package:flutter/services.dart';

/// SmsUserConsent implements Android's
/// [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/overview#user_flow_for_sms_user_consent_api).
///
/// This plugin can be used to retrieve user's phone number and request user
/// consent to read a single SMS verification message.
class SmsUserConsent {
  static const MethodChannel _channel = const MethodChannel('sms_user_consent');
  Function? _phoneNumberListener;
  String? _selectedPhoneNumber;

  /// Last selected phone number
  String? get selectedPhoneNumber => _selectedPhoneNumber;

  /// SmsUserConsent plugin works only on Android, hence make sure to check the
  /// platform is Android.
  ///
  /// Optional phone number listener, called when user selects a
  /// phone number (returns null if user selects none of the above or
  /// taps out of the phone number selection dialog).
  ///
  /// Optional sms listener, called when sms is retrieved if it meets these criteria:
  /// - The message contains a 4-10 character alphanumeric string with at least one number.
  /// - The message was sent by a phone number that's not in the user's contacts.
  /// - If you specified the sender's phone number, the message was sent by that number.
  SmsUserConsent({Function? phoneNumberListener}) {
    _phoneNumberListener = phoneNumberListener;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'selectedPhoneNumber':
          _selectedPhoneNumber = call.arguments;
          _phoneNumberListener!();
          break;
        default:
      }
    });
  }

  /// Clears last phone number, sms and their respective listeners.
  void dispose() {
    _selectedPhoneNumber = null;
    _phoneNumberListener = null;
  }

  /// Updates Phone number listener
  void updatePhoneNumberListener(Function listener) =>
      _phoneNumberListener = listener;

  /// Optional (not required for receiving sms): Get user's phone number.
  ///
  /// In case of multiple sim, a dialog is displayed.
  void requestPhoneNumber() async =>
      await _channel.invokeMethod('requestPhoneNumber');
}
