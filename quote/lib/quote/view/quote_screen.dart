import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_bloc.dart';
import '../../theme/theme_event.dart';
import '../../theme/theme_state.dart';
import '../bloc/quote_bloc.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(state.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                context.read<ThemeBloc>().add(ToggleThemeEvent());
              },
            );
          },
        ),
        title: const Text('Daily Quotes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (context, state) {
          if (state is QuoteInitial) {
            return const Center(child: Text("Press refresh to get a quote"));
          } else if (state is QuoteLoaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '"${state.quote}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text(
                        "- ${state.author}",
                        style: const TextStyle(fontSize: 16),
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
      floatingActionButton:  FloatingActionButton(
            onPressed: () {
              context.read<QuoteBloc>().add(LoadRandomQuote());
            },
            child: const Icon(Icons.refresh),
          ),

    );
  }
}
