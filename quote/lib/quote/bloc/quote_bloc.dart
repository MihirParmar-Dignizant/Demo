import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(QuoteInitial()) {
    on<LoadRandomQuote>((event, emit) {
      if (_availableQuotes.isEmpty) {
        _availableQuotes = List.from(quotes);
      }

      final random = Random();
      final data = _availableQuotes.removeAt(random.nextInt(_availableQuotes.length));

      emit(QuoteLoaded(quote: data["quote"]!, author: data["author"]!));
    });
  }

  final List<Map<String, String>> quotes = [
    {
      "quote": "The best way to get started is to quit talking and begin doing.",
      "author": "Walt Disney"
    },
    {
      "quote": "Don't let yesterday take up too much of today.",
      "author": "Will Rogers"
    },
    {
      "quote": "It's not whether you get knocked down, it's whether you get up.",
      "author": "Vince Lombardi"
    },
    {
      "quote": "If you are working on something exciting, it will keep you motivated.",
      "author": "Steve Jobs"
    },
    {
      "quote": "Success is not in what you have, but who you are.",
      "author": "Bo Bennett"
    },
    {
      "quote": "Your time is limited, so don’t waste it living someone else’s life.",
      "author": "Steve Jobs"
    },
    {
      "quote": "Hardships often prepare ordinary people for an extraordinary destiny.",
      "author": "C.S. Lewis"
    },
    {
      "quote": "Do what you can, with what you have, where you are.",
      "author": "Theodore Roosevelt"
    },
    {
      "quote": "Everything you’ve ever wanted is on the other side of fear.",
      "author": "George Addair"
    },
    {
      "quote": "Believe you can and you’re halfway there.",
      "author": "Theodore Roosevelt"
    },
    {
      "quote": "Happiness is not something ready-made. It comes from your own actions.",
      "author": "Dalai Lama"
    },
    {
      "quote": "Don’t count the days, make the days count.",
      "author": "Muhammad Ali"
    },
    {
      "quote": "The future belongs to those who believe in the beauty of their dreams.",
      "author": "Eleanor Roosevelt"
    },
    {
      "quote": "Opportunities don’t happen, you create them.",
      "author": "Chris Grosser"
    },
    {
      "quote": "I never dreamed about success, I worked for it.",
      "author": "Estée Lauder"
    },
  ];

  late List<Map<String, String>> _availableQuotes = List.from(quotes);
}
