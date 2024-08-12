import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';

class QuestionImageButton extends StatelessWidget{
  final String? imagePathOrUrl;

  const QuestionImageButton(this.imagePathOrUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    if(imagePathOrUrl !=null && imagePathOrUrl!.isNotEmpty) {
      return Row(
        children: [
          SizedBox(
            width: 70,
            child: MoonbaseButton(
              text: "image", width: 70, isSmallButton: true, onPressed: () {
              final imageProvider = imagePathOrUrl!.startsWith("http") ? Image
                  .network(imagePathOrUrl!)
                  .image : Image
                  .file(File(imagePathOrUrl!))
                  .image;
              showImageViewer(context, imageProvider);
            },),
          ),
        ],
      );
    }else{
      return const SizedBox();
    }
  }

}