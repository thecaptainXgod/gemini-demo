import 'package:flutter/material.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';

import 'base_widget.dart';
class MoonbaseSuccessScreen extends BaseStatelessWidget{

  final Function(BuildContext) onProceed;
  final String message, title, buttonLabel;
  const MoonbaseSuccessScreen({super.key, this.title="Success!", this.buttonLabel="CONTINUE", required this.message, required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: (){ onProceed(context); }, icon: const Icon(Icons.arrow_back),),),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              const Text("🎉", style: TextStyle(fontSize: 70),),
              // const Text("🎇", style: TextStyle(fontSize: 70),),
              const SizedBox(height: 40,),
              Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
              const SizedBox(height: 20,),
              Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge,),
              const Expanded(child: SizedBox()),
              MoonbaseButton(
                text: buttonLabel,
                width: MediaQuery.of(context).size.width,
                onPressed: ()=>onProceed(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}