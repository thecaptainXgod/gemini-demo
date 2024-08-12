import 'dart:io';

import 'package:banner_listtile/banner_listtile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moonbase_explore/bloc/draft/draft_bloc.dart';
import 'package:moonbase_explore/bloc/explore_bloc.dart';
import 'package:moonbase_explore/bloc/quizzes_bloc/quizzes_bloc.dart';
import 'package:moonbase_explore/bloc/video_bloc/video_bloc.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_screen.dart';
import 'package:moonbase_explore/screen/create_guide/units/unit_video_picker.dart';
import 'package:moonbase_theme/themes/moonbase_dark_theme.dart';
import 'package:lottie/lottie.dart';

import 'package:moonbase_collab_upload/moonbase_collab_upload.dart';
import 'package:moonbase_explore/app_constants/custom_snackbars.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_screen.dart';
import 'package:moonbase_explore/utils/utility.dart';
import 'package:moonbase_explore/widgets/common_text.dart';
import 'package:intl/intl.dart';
import 'package:tempo_x/storage/draft_manager.dart';
import 'package:tempo_x/tempo_plugin_handler.dart';

import 'creation/bloc/quiz_creation_cubit.dart';
import 'guide_option_dialog.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DraftBloc>(
          create: (_) => DraftBloc(),
          child: const SavedDraftsScreen(),
        ),
        BlocProvider<ExploreBloc>(
          create: (_) => ExploreBloc(),
        ),
        BlocProvider<QuizCreationCubit>(
          create: (_) => QuizCreationCubit(QuizCreationState()),
        ),
        BlocProvider<VideoBloc>(
          create: (_) => VideoBloc(),
        ),
        BlocProvider<QuizzesBloc>(create: (_) => QuizzesBloc()),
      ],
      child: MaterialApp(
        title: 'Explore',
        theme: MoonbaseDarkTheme.getTheme(),
        home: const SavedDraftsScreen(),
      ),
    );
  }
}

class SavedDraftsScreen extends StatefulWidget {
  const SavedDraftsScreen({super.key});

  @override
  State<SavedDraftsScreen> createState() => _SavedDraftsScreenState();
}

class _SavedDraftsScreenState extends State<SavedDraftsScreen> {
  DraftManager draftManager = DraftManager();
  final ValueNotifier<List<UGuide>> _visiBilityNotifier = ValueNotifier([]);

  @override
  void initState() {
    callMethod();
    super.initState();
  }

  Future<void> _onDelete(String key, String guideName) async {
    warningTopSnackBar(context, 'Do you want to delete this guide?',
        deleteText: 'Delete', discard: () {
      try {
        draftManager.removeDraft(key);
        callMethod();
        Navigator.of(context).pop();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  callMethod() async {
    _visiBilityNotifier.value = await draftManager.readDraft();
  }

  @override
  void dispose() {
    _visiBilityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Guides'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showGuidanceDialog(context);
          },
          tooltip: 'Create Guide',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.

        body: ValueListenableBuilder<List<UGuide>>(
          valueListenable: _visiBilityNotifier,
          builder: (context, guides, child) {
            final draftTimes =
                draftManager.readDraftTime(); // Fetch draft times
            final combinedList = combineGuidesAndDates(guides, draftTimes);
            final groupedItems = groupItemsByDate(combinedList);

            final DateFormat headerDateFormat = DateFormat('d MMMM yyyy');
            final DateFormat timeFormat = DateFormat('HH:mm');

            return groupedItems.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: groupedItems.entries.map((entry) {
                        String dateKey = entry.key;
                        List<Map<String, dynamic>> items = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  headerDateFormat
                                      .format(DateTime.parse(dateKey)),
                                  style: const TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // List of guides for the current date
                            Column(
                              children: items.map((item) {
                                UGuide guide = item['guide'];
                                String time = timeFormat.format(item['date']);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  child: CustomBannerListTile(
                                    imageUrl:
                                        guide.trailerVideo.localCoverImagePath,
                                    title: guide.guideName,
                                    subtitle: guide.description,
                                    bannerText: time,
                                    onDelete: () {
                                      _onDelete(
                                          draftTimes[guides.indexOf(guide)],
                                          guide.guideName);
                                    },
                                    onEdit: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            MoonbaseExplorePluginHandler(
                                          child: CreateGuideScreen(
                                            editableJson: guide.toMap(),
                                            isEditable: true,
                                            index: guides
                                                .indexOf(guide)
                                                .toString(),
                                          ),
                                        ),
                                      ));
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/no_drafts.json',
                            height: 200,
                            width: 200,
                          ),
                          const TText("No Guide Found",
                              variant: TypographyVariant.h1),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class CustomBannerListTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String bannerText;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  CustomBannerListTile({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.bannerText,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BannerListTile(
      height: 80,
      onTap: onEdit,
      backgroundColor: const Color(0xff3CFF96),
      borderRadius: BorderRadius.circular(8),
      bannerTextColor: Colors.white,
      bannerPosition: BannerPosition.topRight,
      bannerText: bannerText,
      bannerColor: const Color(0xffFB655F),
      imageContainer: Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Color(0xff8B989A)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(fontSize: 10, color: Color(0xff8B989A)),
      ),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(
          Icons.delete_forever,
          color: Color(0xffFB655F),
        ),
      ),
    );
  }
}
