import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:universalworkspace_backend/dispatch/dispatch.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-error/errors.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/notification.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/query.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-search/result.pb.dart';
import 'package:universalworkspace_result/universalworkspace_result.dart';
import 'package:fixnum/fixnum.dart';

class SearchBackendService {
  static Future<UniflowResult<SearchResponseStream, UniflowError>> performSearch(
    String keyword,
  ) async {
    final searchId = DateTime.now().millisecondsSinceEpoch.toString();
    final stream = SearchResponseStream(searchId: searchId);

    final request = SearchQueryPB(
      search: keyword,
      searchId: searchId,
      streamPort: Int64(stream.nativePort),
    );

    unawaited(SearchEventStreamSearch(request).send());
    return UniflowResult.success(stream);
  }
}

class SearchResponseStream {
  SearchResponseStream({required this.searchId}) {
    _port.handler = _controller.add;
    _subscription = _controller.stream.listen(
      (Uint8List data) => _onResultsChanged(data),
    );
  }

  final String searchId;
  final RawReceivePort _port = RawReceivePort();
  final StreamController<Uint8List> _controller = StreamController.broadcast();
  late StreamSubscription<Uint8List> _subscription;
  void Function(
    List<SearchResponseItemPB> items,
    String searchId,
    bool searching,
    bool generatingAIOverview,
  )? _onServerItems;
  void Function(
    List<SearchSummaryPB> summaries,
    String searchId,
    bool searching,
    bool generatingAIOverview,
  )? _onSummaries;

  void Function(
    List<LocalSearchResponseItemPB> items,
    String searchId,
  )? _onLocalItems;

  void Function(String searchId)? _onFinished;
  int get nativePort => _port.sendPort.nativePort;

  Future<void> dispose() async {
    await _subscription.cancel();
    _port.close();
  }

  void _onResultsChanged(Uint8List data) {
    final searchState = SearchStatePB.fromBuffer(data);

    if (searchState.hasResponse()) {
      if (searchState.response.hasSearchResult()) {
        _onServerItems?.call(
          searchState.response.searchResult.items,
          searchId,
          searchState.response.searching,
          searchState.response.generatingAiSummary,
        );
      }
      if (searchState.response.hasSearchSummary()) {
        _onSummaries?.call(
          searchState.response.searchSummary.items,
          searchId,
          searchState.response.searching,
          searchState.response.generatingAiSummary,
        );
      }

      if (searchState.response.hasLocalSearchResult()) {
        _onLocalItems?.call(
          searchState.response.localSearchResult.items,
          searchId,
        );
      }
    } else {
      _onFinished?.call(searchId);
    }
  }

  void listen({
    required void Function(
      List<SearchResponseItemPB> items,
      String searchId,
      bool isLoading,
      bool generatingAIOverview,
    )? onServerItems,
    required void Function(
      List<SearchSummaryPB> summaries,
      String searchId,
      bool isLoading,
      bool generatingAIOverview,
    )? onSummaries,
    required void Function(
      List<LocalSearchResponseItemPB> items,
      String searchId,
    )? onLocalItems,
    required void Function(String searchId)? onFinished,
  }) {
    _onServerItems = onServerItems;
    _onSummaries = onSummaries;
    _onLocalItems = onLocalItems;
    _onFinished = onFinished;
  }
}
