import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:moonbase_explore/model/unit_model.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';
import 'package:tempo_x/creation/views/widgets/snackbar.dart';

import '../../components/icon_button.dart';
import '../models/quiz_model.dart';

class NewAIQuizScreen extends StatefulWidget {
  final QuizModel? quizModel;
  final Function()? onDeleteQuiz;
  final List<Unit> units;
  const NewAIQuizScreen({this.quizModel, this.onDeleteQuiz, required this.units, super.key});

  @override
  State<NewAIQuizScreen> createState() => _NewAIQuizScreenState();
}

class _NewAIQuizScreenState extends State<NewAIQuizScreen>  {

  TextEditingController quizNameController = TextEditingController();
  TextEditingController quizDescriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Unit> selectedUnits = [];

  finishEditing(){
    if(!(formKey.currentState?.validate() ??false)){
      return;
    }
    if(selectedUnits.isEmpty){
      displaySnackbar(context, msg: "Please select at least one unit");
      return;
    }
    Navigator.pop(context, QuizModel(quizId: widget.quizModel?.quizId ?? "", selectedUnits: selectedUnits.map((e) => e.unitNumber).toList(), quizType: QuizType.aiGenerated, quizTitle: quizNameController.text, groupName: "", courseName: "", questions: [], quizDescription: quizDescriptionController.text));
  }

  @override
  void initState() {
    if(widget.quizModel != null){
      quizNameController.text = widget.quizModel?.quizTitle ?? "";
      quizDescriptionController.text = widget.quizModel?.quizDescription ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(


        appBar: AppBar(
          title: Text("New AI-Generated Quiz", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if(widget.onDeleteQuiz != null)CustomIconButton(Icons.delete, iconColor: Colors.red, onPressed: (){
              if(widget.onDeleteQuiz != null){
                widget.onDeleteQuiz!();
                Navigator.pop(context);
              }
            }),
          ],
       ),


        floatingActionButton: MoonbaseFab(
          onPressed: finishEditing,
          child: SvgPicture.asset(IconsAsset.blackLongArrowRight, width: 20, height:20, package:'moonbase_widgets',),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoonbaseTextField(labelText: "Quiz Name", controller: quizNameController, validator: (s)=> s==null || s.isEmpty ? "Field is required":null,),
                  const SizedBox(height: 20,),
                  MoonbaseTextField(labelText: "Description (optional)", controller: quizDescriptionController,),
                  const SizedBox(height: 30,),
                  Text("Select Units", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
                  const SizedBox(height:10),
                  const Text("Choose the units you want our Ai to pull information from while generating your quiz. (The Quiz will only be available AFTER publishing the Guide) ", ),
                  const SizedBox(height:20),
                  Align(alignment: Alignment.topLeft, child: Wrap(
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      spacing: 5,
                      runSpacing: 10,
                      children: List.generate(widget.units.length, (index) {
                        final selectionIndex = selectedUnits.indexWhere((element) => element.unitNumber == widget.units[index].unitNumber);
                        final isSelected = selectionIndex > -1;

                        return MoonbaseFab(onPressed: ()async{
                          setState(() {
                            if(isSelected){
                              selectedUnits.removeAt(selectionIndex);
                            }else{
                              selectedUnits.add(widget.units[index]);
                            }
                          });
                        },
                          isCircular: true,
                          label: widget.units[index].title,
                          subtitle: "${widget.units[index].videos.length} Video${widget.units[index].videos.length != 1?"s":""}",
                          backgroundColor: Color(isSelected ? 0xffFF8500 :0xff61BBFF), child: isSelected? const Icon(Icons.done): const SizedBox(),);
                      })
                  ),),
                  const SizedBox(height:20),

                ],
              ),
            ),
          ),
        )
    );
  }
}
