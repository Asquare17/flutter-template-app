import 'dart:async';
import 'package:Instahelp/modules/setting/setting.dart';
import 'package:Instahelp/src/blocs/Bloc.dart';
import 'package:Instahelp/src/providers/request_services/PlaceProvider.dart';
import 'package:Instahelp/src/providers/request_services/query/PageQuery.dart';
import 'package:Instahelp/src/entity/PlaceCategory.dart';

class CityDetailBloc implements Bloc {
  // Data
  var _currentPage = 1;
  var categories = <PlaceCategory>[];

  // Stream
  final _categoryController = StreamController<List<PlaceCategory>>.broadcast();
  Stream<List<PlaceCategory>> get categoriesStream => _categoryController.stream;

  void fetchFeature(int cityId) async {
    final response = await PlaceProvider.getFeature("$cityId",
        query: PageQuery(Setting.requestItemPerPage, _currentPage));
    print("Fetched places of city $cityId at page $_currentPage");
    _currentPage++;
    List<PlaceCategory> tmp;
    if (response.data != null && response.data.isNotEmpty) {
      tmp = List<PlaceCategory>.generate(response.data.length,
          (i) => PlaceCategory.fromJson(response.data[i]));
      categories.addAll(tmp);
      _categoryController.sink.add(tmp);
      // Request next
      //fetchPlaces(cityId);
    }
  }

  // void _groupCategories(List<Place> all) {
  //   for (var place in all) {
  //     for (var category in place.categories) {
  //       var categoryIds = this.categories.map((category) => category.id).toList();
  //       if (!categoryIds.contains(category.id))
  //         this.categories.add(category);
  //     }
  //   }
  //   this.categories.sort((a,b) => a.id.compareTo(b.id));
  // }
  @override
  void dispose() {
    _categoryController.close();
  }
}
