import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:moonbase_collab_upload/moonbase_collab_upload.dart';
import 'package:intl/intl.dart';


class DraftManager {
  static final DraftManager _draftManager = DraftManager._internal();
  Box? box;

  factory DraftManager() {
    return _draftManager;
  }

  Future<Box?> openBox() async {
    if (box != null) {
      return box;
    }
    box = await Hive.openBox('draft');
    return box;
  }

  DraftManager._internal() {
    openBox();
  }

  Future<void> saveDraft(UGuide guide) async {
    // override if there is duplicate
    final timeList = readDraftTime();
    final guideList = await readDraft();
    final combinedList = combineGuidesAndDates(guideList, timeList);
    final index =
    combinedList.indexWhere((element) => element['guide'].id == guide.id);
    if (index != -1) {
      removeDraft(timeList[index]);
    }

    box?.put(DateTime.now().toString(), guide.toJson());
  }

  Future<List<UGuide>> readDraft() async {
    final box = await openBox();
    final list = box?.values.toList() ?? [];
    final guideList = list.map((e) => UGuide.fromJson(e)).toList();
    final List<UGuide> drafts = List<UGuide>.from(guideList);
    return drafts;
  }

  List<String> readDraftTime() {
    final list = box?.keys.toList() ?? [];
    final List<String> timeList = List<String>.from(list);
    return timeList;
  }

  void removeDraft(String key) {
    box?.delete(key);
  }

  void removeDraftByGuide(String index) async {
    try {
      int guideIndex = int.parse(index);
      final timeList = readDraftTime();

      removeDraft(timeList[guideIndex]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

List<Map<String, dynamic>> combineGuidesAndDates(
    List<UGuide> guides, List<String> draftTimes) {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm a');

  return List.generate(guides.length, (index) {
    DateTime date = DateTime.now(); // Default to now if parsing fails
    try {
      date = DateTime.parse(draftTimes[index]);
    } catch (e) {
      // Handle parsing error
      if (kDebugMode) {
        print(e);
      }
    }
    return {
      'guide': guides[index],
      'date': date,
    };
  });
}

// Function to group items by date
Map<String, List<Map<String, dynamic>>> groupItemsByDate(
    List<Map<String, dynamic>> combinedList) {
  final Map<String, List<Map<String, dynamic>>> groupedByDate = {};
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  for (var item in combinedList) {
    String dateKey = dateFormat.format(item['date']);
    if (!groupedByDate.containsKey(dateKey)) {
      groupedByDate[dateKey] = [];
    }
    groupedByDate[dateKey]!.add(item);
  }

  return groupedByDate;
}
