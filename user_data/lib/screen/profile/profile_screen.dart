import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_data/database/user_model.dart';
import '../../widget/text_field.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  const ProfileScreen({super.key, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fNameController;
  late TextEditingController _lNameController;
  late TextEditingController _phoneController;
  late TextEditingController _occupationController;

  String? _country, _state, _city;
  String? _profilePic;

  final Map<String, Map<String, List<String>>> countryStateCityMap = {
    'India': {
      'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Gandhinagar'],
      'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'],
      'Punjab': ['Amritsar', 'Ludhiana', 'Jalandhar', 'Patiala', 'Mohali'],
      'Karnataka': ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubli', 'Belagavi'],
      'Tamil Nadu': [
        'Chennai',
        'Coimbatore',
        'Madurai',
        'Tiruchirappalli',
        'Salem',
      ],
    },
    'USA': {
      'California': [
        'Los Angeles',
        'San Francisco',
        'San Diego',
        'Sacramento',
        'San Jose',
      ],
      'Texas': ['Houston', 'Dallas', 'Austin', 'San Antonio', 'Fort Worth'],
      'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville', 'Tallahassee'],
      'New York': [
        'New York City',
        'Buffalo',
        'Rochester',
        'Albany',
        'Syracuse',
      ],
    },
    'UK': {
      'England': ['London', 'Manchester', 'Birmingham', 'Liverpool', 'Bristol'],
      'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee', 'Stirling'],
      'Wales': ['Cardiff', 'Swansea', 'Newport', 'Bangor', 'Wrexham'],
      'Northern Ireland': [
        'Belfast',
        'Londonderry',
        'Lisburn',
        'Newry',
        'Armagh',
      ],
    },
    'Canada': {
      'Ontario': ['Toronto', 'Ottawa', 'Hamilton', 'London', 'Windsor'],
      'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau', 'Sherbrooke'],
      'Alberta': [
        'Calgary',
        'Edmonton',
        'Red Deer',
        'Lethbridge',
        'Medicine Hat',
      ],
      'British Columbia': [
        'Vancouver',
        'Victoria',
        'Kelowna',
        'Abbotsford',
        'Kamloops',
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _fNameController = TextEditingController();
    _lNameController = TextEditingController();
    _phoneController = TextEditingController();
    _occupationController = TextEditingController();

    BlocProvider.of<ProfileBloc>(context).add(LoadUserProfile(widget.email));
  }

  void _initializeFields(UserModelData user) {
    _fNameController.text = user.fName;
    _lNameController.text = user.lName;
    _phoneController.text = user.phone;
    _occupationController.text = user.occupation;

    _country = user.country.isNotEmpty ? user.country : null;
    _state = user.state.isNotEmpty ? user.state : null;
    _city = user.city.isNotEmpty ? user.city : null;
    _profilePic = user.userPic.isNotEmpty ? user.userPic : null;
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _phoneController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  ImageProvider? _getProfileImage() {
    if (_profilePic == null || _profilePic!.isEmpty) {
      return null;
    }
    return _profilePic!.startsWith('http')
        ? NetworkImage(_profilePic!)
        : FileImage(File(_profilePic!));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profilePic = picked.path);
      if (mounted) {
        context.read<ProfileBloc>().add(ChangeProfilePicture(picked.path));
      }
    }
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  void _saveChanges() {
    final currentState = context.read<ProfileBloc>().state;
    if (currentState is ProfileLoaded) {
      final updatedUser = currentState.user.copyWith(
        fName: _fNameController.text.trim(),
        lName: _lNameController.text.trim(),
        phone: _phoneController.text.trim(),
        occupation: _occupationController.text.trim(),
        city: _city ?? '',
        state: _state ?? '',
        country: _country ?? '',
        userPic: _profilePic ?? '',
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Changes'),
          content: const Text('Are you sure you want to save these changes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveChanges();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          if (state is ProfileLoaded && !state.isEditing) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading profile...'),
                ],
              ),
            );
          }

          if (state is ProfileError) {
            return _buildErrorScreen(state.message);
          }

          if (state is ProfileLoaded) {
            _initializeFields(state.user);
            return _buildProfileScreen(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error: $errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(LoadUserProfile(widget.email));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen(BuildContext context, ProfileLoaded state) {
    final bool isEditing = state.isEditing;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _initializeFields(state.user);
                setState(() {});
              }
              context.read<ProfileBloc>().add(ToggleEditMode());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfilePicture(isEditing),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              'User ID',
              "${state.user.id ?? 'N/A'}",
              Icons.badge,
            ),
            _buildReadOnlyField('Email', state.user.email, Icons.email),
            const SizedBox(height: 20),
            CustomTextField(
              label: "First Name",
              hint: "Enter first name",
              controller: _fNameController,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Last Name",
              hint: "Enter last name",
              controller: _lNameController,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Phone",
              hint: "Enter phone number",
              controller: _phoneController,
              isNumber: true,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Occupation",
              hint: "Enter occupation",
              controller: _occupationController,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            _buildCountryDropdown(isEditing),
            const SizedBox(height: 16),
            _buildStateDropdown(isEditing),
            const SizedBox(height: 16),
            _buildCityDropdown(isEditing),
            const SizedBox(height: 30),
            if (isEditing) _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture(bool isEditing) {
    return GestureDetector(
      onTap: isEditing ? _pickImage : null,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _getProfileImage(),
            backgroundColor: Colors.grey[300],
            child:
                (_profilePic == null || _profilePic!.isEmpty)
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
          ),
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(bool isEditing) {
    return DropdownButtonFormField<String>(
      value: _country,
      decoration: _dropdownDecoration("Country"),
      items:
          countryStateCityMap.keys
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
      onChanged:
          isEditing
              ? (val) {
                setState(() {
                  _country = val;
                  _state = null;
                  _city = null;
                });
              }
              : null,
    );
  }

  Widget _buildStateDropdown(bool isEditing) {
    return DropdownButtonFormField<String>(
      value: _state,
      decoration: _dropdownDecoration("State"),
      items:
          (_country != null)
              ? countryStateCityMap[_country!]!.keys
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList()
              : [],
      onChanged:
          isEditing && _country != null
              ? (val) {
                setState(() {
                  _state = val;
                  _city = null;
                });
              }
              : null,
    );
  }

  Widget _buildCityDropdown(bool isEditing) {
    return DropdownButtonFormField<String>(
      value: _city,
      decoration: _dropdownDecoration("City"),
      items:
          (_country != null && _state != null)
              ? countryStateCityMap[_country!]![_state!]!
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList()
              : [],
      onChanged:
          isEditing && _country != null && _state != null
              ? (val) {
                setState(() {
                  _city = val;
                });
              }
              : null,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showSaveDialog,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Save Changes",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
