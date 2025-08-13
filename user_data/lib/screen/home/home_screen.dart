import 'dart:io'; // Import this to work with local files
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../router/router.dart';
import '../signin/signin_screen.dart';
import 'bloc/home_bloc.dart';

class MainHomeScreen extends StatelessWidget {
  final String userEmail;

  const MainHomeScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadUserData(userEmail)),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is HomeError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          }

          if (state is HomeLoaded) {
            final user = state.user;

            Widget buildProfileImage(double size) {
              ImageProvider? imageProvider;

              if (user.userPic.isNotEmpty) {
                // Check if the path is a network URL or a local file path
                if (user.userPic.startsWith('http')) {
                  imageProvider = NetworkImage(user.userPic);
                } else {
                  imageProvider = FileImage(File(user.userPic));
                }
              }

              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                  color: Colors.grey.shade300,
                  image: imageProvider != null
                      ? DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: imageProvider == null
                    ? Icon(Icons.person, size: size * 0.5, color: Colors.grey.shade800)
                    : null,
              );
            }

            return Scaffold(
              appBar: AppBar(title: const Text("User Profile")),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text("${user.fName} ${user.lName}"),
                      accountEmail: Text(user.email),
                      currentAccountPicture: buildProfileImage(40),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.profile,
                          arguments: user.email,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('loggedInEmail');

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => SignInScreen()),
                              (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildProfileImage(120),
                    const SizedBox(height: 16),
                    Text(
                      "${user.fName} ${user.lName}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}