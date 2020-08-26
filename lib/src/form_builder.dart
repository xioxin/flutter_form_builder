import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
typedef ValueTransformer<T> = dynamic Function(T value);

class FormBuilder extends StatefulWidget {
  //final BuildContext context;
  final Function(Map<String, dynamic>) onChanged;
  final WillPopCallback onWillPop;
  final Widget child;
  final bool readOnly;
  final bool autovalidate;
  final Map<String, dynamic> initialValue;
  final Key key;

  const FormBuilder( //this.context,
      {
    @required this.child,
    this.readOnly = false,
    this.key,
    this.onChanged,
    this.autovalidate = false,
    this.onWillPop,
    this.initialValue = const {},
  }) : super(key: key);

  static FormBuilderState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<FormBuilderState>());

  @override
  FormBuilderState createState() => FormBuilderState();
}

class FormBuilderState extends State<FormBuilder> {
  //FIXME: Find way to assert no duplicates in control attributes
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _value;
  Map<String, dynamic> get value => _value;
  Map<String, dynamic> get initialValue => widget.initialValue;

  Map<String, GlobalKey<FormFieldState>> get fields {
    return _formBuilderFields.map((k, v) {
      return MapEntry(k, v.fieldKey);
    });
  }

  GlobalKey<FormFieldState> getFieldKey(String k) => _formBuilderFields[k]?.fieldKey;

  Map<String, FormBuilderBase> _formBuilderFields;

  bool get readOnly => widget.readOnly;

  @override
  void initState() {
    _value = {};
    _formBuilderFields = {};
    super.initState();
  }

  @override
  void dispose() {
    _formBuilderFields = null;
    super.dispose();
  }

  void setAttributeValue(String attribute, dynamic value) {
    setState(() {
      _value[attribute] = value;
    });
  }

  void patchValue(Map<String, dynamic> data) {
    data.forEach((field, value) {
      print('patchvalue, $field, $value');
      if(this._formBuilderFields.containsKey(field) == false) return;
      print(this._formBuilderFields);
      this._formBuilderFields[field].setValue(value);
    });
  }

  setValue (String field, dynamic value) {
    this._formBuilderFields[field].setValue(value);
  }

//  requestFocus (String field) {
//    this._formBuilderFields[field].requestFocus();
//  }

  dynamic getValue(String field) {
    return _formBuilderFields[field]?.getValue();
  }

  registerFieldKey(String attribute, FormBuilderBase formBuilderField) {
    if(formBuilderField is FormBuilderBase) {
      this._formBuilderFields[attribute] = formBuilderField;
    }
  }

  unregisterFieldKey(String attribute) {
    this._formBuilderFields.remove(attribute);
  }

  void save() {
    _formKey.currentState.save();
  }

  bool validate() {
    return _formKey.currentState.validate();
  }

  bool saveAndValidate() {
    _formKey.currentState.save();
    return _formKey.currentState.validate();
  }

  void reset() {
    _formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.child,
      autovalidate: widget.autovalidate,
      onWillPop: widget.onWillPop,
      onChanged: () {
        if (widget.onChanged != null) {
          save();
          widget.onChanged(value);
        }
      },
    );
  }
}
