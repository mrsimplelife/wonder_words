import 'package:fav_qs_api/src/models/response/quote_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote_list_page_rm.g.dart';

@JsonSerializable(createToJson: false)
class QuoteListPageRM {
  @JsonKey(name: 'last_page')
  final bool isLastPage;
  @JsonKey(name: 'quotes')
  final List<QuoteRM> quoteList;

  const QuoteListPageRM({required this.isLastPage, required this.quoteList});

  static const fromJson = _$QuoteListPageRMFromJson;
}
