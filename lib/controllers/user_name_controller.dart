import 'package:get/get.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class UserNameController extends GetxController {
  // var emailName = 'ashenafi@gmail.com'.obs;
  var firstNameOf = "".obs;
  var lastNameOf = "".obs;
  var passportFirstName = "".obs;
  var passportLastName = "".obs;
  var passportNumber = "".obs;
  var passportExpiryDate = "".obs;
  var passportIssuingCountry = "".obs;

  var email = "ashenafi@gmail.com".obs;
  var phoneNumber = "".obs;
  var address = "".obs;
  var countryFlage = "".obs;
  var dateOfBirth = "".obs;
  var dateOfBirth2 = "".obs;
  var displayName = "".obs;
  var nationality = "".obs;
  var gender = "".obs;
  void setName(String f, String l) {
    firstNameOf.value = f;
    lastNameOf.value = l;
  }

  void setGender(String g) {
    gender.value = g;
  }

  void setProfileName(String profileName) {
    email.value = profileName;
  }

  void setPassportDetail(String f, String l, String p, String e, String i) {
    passportFirstName.value = f;
    passportLastName.value = l;
    passportNumber.value = p;
    passportExpiryDate.value = e;
    passportIssuingCountry.value = i;
  }

  void setDateOfBirth(String dob) {
    dateOfBirth.value = dob;
  }

  var travelerType = "".obs;

  // --- Multi-traveler support ---
  var extraTravelers = <Map<String, String>>[].obs;

  void setExtraTraveler(int index, String firstName, String lastName,
      String gender, String dob, String dobRaw, String type) {
    while (extraTravelers.length <= index) {
      extraTravelers.add({});
    }
    extraTravelers[index] = {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dob': dob,
      'dobRaw': dobRaw,
      'type': type,
    };
    extraTravelers.refresh();
  }

  Map<String, String> getTraveler(int index) {
    if (index == 0) {
      return {
        'firstName': firstNameOf.value,
        'lastName': lastNameOf.value,
        'gender': gender.value,
        'dob': dateOfBirth.value,
        'dobRaw': dateOfBirth2.value,
        'type': travelerType.value.isEmpty ? 'Adult' : travelerType.value,
      };
    }
    if (index - 1 < extraTravelers.length) return extraTravelers[index - 1];
    return {};
  }
  void setDateOfBirthFromTravel(String day, String month, String year) {
    try {
      int monthInt = int.parse(month);
      int dayInt = int.parse(day);
      int yearInt = int.parse(year);
      DateTime tempDate = DateTime(2024, monthInt);
      String monthName = DateFormat('MMMM').format(tempDate);
      dateOfBirth.value = "$monthName $day, $year";
      DateTime tempDate2 = DateTime(yearInt, monthInt, dayInt);

      dateOfBirth2.value = DateFormat('yyyy-MM-dd').format(tempDate2);
      // print(dateOfBirth2);
      int birthYear = int.parse(year);
      int currentYear = DateTime.now().year;
      int age = currentYear - birthYear;
      if (age >= 12) {
        travelerType.value = "Adult";
      } else {
        travelerType.value = "Child";
      }
    } catch (e) {
      dateOfBirth.value = "$month, $day, $year";
    }
  }

  void setDisplayName(String display) {
    displayName.value = display;
  }

  void setNationality(String nat, String naf) {
    nationality.value = nat;
    countryFlage.value = naf;
  }

  void setEmail(String em) {
    email.value = em;
  }

  var phoneCode = "".obs;
  void setPhoneCode(String pc) {
    phoneCode.value = pc;
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
  }

  void setAddress(String addr) {
    address.value = addr;
  }

  var streetName = "".obs;
  var cityTown = "".obs;
  var zipCode = "".obs;
  var countryeRigion = "".obs;
  void setAddressTownZipCountry(String a, String t, String z, String c) {
    streetName.value = a;
    cityTown.value = t;
    zipCode.value = z;
    countryeRigion.value = c;
  }
}
