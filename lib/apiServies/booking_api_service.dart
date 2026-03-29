import 'dart:convert';
import 'package:booking/model/booking_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingApiService {
  static const String _base = 'http://3.11.26.231/fannos';
  String? _token;

  void resetToken() {
    _token = null;
  }
Future<String> _getToken() async {
    if (_token != null) return _token!;
    final res = await http.post(
      Uri.parse('$_base/api/auth/guest-token'),
      headers: {'Content-Type': 'application/json'},
      body: '{}',
    );
    _assertOk(res, 'guest-token');
    final data = jsonDecode(res.body);
    _token = data['guestToken'] as String;
    return _token!;
  }

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
String? _shoppingExecutionId;

 Future<List<dynamic>> searchFlights({
    required String originCode,
    required String destinationCode,
    required String departureDate,
    String? returnDate,
    int adults = 1,
    int children = 0,
    int infants = 0,
    String cabinType = 'economy',
  }) async {
    final token = await _getToken();

    final originDestinations = <Map<String, dynamic>>[
      {
        'departure': {'airportCode': originCode, 'date': departureDate},
        'arrival': {'airportCode': destinationCode},
      },
      if (returnDate != null)
        {
          'departure': {'airportCode': destinationCode, 'date': returnDate},
          'arrival': {'airportCode': originCode},
        },
    ];

    final body = jsonEncode({
      'originDestinations': originDestinations,
      'travellers': {'adt': adults, 'chd': children, 'inf': infants},
      'preference': {
        'cabinPreferences': {
          'cabinType': {'code': cabinType},
        },
      },
    });

    final res = await http.post(
      Uri.parse('$_base/api/flight/shopping'),
      headers: _headers(token),
      body: body,
    );
    _assertOk(res, 'flight/shopping');

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final qrFlights = json['data']?['qrFlights'] as Map<String, dynamic>?;

   _shoppingExecutionId = qrFlights?['executionId']?.toString();
    debugPrint('SHOPPING qrFlights keys: ${qrFlights?.keys.toList()}');
    debugPrint('SHOPPING executionId from response: $_shoppingExecutionId');

    final offers = qrFlights?['offers'] as List? ?? [];
    if (offers.isNotEmpty) {
      debugPrint('FIRST OFFER KEYS: ${(offers.first as Map).keys.toList()}');
    }
    return offers;
  }

Future<Map<String, dynamic>> getOfferPrice({
    required Map<String, dynamic> offer,
    required List<Map<String, dynamic>> originDestinations,
    required TravellerCount travellers,
  }) async {
    final token = await _getToken();
    final item = OfferItem.fromOffer(offer);
    List<String>? itineraryIdList;
    if (offer['provider'] == 'CP') {
      itineraryIdList = (offer['flights'] as List)
          .map((f) => f['productId'] as String)
          .toList();
    }

    final execId = _shoppingExecutionId ?? offer['offerId'];

   final bodyMap = <String, dynamic>{
      'executionId': execId,
      'fareId': offer['offerId'],
      'provider': offer['provider'],
      'metadata': {
        'country': 'ET',
        'currency': 'USD',
        'locale': 'en-US',
        'user': 'guest@fannos.com',
        'traceId': null,
      },
      'offerItems': [item.toJson()],
      'travellers': travellers.toJson(),
      'originDestinations': originDestinations,
    };

    if (itineraryIdList != null) {
      bodyMap['itineraryIdList'] = itineraryIdList;
    }

    final bodyStr = jsonEncode(bodyMap);
    debugPrint('OFFER-PRICE REQUEST BODY: $bodyStr');

    final res = await http.post(
      Uri.parse('$_base/api/flight/offer-price'),
      headers: _headers(token),
      body: bodyStr,
    );

    debugPrint('OFFER-PRICE RAW RESPONSE [${res.statusCode}]: ${res.body}');

    final json = jsonDecode(res.body) as Map<String, dynamic>;
if (res.statusCode != 200) {
      throw Exception(
          '[offer-price] HTTP ${res.statusCode}: ${json['message'] ?? res.body}');
    }
    if (json['success'] == false) {
      throw Exception(
          '[offer-price] API error: ${json['message'] ?? 'Unknown error'}');
    }

    final data = json['data'];
    if (data == null) {
      throw Exception('[offer-price] Response has no data field: ${res.body}');
    }

    return data as Map<String, dynamic>;
  }
 Future<Map<String, dynamic>> holdFlight({
    required String executionId,
    required String offerPriceId,
    required String verifyFareId,  
    required Map<String, dynamic> offer,
    required List<PassengerInfo> passengers,
    required TravellerCount travellers,
  }) async {
    final token = await _getToken();
    final item = OfferItem.fromOffer(offer);

    List<String>? itineraryIdList;
    if (offer['provider'] == 'CP') {
      itineraryIdList = (offer['flights'] as List)
          .map((f) => f['productId'] as String)
          .toList();
    }

    final bodyMap = <String, dynamic>{
      'bookingHold': true,
      'executionId': executionId,
      'offerPriceId': executionId, // API expects executionId here (Postman step 4)
      'provider': offer['provider'],
      'offerItems': [item.toJson()],
      'customerInfos': passengers.map((p) => p.toJson()).toList(),
      'travellers': travellers.toJson(),
      'verifyRequest': {
        'fareId': verifyFareId,      
        if (itineraryIdList != null) 'itineraryIdList': itineraryIdList,
      },
    };

    final bodyStr = jsonEncode(bodyMap);
    debugPrint('HOLD REQUEST BODY: $bodyStr');

    final res = await http.post(
      Uri.parse('$_base/api/flight/hold'),
      headers: _headers(token),
      body: bodyStr,
    );

    debugPrint('HOLD RAW RESPONSE [${res.statusCode}]: ${res.body}');

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw Exception('[hold] HTTP ${res.statusCode}: ${json['message'] ?? res.body}');
    }
    return json;
  }

  Future<Map<String, dynamic>> getPaymentOptions({
    required String executionId,
    required String fareId,       // offer-price response data.id
    required String verifyFareId,
    required Map<String, dynamic> offer,
    required List<PassengerInfo> passengers,
    required TravellerCount travellers,
  }) async {
    final token = await _getToken();
    final item = OfferItem.fromOffer(offer);

    List<String>? itineraryIdList;
    if (offer['provider'] == 'CP') {
      itineraryIdList = (offer['flights'] as List)
          .map((f) => f['productId'] as String)
          .toList();
    }

    final bodyMap = <String, dynamic>{
      'bookingHold': true,
      'executionId': executionId,
      'offerPriceId': fareId,      // API expects fareId (data.id from offer-price) here
      'provider': offer['provider'],
      'offerItems': [item.toJson()],
      'customerInfos': passengers.map((p) => p.toJson()).toList(),
      'travellers': travellers.toJson(),
      'verifyRequest': {
        'fareId': verifyFareId,
        if (itineraryIdList != null) 'itineraryIdList': itineraryIdList,
      },
    };

    final bodyStr = jsonEncode(bodyMap);
    debugPrint('PAYMENT-OPTIONS REQUEST BODY: $bodyStr');

    final res = await http.post(
      Uri.parse('$_base/api/flight/hold/get-payment-options'),
      headers: _headers(token),
      body: bodyStr,
    );

    debugPrint('PAYMENT-OPTIONS RAW RESPONSE [${res.statusCode}]: ${res.body}');

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw Exception('[payment-options] HTTP ${res.statusCode}: ${json['message'] ?? res.body}');
    }
    return json;
  }
  Future<Map<String, dynamic>> confirmBooking({
    required String bookingLocator,
    required dynamic paymentOptionId,
    required Map<String, String> cardInfo, required String offerPriceId, required String verifyFareId, required List<PassengerInfo> passengers, Map<String, dynamic>? pricing,
  }) async {
    final token = await _getToken();

    // Parse to int if possible so JSON encodes as number, not string (API expects raw number)
    final dynamic payOptionId = int.tryParse(paymentOptionId.toString()) ?? paymentOptionId;
    final body = jsonEncode({
      'bookingLocator': bookingLocator,
      'payOption': {'id': payOptionId},
      'isCardMethod': true,
      'cardInfo': cardInfo,
    });

    final res = await http.post(
      Uri.parse('$_base/api/flight/hold/confirmpayment'),
      headers: _headers(token),
      body: body,
    );
    _assertOk(res, 'flight/hold/confirmpayment');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
  Future<Map<String, dynamic>> paymentCallback({
    required String status,
    required String traceNumber,
    required String txnref,
  }) async {
    final token = await _getToken();
    final body = jsonEncode({
      'status': status,
      'traceNumber': traceNumber,
      'txnref': txnref,
    });
    debugPrint('PAYMENT-CALLBACK REQUEST: $body');
    final res = await http.post(
      Uri.parse('$_base/api/flight/hold/payment-callback'),
      headers: _headers(token),
      body: body,
    );
    debugPrint('PAYMENT-CALLBACK RESPONSE [${res.statusCode}]: ${res.body}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  void _assertOk(http.Response res, String endpoint) {
    if (res.statusCode != 200) {
      throw Exception('[$endpoint] HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
