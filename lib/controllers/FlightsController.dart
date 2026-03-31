// ignore_for_file: file_names

import 'package:get/get.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class FlightSegment {
  var from = "Where From?".obs;
  var fromName = "where From?".obs;
  var toName = "where to".obs;
  var to = "Where to?".obs;
  var date = "When?".obs;
}

class FlightDataController extends GetxController {
  var totalPrice = ''.obs;
  RxDouble totalPriceFromApi = 0.0.obs;

  void setTotalPriceFromApi(double price) {
    totalPriceFromApi.value = price;
    totalPrice.value = totalPriceFromApi.toStringAsFixed(2);
  }

  var selectedForPassingTonextPage = "".obs;
  void setPrice3() {
    selectedForPassingTonextPage.value = "selected";
  }
  
  var selectedForPassingTonextPage1 = "".obs;
  void setPrice31() {
    selectedForPassingTonextPage.value = "selected";
  }

  var totalPricecover = ''.obs;

  void setPrice(double price) {
    totalPrice.value = (totalPriceFromApi.value + price).toStringAsFixed(2);
    totalPricecover.value = totalPrice.value;
  
  }

  void setPrice2(double price) {
    double current = double.tryParse(totalPricecover.value) ?? 0.0;
    double result = current + price;
    totalPrice.value = result.toStringAsFixed(2);
    totalPrice.value = result.toStringAsFixed(2);
  }

  RxInt numberOfselectedSeats = 0.obs;
  void setSeatNumber(int a) {
    numberOfselectedSeats.value = a;
  }

  var numberOfselectedSeats2 = 0.obs;
  void setSeatNumber2(int a) {
    numberOfselectedSeats2.value = a;
  }

  var count = 2.obs;

  var isLoading = true.obs;
  var flightList = <String>[].obs;

  var whereFrom = "Where From?".obs;
  var whereTo = "Where to?".obs;
  var selectedDate = 'When?'.obs;

  var multiCitySegments = <FlightSegment>[FlightSegment(), FlightSegment()].obs;

  var passengerSummary = '1 adult, Economy'.obs;
  var adults = "1".obs;
  var children = "0".obs;
  var cabinClass = "Economy".obs;
  var childAges = <int>[].obs;
  var selectedTripType = 'Round-trip'.obs;
  var directFlightsOnly = false.obs;
  var sortSelected = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    fetchFlights();
    super.onInit();
  }

  void addSegment() {
    if (multiCitySegments.length < 5) {
      multiCitySegments.add(FlightSegment());
    }
  }

  void removeSegment(int index) {
    if (multiCitySegments.length > 2) {
      multiCitySegments.removeAt(index);
    }
  }

  var recievedFromFromName = "".obs;
  var recievedFromToName = "".obs;
  var recievedFromFrom = "Where from?".obs;
  var recievedFromTo = "Where to?".obs;

  void updateSegmentLocation(
    int index,
    String code,
    String cityName,
    bool isFrom,
  ) {
    if (selectedTripType.value == "Multi-city") {
      if (isFrom) {
        multiCitySegments[index].from.value = code;
        multiCitySegments[index].fromName.value = cityName;
      } else {
        multiCitySegments[index].to.value = code;
        multiCitySegments[index].toName.value = cityName;
      }
    } else {
      if (isFrom) {
        recievedFromFrom.value = code;
        recievedFromFromName.value = cityName;
      } else {
        recievedFromTo.value = code;
        recievedFromToName.value = cityName;
      }
    }
  }

  var selectedSeats = <int, String>{}.obs;

  int get totalPassengers =>
      (int.tryParse(adults.value) ?? 1) + (int.tryParse(children.value) ?? 0);

  void selectSeat(int passengerIndex, String seatId) {
    selectedSeats.removeWhere((key, value) => value == seatId);
    selectedSeats[passengerIndex] = seatId;
  }

  void updateSegmentDate(int index, String date) {
    multiCitySegments[index].date.value = date;
  }

  void fetchFlights() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 2));
      flightList.value = [
        "Flight AA-102 • 08:30 AM",
        "Flight EK-505 • 11:45 AM",
        "Flight QR-091 • 02:20 PM",
        "Flight AA-102 • 08:30 AM",
        "Flight EK-505 • 11:45 AM",
        "Flight QR-091 • 02:20 PM",
        "Flight AA-102 • 08:30 AM",
        "Flight EK-505 • 11:45 AM",
        "Flight QR-091 • 02:20 PM",
        "Flight AA-102 • 08:30 AM",
        "Flight EK-505 • 11:45 AM",
        "Flight QR-091 • 02:20 PM",
      ];
    } finally {
      isLoading(false);
    }
  }

  void setLocationFrom(String f) => whereFrom.value = f;
  void setLocationWhere(String t) => whereTo.value = t;
  var selectedDateOneWay = "When?".obs;
  var selectedDateRaw = "When?".obs;
  var selectedDateRaw2 = "".obs;
  var selectedDateRoundTripStart = "".obs;
  var selectedDateRoundTripend = "".obs;

  void updateDate(DateTime picked) {
    selectedDateOneWay.value = DateFormat('EEE, MMM d').format(picked);

    selectedDateRaw.value = DateFormat('yyyy-MM-dd').format(picked);
  }

  void updateDateRange(DateTime start, DateTime end) {
    selectedDateRaw.value = DateFormat('yyyy-MM-dd').format(start);
    selectedDateRaw2.value = DateFormat('yyyy-MM-dd').format(end);
    selectedDateRoundTripStart.value = DateFormat('EEE, MMM d').format(start);
    selectedDateRoundTripend.value = DateFormat('EEE, MMM d').format(end);

    String formatted =
        "${start.day}/${start.month} - ${end.day}/${end.month}/${end.year}";
    selectedDate.value = formatted;
  }

  // var travesler = "4".obs;
  var numberOfTravelers = 1.obs;
  void setAdults(String a, String c, String ccs, List<int> ages) {
    adults.value = a;
    children.value = c;
    cabinClass.value = ccs;
    childAges.assignAll(ages);

    int total = (int.tryParse(a) ?? 1) + (int.tryParse(c) ?? 0);
    String travelerText = total > 1 ? "$total travelers" : "1 adult";
    passengerSummary.value = "$travelerText, $ccs";
    numberOfTravelers.value = total;
    // travesler.value = total.toString();
  }

  void toggleTripType(String type) => selectedTripType.value = type;
  void toggleDirectFlights(bool val) => directFlightsOnly.value = val;
  void toggleSort() => sortSelected.value = !sortSelected.value;
  void updateIndex(int index) => selectedIndex.value = index;
}
