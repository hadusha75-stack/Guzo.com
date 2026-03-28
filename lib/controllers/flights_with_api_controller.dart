import 'package:booking/apiServies/booking_api_service.dart';
import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/model/booking_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightUpdaredController extends GetxController {
  final _api = BookingApiService();

  var isLoading = false.obs;
  var offers = <dynamic>[].obs;
  var errorMessage = ''.obs;

  var selectedOffer = Rxn<Map<String, dynamic>>();
  var pricingDetails = Rxn<Map<String, dynamic>>();

  var executionId = ''.obs;
  var offerPriceId = ''.obs;

  var bookingLocator = ''.obs;

  var paymentOptions = <dynamic>[].obs;
  var cardPaymentId = Rxn<dynamic>();

  Map<String, dynamic>? _priceResponseData;

  List<PassengerInfo> _passengers = [];

  void resetBookingState() {
    bookingLocator.value = '';
    cardPaymentId.value = null;
    paymentOptions.value = [];
    executionId.value = '';
    offerPriceId.value = '';
    _priceResponseData = null;
    _passengers = [];
    _api.resetToken();
    debugPrint('Booking state reset');
  }

  Future<void> searchFlights({
    required String originCode,
    required String destinationCode,
    required String departureDate,
    String? returnDate,
    int adults = 1,
    int children = 0,
    int infants = 0,
    String cabinType = 'economy',
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await _api.searchFlights(
        originCode: originCode,
        destinationCode: destinationCode,
        departureDate: departureDate,
        returnDate: returnDate,
        adults: adults,
        children: children,
        infants: infants,
        cabinType: cabinType,
      );

      offers.value = results;
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('SEARCH ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectOfferAndGetPrice(Map<String, dynamic> offer) async {
    try {
      isLoading.value = true;
      selectedOffer.value = offer;

      executionId.value = '';
      offerPriceId.value = '';

      final flightCtrl = Get.find<FlightDataController>();

      final isOneWay = flightCtrl.selectedTripType.value == 'One-way';
      final originDestinations = <Map<String, dynamic>>[
        {
          'departure': {
            'airportCode': flightCtrl.recievedFromFrom.value,
            'date': flightCtrl.selectedDateRaw.value,
          },
          'arrival': {'airportCode': flightCtrl.recievedFromTo.value},
        },
        if (!isOneWay && flightCtrl.selectedDateRaw2.value.isNotEmpty)
          {
            'departure': {
              'airportCode': flightCtrl.recievedFromTo.value,
              'date': flightCtrl.selectedDateRaw2.value,
            },
            'arrival': {'airportCode': flightCtrl.recievedFromFrom.value},
          },
      ];

      debugPrint('TRIP TYPE: ${flightCtrl.selectedTripType.value}');
      debugPrint('ORIGIN DESTINATIONS: $originDestinations');

      final travellers = TravellerCount(
        adt: int.tryParse(flightCtrl.adults.value) ?? 1,
        chd: int.tryParse(flightCtrl.children.value) ?? 0,
      );

      final priceData = await _api.getOfferPrice(
        offer: offer,
        originDestinations: originDestinations,
        travellers: travellers,
      );

      debugPrint('PRICE DATA: $priceData');

      _priceResponseData = priceData;

      executionId.value = (priceData['executionId'] ?? '').toString();
      offerPriceId.value =
          (priceData['id'] ??
                  priceData['executionId'] ??
                  offer['offerId'] ??
                  '')
              .toString();

      if (executionId.value.isEmpty) {
        throw Exception(
          'offer-price returned no executionId. Full data: $priceData',
        );
      }

      pricingDetails.value = priceData['pricing'] as Map<String, dynamic>?;

      final total =
          double.tryParse(offer['pricing']?['total']?.toString() ?? '0') ?? 0.0;
      if (total > 0) {
        Get.find<FlightDataController>().setTotalPriceFromApi(total);
      }

      debugPrint('executionId set to: ${executionId.value}');
      debugPrint('offerPriceId set to: ${offerPriceId.value}');
    } catch (e) {
      debugPrint('PRICE ERROR: $e');
      Get.snackbar(
        'Error',
        'Failed to get price: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> holdFlight(List<Map<String, dynamic>> customerInfosJson) async {
    if (selectedOffer.value == null) {
      Get.snackbar(
        'Error',
        'No flight selected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (executionId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pricing not loaded. Please go back and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Reset payment state so we never reuse a stale bookingLocator or cardPaymentId
    bookingLocator.value = '';
    cardPaymentId.value = null;
    paymentOptions.value = [];

    try {
      isLoading.value = true;

      final userCtrl = Get.find<UserNameController>();
      _passengers = [
        PassengerInfo(
          firstName: customerInfosJson.isNotEmpty
              ? customerInfosJson[0]['firstName'] ?? userCtrl.firstNameOf.value
              : userCtrl.firstNameOf.value,
          lastName: customerInfosJson.isNotEmpty
              ? customerInfosJson[0]['lastName'] ?? userCtrl.lastNameOf.value
              : userCtrl.lastNameOf.value,
          birthDate: customerInfosJson.isNotEmpty
              ? customerInfosJson[0]['birthDate'] ?? userCtrl.dateOfBirth2.value
              : userCtrl.dateOfBirth2.value,
          email: userCtrl.email.value,
          phoneNo:
              '${userCtrl.phoneCode.value}${userCtrl.phoneNumber.value}'.isEmpty
              ? '+251912345678'
              : '${userCtrl.phoneCode.value}${userCtrl.phoneNumber.value}',
          passport: userCtrl.passportNumber.value.isEmpty
              ? 'A12345678'
              : userCtrl.passportNumber.value,
          gender: userCtrl.gender.value.isEmpty
              ? 'MALE'
              : userCtrl.gender.value,
          country: 'ET',
          paxId: 'PAX1',
        ),
      ];

      final flightCtrl = Get.find<FlightDataController>();
      final travellers = TravellerCount(
        adt: int.tryParse(flightCtrl.adults.value) ?? 1,
        chd: int.tryParse(flightCtrl.children.value) ?? 0,
      );

      final response = await _api.holdFlight(
        executionId: executionId.value,
        offerPriceId: offerPriceId.value,
        verifyFareId:
            _priceResponseData?['id']?.toString() ?? offerPriceId.value,
        offer: selectedOffer.value!,
        passengers: _passengers,
        travellers: travellers,
      );

      debugPrint('HOLD RESPONSE: $response');

      final locator = response['data']?['id']?.toString() ?? '';
      if (locator.isNotEmpty) {
        bookingLocator.value = locator;
      }

      final success = response['success'] == true || locator.isNotEmpty;
      if (!success) {
        Get.snackbar(
          'Hold Failed',
          response['message']?.toString() ?? 'Unknown error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
        return;
      }

      await _fetchPaymentOptions(travellers);
    } catch (e) {
      debugPrint('HOLD ERROR: $e');
      Get.snackbar(
        'Error',
        'Hold failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchPaymentOptions(TravellerCount travellers) async {
    try {
      final fareId =
          _priceResponseData?['id']?.toString() ?? offerPriceId.value;
      final response = await _api.getPaymentOptions(
        executionId: executionId.value,
        fareId: fareId,
        verifyFareId: fareId,
        offer: selectedOffer.value!,
        passengers: _passengers,
        travellers: travellers,
      );

      debugPrint('PAYMENT OPTIONS RESPONSE: $response');

      final locator = response['data']?['id']?.toString() ?? '';
      if (locator.isNotEmpty) bookingLocator.value = locator;

      final cards = response['data']?['paymentOptions']?['cards'];
      if (cards is List && cards.isNotEmpty) {
        paymentOptions.value = cards;
        cardPaymentId.value = cards[0]['id'];
        debugPrint('Card payment ID: ${cardPaymentId.value}');
      } else {
        debugPrint(
          'PAYMENT OPTIONS: no cards returned. Full response: $response',
        );
        Get.snackbar(
          'Payment Error',
          'No card payment options available. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('PAYMENT OPTIONS ERROR: $e');
      Get.snackbar(
        'Payment Error',
        'Failed to load payment options: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  Future<Map<String, dynamic>?> getPaymentOptions(
    List<Map<String, dynamic>> ignored,
  ) async {
    if (cardPaymentId.value != null) {
      return {
        'data': {
          'id': bookingLocator.value,
          'paymentOptions': {'cards': paymentOptions},
        },
      };
    }
    return null;
  }

  Future<void> confirmBooking({
    required String paymentId,
    required Map<String, String> cardInfo,
  }) async {
    if (bookingLocator.value.isEmpty) {
      Get.snackbar(
        'Error',
        'No booking locator found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _api.confirmBooking(
        bookingLocator: bookingLocator.value,
        paymentOptionId: paymentId,
        cardInfo: cardInfo,
        offerPriceId: '',
        verifyFareId: '',
        passengers: [],
      );
      debugPrint('CONFIRM FULL RESPONSE: $response');
      debugPrint('  bookingLocator sent: ${bookingLocator.value}');
      debugPrint('  paymentId sent: $paymentId');
      debugPrint('  cardInfo sent: $cardInfo');

      final success = response['success'] == true;
      if (!success) {
        final message = response['message']?.toString() ?? 'Unknown error';
        debugPrint('CONFIRM FAILED — message: $message');
        Get.snackbar(
          'Booking Failed',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 6),
        );
        return;
      } else {
        debugPrint('CONFIRMATION SUCCESS: $response');
        Get.snackbar(
          'Booking Confirmed',
          'Your flight has been booked successfully!',
          backgroundColor: const Color(0xFF0B5D39),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.until((route) => route.isFirst);
      }
      debugPrint('CONFIRM RESPONSE: $response');
    } catch (e) {
      debugPrint('CONFIRM ERROR: $e');
      Get.snackbar(
        'Error',
        'Failed to confirm booking: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
