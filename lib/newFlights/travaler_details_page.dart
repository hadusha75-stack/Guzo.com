import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TravelerDetailsPage extends StatefulWidget {
  final int travelerNumber;
  final String? initialFirstName;
  final String? initialLastName;
  final String? initialGender;
  final DateTime? initialDateOfBirth;
  final String? initialNationality;

  const TravelerDetailsPage({
    super.key,
    required this.travelerNumber,
    this.initialFirstName,
    this.initialLastName,
    this.initialGender,
    this.initialDateOfBirth,
    this.initialNationality,
  });

  @override
  State<TravelerDetailsPage> createState() => _TravelerDetailsPageState();
}

class _TravelerDetailsPageState extends State<TravelerDetailsPage> {
  final userNameController = Get.find<UserNameController>();
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDateOfBirth;

  @override
  void initState() {
    super.initState();
    _selectedDateOfBirth = widget.initialDateOfBirth;
    if (_selectedDateOfBirth != null) {
      _dateController.text = _selectedDateOfBirth!.day.toString().padLeft(
        2,
        '0',
      );
      _monthController.text = _selectedDateOfBirth!.month.toString().padLeft(
        2,
        '0',
      );
      _yearController.text = _selectedDateOfBirth!.year.toString();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalityController.dispose();
    _genderController.dispose();
    _dateController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  String _getAgeGroup() {
    if (_selectedDateOfBirth == null) return 'Adult';
    final age = DateTime.now().difference(_selectedDateOfBirth!).inDays ~/ 365;
    if (age < 2) return 'Infant';
    if (age < 12) return 'Child';
    return 'Adult';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: GuzoTheme.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Traveler details',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.redAccent.shade100),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Double-check your details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Make sure your details match your passport or ID. Some airlines don't allow changes after booking.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.person, size: 50, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Traveler ${widget.travelerNumber + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getAgeGroup(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "First names *",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Add first name(s) to continue' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Last names *",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Add last name(s) to continue' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Gender specified on your passport/ID *",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          String localSelectedGender =
                              _selectedGender ?? "Male";

                          return StatefulBuilder(
                            builder:
                                (
                                  BuildContext context,
                                  StateSetter setModalState,
                                ) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 320,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 6,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        InkWell(
                                          onTap: () => setModalState(
                                            () => localSelectedGender = "Male",
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Male",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Transform.scale(
                                                  scale: 1.5,
                                                  child: Radio<String>(
                                                    value: "Male",
                                                    groupValue:
                                                        localSelectedGender,
                                                    activeColor:
                                                        GuzoTheme.primaryGreen,
                                                    onChanged: (value) {
                                                      setModalState(
                                                        () =>
                                                            localSelectedGender =
                                                                value!,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => setModalState(
                                            () =>
                                                localSelectedGender = "Female",
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Female",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Transform.scale(
                                                  scale: 1.5,
                                                  child: Radio<String>(
                                                    value: "Female",
                                                    groupValue:
                                                        localSelectedGender,
                                                    activeColor:
                                                        GuzoTheme.primaryGreen,
                                                    onChanged: (value) {
                                                      setModalState(
                                                        () =>
                                                            localSelectedGender =
                                                                value!,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Divider(height: 1),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 55,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedGender =
                                                    localSelectedGender;
                                                _genderController.text =
                                                    localSelectedGender;
                                              });
                                              
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  GuzoTheme.primaryGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              "Done",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          );
                        },
                      );
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _genderController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 30,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Selection required' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Date of birth *",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _monthController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: InputDecoration(
                            hintText: "MM",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Required';
                            }

                            final month = int.tryParse(v);
                            if (month == null) {
                              return 'Enter a \nvalid number';
                            }

                            if (month < 1 || month > 12) {
                              return 'Month must be \bbetween 1 \nand 12';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: InputDecoration(
                            hintText: "DD",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Required';
                            }
                            final day = int.tryParse(v);
                            if (day == null) {
                              return 'Enter a \nvalid number';
                            }
                            if (day < 1 || day > 31) {
                              return 'Day must be \nbetween 1 \nand 31';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            hintText: "YYYY",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Required';
                            }
                            final year = int.tryParse(v);
                            if (year == null) {
                              return 'Enter a \nvalid number';
                            }
                            if (year < 1900 || year > 2025) {
                              return 'Enter a \nvalid year';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userNameController.setName(
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                      );
                      userNameController.setDateOfBirthFromTravel(
                        _dateController.text,
                        _monthController.text,
                        _yearController.text,
                      );
                      userNameController.setGender(_genderController.text);
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuzoTheme.primaryGreen,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
