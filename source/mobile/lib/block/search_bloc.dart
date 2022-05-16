import 'package:happy_hearts_pet_care_services/models/search_modal.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _search = PublishSubject<SearchModal>();

  Observable<SearchModal> get searchStream => _search.stream;

  Future searchSink(String text) async {
    SearchModal searchModal = await Repository().searchRepository(text);
    _search.sink.add(searchModal);
  }

  dispose() {
    _search.close();
  }
}

final searchBloc = SearchBloc();
