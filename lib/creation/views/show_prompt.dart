import 'package:flutter/material.dart';
import 'package:moonbase_widgets/widgets/moonbase_button.dart';

void showPrompt(String title, String message, {required BuildContext context,String? proceedBtnText, String? cancelBtnText, Function()? onProceed, Function()? onCancel, bool? dismissible}){
  showDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: dismissible ?? false,
    builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          MoonbaseButton(text: cancelBtnText ?? "Cancel", textColor: Theme.of(context).primaryColor, width: 200, color: Theme.of(context).scaffoldBackgroundColor, onPressed: (){
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 300), onCancel);
          },)
        ],
        title: Text(title, textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center,),
            const SizedBox(height:20),
            MoonbaseButton(text: proceedBtnText ?? "Proceed", width: 200, onPressed:(){
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), onProceed);
            },),
          ],
        )
    ),
  );
}