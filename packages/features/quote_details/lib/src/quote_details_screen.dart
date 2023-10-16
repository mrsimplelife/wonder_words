import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_details/src/quote_details_cubit.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:share_plus/share_plus.dart';

class QuoteDetailsScreen extends StatelessWidget {
  final int quoteId;
  final QuoteRepository quoteRepository;
  final VoidCallback onAuthenticationError;
  final QuoteDetailsShareableLinkGenerator? shareableLinkGenerator;

  const QuoteDetailsScreen({
    required this.quoteId,
    required this.quoteRepository,
    required this.onAuthenticationError,
    this.shareableLinkGenerator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteDetailsCubit>(
      child: QuoteDetailsView(
        onAuthenticationError: onAuthenticationError,
        shareableLinkGenerator: shareableLinkGenerator,
      ),
      create: (_) => QuoteDetailsCubit(
        quoteId: quoteId,
        quoteRepository: quoteRepository,
      ),
    );
  }
}

@visibleForTesting
class QuoteDetailsView extends StatelessWidget {
  final VoidCallback onAuthenticationError;
  final QuoteDetailsShareableLinkGenerator? shareableLinkGenerator;

  const QuoteDetailsView({
    required this.onAuthenticationError,
    this.shareableLinkGenerator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledStatusBar.dark(
      child: BlocConsumer<QuoteDetailsCubit, QuoteDetailsState>(
        listener: (context, state) {
          final quoteUpdateError =
              state is QuoteDetailsSuccess ? state.quoteUpdateError : null;

          if (quoteUpdateError != null) {
            final snackBar =
                quoteUpdateError is UserAuthenticationRequiredException
                    ? const AuthenticationRequiredErrorSnackBar()
                    : const GenericErrorSnackBar();

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);

            if (quoteUpdateError is UserAuthenticationRequiredException) {
              onAuthenticationError();
            }
          }
        },
        builder: (context, state) {
          print('rendering QuoteDetailsView');
          return WillPopScope(
            onWillPop: () async {
              final displayedQuote =
                  state is QuoteDetailsSuccess ? state.quote : null;
              Navigator.of(context).pop(displayedQuote);
              return false;
            },
            child: Scaffold(
              appBar: state is QuoteDetailsSuccess
                  ? _QuoteActionsAppBar(
                      quote: state.quote,
                      shareableLinkGenerator: shareableLinkGenerator,
                    )
                  : null,
              body: SafeArea(
                child: Padding(
                  child: state is QuoteDetailsSuccess
                      ? _Quote(quote: state.quote)
                      : state is QuoteDetailsFailure
                          ? ExceptionIndicator(
                              onTryAgain: () {
                                final cubit = context.read<QuoteDetailsCubit>();
                                cubit.refetch();
                              },
                            )
                          : const CenteredCircularProgressIndicator(),
                  padding: EdgeInsets.all(WonderTheme.of(context).screenMargin),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuoteActionsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Quote quote;
  final QuoteDetailsShareableLinkGenerator? shareableLinkGenerator;

  const _QuoteActionsAppBar({
    required this.quote,
    this.shareableLinkGenerator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rendering _QuoteActionsAppBar');
    final cubit = context.read<QuoteDetailsCubit>();
    final shareableLinkGenerator = this.shareableLinkGenerator;
    return RowAppBar(children: [
      FavoriteIconButton(
        isFavorite: quote.isFavorite ?? false,
        onTap: () {
          if (quote.isFavorite == true) {
            cubit.unfavoriteQuote();
          } else {
            cubit.favoriteQuote();
          }
        },
      ),
      UpvoteIconButton(
        count: quote.upvotesCount,
        isUpvoted: quote.isUpvoted ?? false,
        onTap: () {
          if (quote.isUpvoted == true) {
            cubit.unvoteQuote();
          } else {
            cubit.upvoteQuote();
          }
        },
      ),
      DownvoteIconButton(
        count: quote.downvotesCount,
        isDownvoted: quote.isDownvoted ?? false,
        onTap: () {
          if (quote.isDownvoted == true) {
            cubit.unvoteQuote();
          } else {
            cubit.downvoteQuote();
          }
        },
      ),
      if (shareableLinkGenerator != null)
        ShareIconButton(
          onTap: () async {
            final url = await shareableLinkGenerator(quote);

            Share.share(url);
          },
        ),
    ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Quote extends StatelessWidget {
  static const double _quoteIconWidth = 46;

  final Quote quote;

  const _Quote({required this.quote, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rendering _Quote');
    final theme = WonderTheme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: OpeningQuoteSvgAsset(width: _quoteIconWidth),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xxLarge),
          child: Center(
            child: ShrinkableText(
              quote.body,
              style: theme.quoteTextStyle.copyWith(fontSize: FontSize.xxLarge),
            ),
          ),
        ),
      ),
      const ClosingQuoteSvgAsset(width: _quoteIconWidth),
      const SizedBox(height: Spacing.medium),
      Text(
        quote.author ?? '',
        style: const TextStyle(fontSize: FontSize.large),
      ),
    ]);
  }
}

typedef QuoteDetailsShareableLinkGenerator = Future<String> Function(
  Quote quote,
);
