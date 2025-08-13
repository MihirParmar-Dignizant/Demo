import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_data/router/app_router.dart';
import 'package:user_data/screen/signup/bloc/signup_bloc.dart';
import 'package:user_data/widget/text_field.dart';

import '../../database/user_model.dart';
import '../../router/router.dart';
import '../../widget/build_button.dart';
// same imports as before

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final occupationController = TextEditingController();

  String? gender;
  String? selectedCity;
  String? selectedState;
  String? selectedCountry;

  final Map<String, Map<String, List<String>>> countryStateCityMap = {
    'India': {
      'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot'],
      'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
      'Punjab': ['Amritsar', 'Ludhiana', 'Jalandhar', 'Patiala'],
      'Karnataka': ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubli'],
    },
    'USA': {
      'California': ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento'],
      'Texas': ['Houston', 'Dallas', 'Austin', 'San Antonio'],
      'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville'],
      'New York': ['New York City', 'Buffalo', 'Rochester', 'Albany'],
    },
    'UK': {
      'England': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
      'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee'],
      'Wales': ['Cardiff', 'Swansea', 'Newport', 'Bangor'],
      'Northern Ireland': ['Belfast', 'Londonderry', 'Lisburn', 'Newry'],
    },
    'Canada': {
      'Ontario': ['Toronto', 'Ottawa', 'Hamilton', 'London'],
      'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau'],
      'Alberta': ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge'],
      'British Columbia': ['Vancouver', 'Victoria', 'Kelowna', 'Abbotsford'],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User registered successfully!")),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.signIn,
              (route) => false, // removes all previous routes
            );
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
          }
        },
        builder: (context, state) {
          final isLoading = state is SignUpLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.app_registration, size: 80),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to UserProfile!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Create account, explore UserProfile.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: "First Name",
                                hint: "Enter your First name",
                                controller: fNameController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                label: "Last Name",
                                hint: "Enter your last name",
                                controller: lNameController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Phone",
                          hint: "Enter phone number",
                          isNumber: true,
                          controller: phoneController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Email",
                          hint: "Enter email address",
                          controller: emailController,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "Gender",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Male',
                                    groupValue: gender,
                                    onChanged:
                                        (val) => setState(() => gender = val),
                                  ),
                                  const Text('Male'),
                                  Radio<String>(
                                    value: 'Female',
                                    groupValue: gender,
                                    onChanged:
                                        (val) => setState(() => gender = val),
                                  ),
                                  const Text('Female'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        CustomTextField(
                          label: "Occupation",
                          hint: "Select Occupation",
                          isDropdown: true,
                          dropdownItems: ['Job', 'Business', 'Other'],
                          controller: occupationController,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: selectedCity,
                          decoration: _dropdownDecoration("City"),
                          items:
                              (selectedCountry != null && selectedState != null)
                                  ? countryStateCityMap[selectedCountry]![selectedState]!
                                      .map(
                                        (city) => DropdownMenuItem(
                                          value: city,
                                          child: Text(city),
                                        ),
                                      )
                                      .toList()
                                  : [],
                          onChanged: (val) {
                            setState(() {
                              selectedCity = val;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedState,
                          decoration: _dropdownDecoration("State"),
                          items:
                              (selectedCountry != null)
                                  ? countryStateCityMap[selectedCountry]!.keys
                                      .map(
                                        (state) => DropdownMenuItem(
                                          value: state,
                                          child: Text(state),
                                        ),
                                      )
                                      .toList()
                                  : [],
                          onChanged: (val) {
                            setState(() {
                              selectedState = val;
                              selectedCity = null;
                            });
                          },
                        ),
                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedCountry,
                          decoration: _dropdownDecoration("Country"),
                          items:
                              countryStateCityMap.keys
                                  .map(
                                    (country) => DropdownMenuItem(
                                      value: country,
                                      child: Text(country),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCountry = val;
                              selectedState = null;
                              selectedCity = null;
                            });
                          },
                        ),

                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Password",
                          hint: "Enter Password",
                          isPassword: true,
                          controller: passwordController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          label: "Confirm Password",
                          hint: "Enter confirm password",
                          isPassword: true,
                          controller: confirmPasswordController,
                        ),
                        const SizedBox(height: 20),
                        buildButton(
                          text: isLoading ? "Signing Up..." : "Sign Up",
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Passwords do not match!")),
                              );
                              return;
                            }else {
                              final user = UserModelData(
                                fName: fNameController.text.trim(),
                                lName: lNameController.text.trim(),
                                phone: phoneController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                gender: gender == 'Male',
                                occupation: occupationController.text.trim(),
                                city: selectedCity ?? '',
                                state: selectedState ?? '',
                                country: selectedCountry ?? '',
                                userPic: '',
                              );

                              context.read<SignUpBloc>().add(
                                SignUpSubmitted(user),
                              );
                            }
                          },

                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
