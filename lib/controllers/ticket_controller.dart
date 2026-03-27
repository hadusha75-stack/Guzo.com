import 'package:get/get.dart';

class TicketController extends GetxController {
  var selectedIndex = 1.obs;
  var price = "CAD 456.13".obs;

  var totalPrice = "CAD 457.12".obs;
  var showPriceDetails = false.obs;

  var showFlexibleExplanation = false.obs;

  void selectTicket(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      price.value = "CAD 403.02";
    } else {
      price.value = "CAD 456.13";
    }
  }

  void toggleFlexibleExplanation() {
    showFlexibleExplanation.value = !showFlexibleExplanation.value;
  }

  void updatePrice(String newPrice) {
    totalPrice.value = newPrice;
  }

  void togglePriceDetails() {
    showPriceDetails.value = !showPriceDetails.value;
  }
}
