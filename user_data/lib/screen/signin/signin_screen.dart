import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_data/screen/signin/bloc/signin_bloc.dart';
import 'package:user_data/widget/text_field.dart';
import '../../router/router.dart';
import '../../widget/build_button.dart';
import '../home/home_screen.dart';

class SignInScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainHomeScreen(
                  userEmail: state.userEmail, // Pass email directly here
                ),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Welcome ${state.userEmail}")),
            );
          }
          else if (state is SignInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SignInLoading;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 80,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.login, size: 80),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Sign in to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),

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
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                label: "Email Address",
                                hint: "Enter your email address",
                                controller: emailController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                label: "Password",
                                hint: "Enter your password",
                                isPassword: true,
                                controller: passwordController,
                              ),
                              const SizedBox(height: 25),

                              buildButton(
                                text: isLoading ? "Signing in..." : "Sign In",
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<SignInBloc>().add(
                                      SignInRequested(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t have an account ? "),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.signUp),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
