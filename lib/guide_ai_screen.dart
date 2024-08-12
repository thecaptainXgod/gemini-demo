import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_collab_upload/moonbase_collab_upload.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_screen.dart';
import 'package:moonbase_explore/utils/custom_loader.dart';

import 'package:moonbase_explore/utils/enums.dart';

import 'package:moonbase_explore/widgets/base_tempo_screen.dart';
import 'package:moonbase_explore/widgets/common_edit_text_field.dart';
import 'package:moonbase_theme/moonbase_theme.dart';
import 'package:tempo_x/repository/home_repository.dart';
import 'package:tempo_x/tempo_plugin_handler.dart';
import 'package:tempo_x/utils/moonbase_text_button.dart';
import 'package:uuid/uuid.dart';

import 'models/guide_ai.dart';

class GuideAIScreen extends StatefulWidget {
  const GuideAIScreen({super.key});

  @override
  _GuideAIScreenState createState() => _GuideAIScreenState();
}

class _GuideAIScreenState extends State<GuideAIScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _promptController = TextEditingController();

  int? _selectedUnits;
  int? _selectedVideosPerUnit;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgTempoScreen(
      pageTitle: 'AI-Guide',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TTextField(
                controller: _promptController,
                label: 'Topic',
                choice: ChoiceEnum.text,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedUnits,
                decoration: const InputDecoration(
                  labelText: 'Units',
                ),
                items: List.generate(10, (index) => index + 1)
                    .map((unit) => DropdownMenuItem<int>(
                          value: unit,
                          child: Text(unit.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnits = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select units';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedVideosPerUnit,
                decoration: const InputDecoration(
                  labelText: 'Videos per Unit',
                ),
                items: List.generate(10, (index) => index + 1)
                    .map((video) => DropdownMenuItem<int>(
                          value: video,
                          child: Text(video.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVideosPerUnit = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select videos per unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              SizedBox(
                height: 60,
                child: MoonbaseTextButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final prompt = _promptController.text;
                      final units = _selectedUnits!;
                      final videosPerUnit = _selectedVideosPerUnit!;

                      callApi(
                        prompt,
                        units,
                        videosPerUnit,
                        context,
                      );
                    }
                  },
                  enabledBackgroundColor:
                      MoonbaseDarkTheme.getTheme().primaryColorDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  generateId() {
    var uuid = const Uuid();
    final id = uuid.v1();
    return id;
  }

  callApi(prompt, units, videosPerUnit, context) async {
    showLoader(context);
    await HomeRepository()
        .createGuideUsingAI(
            prompt: prompt,
            units: units.toString(),
            videosPerUnit: videosPerUnit.toString())
        .then((value) => value.when(success: (GuideAi? data) {
              hideLoader(context);

              String organizationId = '1';
              String groupId = '10';
              String createdBy = '20';

              Guide? response = data!.data!.guide!;

              final List<Unit> units = [];

              for (var unit in response.units!) {
                final List<Video> videos = [];
                for (Videos video in unit.videos!) {
                  videos.add(Video(
                      id: generateId(),
                      title: video.title!,
                      caption: video.script!,
                      videoNumber: unit.videos!.indexOf(video) + 1,
                      unitNumber: response.units!.indexOf(unit) + 1,
                      videoDetails:
                          VideoDetails(videoPath: '', coverImagePath: '')));
                }
                units.add(Unit(
                    videos: videos,
                    id: generateId(),
                    unitNumber: response.units!.indexOf(unit) + 1,
                    title: unit.title!,
                    localCoverImagePath: '',
                    coverImagePath: '',
                    name: unit.title!,
                    description: unit.description!));
              }

              UGuide guide = UGuide(
                id: generateId(),
                organizationId: organizationId,
                groupId: groupId,
                createdBy: createdBy,
                guideName: response.title!,
                description: response.description!,
                trailerVideo: VideoDetails(videoPath: '', coverImagePath: ''),
                units: units,
                quizzes: [],
              );

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoonbaseExplorePluginHandler(
                      child: CreateGuideScreen(
                        editableJson: guide.toMap(),
                        isEditable: true,
                      ),
                    ),
                  ));
            }, failure: (failure) {
              hideLoader(context);
            }));
  }
}
