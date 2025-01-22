import 'package:internet_connection_checker/internet_connection_checker.dart';

checkConnection() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}

// var isDeviceConnected = false;

// var subscription = Connectivity()
//     .onConnectivityChanged
//     .listen((ConnectivityResult result) async {
//   if (result != ConnectivityResult.none) {
//     isDeviceConnected = await InternetConnectionChecker().hasConnection;
//   }
// });
