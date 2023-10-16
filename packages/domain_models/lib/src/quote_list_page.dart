import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class QuoteListPage extends Equatable {
  final bool isLastPage;
  final List<Quote> quoteList;

  const QuoteListPage({required this.isLastPage, required this.quoteList});

  @override
  List<Object?> get props => [isLastPage, quoteList];
}
