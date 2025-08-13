part of 'quote_bloc.dart';

abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final String quote;
  final String author;

  QuoteLoaded({required this.quote, required this.author});
}
