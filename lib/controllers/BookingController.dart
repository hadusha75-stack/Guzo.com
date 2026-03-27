import 'package:get/get.dart';

class Bookingcontroller extends GetxController {
  var showActive = true.obs;
  var showPast = false.obs;
  var showCanceled = false.obs;

  void showActiveBooking() {
    showActive.value = true;
    showPast.value = false;
    showCanceled.value = false;
  }

  void showPastBooking() {
    showPast.value = true;
    showActive.value = false;
    showCanceled.value = false;
  }

  void showCanceledBooking() {
    showPast.value = false;
    showActive.value = false;
    showCanceled.value = true;
  }
}
