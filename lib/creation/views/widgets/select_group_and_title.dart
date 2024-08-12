import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moonbase_explore/utils/enums.dart';
import 'package:moonbase_explore/widgets/common_edit_text_field.dart';

import '../../../components/common_text.dart';
import '../../bloc/quiz_creation_cubit.dart';


class SelectGroupAndTitle extends StatelessWidget{

  final String? groupName;
  final String? courseName;
  final String title;
  final Function(String)? onGroupSelected;
  final Function(String)? onTitleChanged;
  final TextEditingController? titleController;

  const SelectGroupAndTitle({super.key, this.courseName, this.groupName, this.title="", this.onGroupSelected, this.onTitleChanged, this.titleController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        const MText("Quiz Topic", variant: TypographyVariant.subtitleSmall,),
        const SizedBox(height: 10,),
        Builder(
          builder: (context) {
            titleController?.text = context.read<QuizCreationCubit>().state.quiz!.quizTitle;
            return TTextField(
              choice: ChoiceEnum.optionalText,
              controller: titleController??TextEditingController(),
              label: "Enter Topic",
              onChanged: (s){
                context.read<QuizCreationCubit>().state.quiz!.quizTitle = s;
                context.read<QuizCreationCubit>().updateQuiz(context.read<QuizCreationCubit>().state.quiz);
              },
              isMandatory: true,
              validations: (selected){
                if(selected == null || selected.isEmpty) return "Enter a topic for the quiz";
                return null;
              },
            );
          }
        )
      ],
    );

  }

}