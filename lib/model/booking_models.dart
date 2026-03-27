class OfferItem {
  final String offerId;
  final String offerItemId;
  final String owner;
  final List<dynamic> baggageAllowance;
  final dynamic baseAmount;
  final dynamic taxAmount;
  final dynamic totalAmount;
  final String currency;

  OfferItem({
    required this.offerId,
    required this.offerItemId,
    required this.owner,
    required this.baggageAllowance,
    required this.baseAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
        'offerId': offerId,
        'offerItemId': offerItemId,
        'owner': owner,
        'baggageAllowance': baggageAllowance,
        'baseAmount': baseAmount,
        'taxAmount': taxAmount,
        'totalAmount': totalAmount,
        'currency': currency,
      };

  factory OfferItem.fromOffer(Map<String, dynamic> offer) => OfferItem(
        offerId: offer['offerId'] ?? '',
      offerItemId: offer['offerItemId'] ?? offer['offerId'] ?? '',
        owner: offer['provider'] ?? '',
        baggageAllowance: offer['baggageServices'] ?? [],
        baseAmount: offer['pricing']?['baseFare'],
        taxAmount: offer['pricing']?['taxes'],
        totalAmount: offer['pricing']?['total'],
        currency: offer['pricing']?['currency'] ?? 'USD',
      );
}

class PassengerInfo {
  final String firstName;
  final String lastName;
  final String middleName;
  final String title;
  final String birthDate;
  final String email;
  final String phoneNo;
  final String passport;
  final String paxType;
  final bool notify;
  final String country;
  final String paxId;
  final String gender;

  PassengerInfo({
    required this.firstName,
    required this.lastName,
    this.middleName = '',
    this.title = 'Mr',
    required this.birthDate,
    required this.email,
    required this.phoneNo,
    required this.passport,
    this.paxType = 'ADT',
    this.notify = true,
    this.country = 'ET',
    this.paxId = 'PAX1',
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'middleName': middleName,
        'title': title,
        'birthDate': birthDate,
        'email': email,
        'phoneNo': phoneNo,
        'passPort': passport,
        'paxType': paxType,
        'notify': notify,
        'country': country,
        'paxId': paxId,
        'gender': gender.toUpperCase(),
        'accountNumber': '',
        'depBarcodeImage': '',
        'retBarcodeImage': '',
        'depBarcodeCid': '',
        'retBarcodeCid': '',
      };
}

class TravellerCount {
  final int adt;
  final int chd;
  final int inf;
  final int ins;
  final int unn;

  const TravellerCount({
    this.adt = 1,
    this.chd = 0,
    this.inf = 0,
    this.ins = 0,
    this.unn = 0,
  });

  Map<String, int> toJson() => {
        'adt': adt,
        'chd': chd,
        'inf': inf,
        'ins': ins,
        'unn': unn,
      };
}
