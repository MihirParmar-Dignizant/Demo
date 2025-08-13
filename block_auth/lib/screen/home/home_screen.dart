import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../login/login_screen.dart';
import '../todo/todo_screen.dart';
import 'bloc/home_bloc.dart';
import 'home_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) =>  LoginScreen()),
                        (route) => false,
                  );
                } else if (state is LogoutFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is LogoutLoading;
                return IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    context.read<HomeBloc>().add(LogoutButtonPressed());
                  },
                  icon: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.logout),
                );
              },
            ),
          ],
        ),
        body: const Center(
          child: Text(
            "Welcome to the Home Screen",
            style: TextStyle(fontSize: 18),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TodoScreen()),
            );
          },
          child: const Icon(Icons.list),
        ),
      ),
    );
  }
}
