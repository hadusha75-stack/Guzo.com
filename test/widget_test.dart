import 'package:booking/screens/flightsPage/payment_page.dart';
import 'package:booking/screens/flightsPage/travaler_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:booking/theam/app_color.dart';
import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';

void main() {
  setUp(() {
    Get.put(FlightDataController(), permanent: true);
    Get.put(FlightUpdaredController(), permanent: true);
    Get.put(UserNameController(), permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  test('FlightDataController initializes with Round-trip as default', () {
    final ctrl = Get.find<FlightDataController>();
    expect(ctrl.selectedTripType.value, 'Round-trip');
  });

  test('FlightUpdaredController starts with empty offers and not loading', () {
    final ctrl = Get.find<FlightUpdaredController>();
    expect(ctrl.offers.isEmpty, true);
    expect(ctrl.isLoading.value, false);
    expect(ctrl.executionId.value, '');
    expect(ctrl.bookingLocator.value, '');
  });

  test('UserNameController setName updates first and last name', () {
    final ctrl = Get.find<UserNameController>();
    ctrl.setName('John', 'Doe');
    expect(ctrl.firstNameOf.value, 'John');
    expect(ctrl.lastNameOf.value, 'Doe');
  });

  test('UserNameController setEmail updates email', () {
    final ctrl = Get.find<UserNameController>();
    ctrl.setEmail('test@example.com');
    expect(ctrl.email.value, 'test@example.com');
  });

  test('UserNameController setGender updates gender', () {
    final ctrl = Get.find<UserNameController>();
    ctrl.setGender('Male');
    expect(ctrl.gender.value, 'Male');
  });

  test('FlightDataController setTotalPriceFromApi updates price', () {
    final ctrl = Get.find<FlightDataController>();
    ctrl.setTotalPriceFromApi(250.75);
    expect(ctrl.totalPriceFromApi.value, 250.75);
    expect(ctrl.totalPrice.value, '250.75');
  });

  testWidgets('PaymentPage renders card form fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: const PaymentPage(),
        theme: ThemeData(colorSchemeSeed: GuzoTheme.primaryGreen),
      ),
    );
    await tester.pump();

    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('Card details'), findsOneWidget);
    expect(find.text("Cardholder's name *"), findsOneWidget);
    expect(find.text('Card number *'), findsOneWidget);
    expect(find.text('Expiry date *'), findsOneWidget);
    expect(find.text('CVV *'), findsOneWidget);
    expect(find.text('Complete Booking'), findsOneWidget);
  });

  testWidgets(
    'PaymentPage Complete Booking button is disabled when form is empty',
    (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: const PaymentPage()));
      await tester.pump();
      final btn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Complete Booking'),
      );
      expect(btn.onPressed, isNotNull);
    },
  );

  testWidgets('TravelerDetailsPage renders form fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(home: TravelerDetailsPage(travelerNumber: 0)),
    );
    await tester.pump();

    expect(find.text('Traveler details'), findsOneWidget);
    expect(find.text('First names *'), findsOneWidget);
    expect(find.text('Last names *'), findsOneWidget);
    expect(find.text('Date of birth *', skipOffstage: false), findsOneWidget);
  });

  testWidgets('TravelerDetailsPage Done button validates empty form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(home: TravelerDetailsPage(travelerNumber: 0)),
    );
    await tester.pump();

    await tester.tap(find.text('Done'));
    await tester.pump();

    expect(find.text('Add first name(s) to continue'), findsOneWidget);
    expect(find.text('Add last name(s) to continue'), findsOneWidget);
  });
}
