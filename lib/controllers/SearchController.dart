import 'package:get/get.dart';

class Searchcontroller extends GetxController {
  var showFlight = true.obs;
  var showAttraction = false.obs;
  var showTaxi = false.obs;

  void showFlights() {
    showFlight.value = true;
    showAttraction.value = false;
    showTaxi.value = false;
  }

  void showAttractions() {
    showAttraction.value = true;
    showFlight.value = false;
    showTaxi.value = false;
  }

  void showTaxis() {
    showAttraction.value = false;
    showFlight.value = false;
    showTaxi.value = true;
  }
}
