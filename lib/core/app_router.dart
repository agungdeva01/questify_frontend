import 'package:flutter/material.dart';

/// Kunci navigator global yang memungkinkan 401 Interceptor
/// melakukan redirect ke halaman Login tanpa memerlukan BuildContext.
///
/// Daftarkan ke MaterialApp.navigatorKey agar Dio bisa mengakses
/// state navigator di luar widget tree.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
