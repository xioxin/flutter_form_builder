import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class FormBuilderBase {
  GlobalKey<FormFieldState> get fieldKey;
  setValue(dynamic value);
  dynamic getValue();
}
