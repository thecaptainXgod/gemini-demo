import 'package:flutter/material.dart';


abstract class BaseWidget {}

abstract class BaseStatelessWidget extends StatelessWidget

    implements BaseWidget {
  const BaseStatelessWidget({Key? key}) : super(key: key);

  BaseStatelessWidget.logScreen({Key? key, required String screenName})
      : super(key: key) {
    // Analytics.instance.logScreen(screenName: screenName);
  }
}

abstract class BaseStatefulWidget extends StatefulWidget implements BaseWidget {
  const BaseStatefulWidget({Key? key}) : super(key: key);

  BaseStatefulWidget.logScreen({Key? key}) : super(key: key) {
    // Analytics.instance.logScreen(screenName: screenName);
  }
}
