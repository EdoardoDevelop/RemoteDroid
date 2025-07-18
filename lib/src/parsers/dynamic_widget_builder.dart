import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'json_parser.dart';
import 'xml_parser.dart';
import 'package:remotedroid/src/parsers/widget_builder.dart' as wd;

class DynamicWidgetBuilder {
  // Cache to store already built widgets for better performance
  static final Map<String, Widget> _widgetCache = {};

  // Build widget from JSON string with caching and error handling
  static Widget buildFromJson(String jsonString, BuildContext context) {
    if (_widgetCache.containsKey(jsonString)) {
      return _widgetCache[jsonString]!;
    }

    try {
      final widgetDescription = JsonParser.parse(jsonString);
      final widget = wd.WidgetBuilder.build(widgetDescription, context);
      _widgetCache[jsonString] = widget;
      return widget;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error building widget from JSON: $e');
        print(stacktrace);
      }
      return ErrorWidget('Failed to build widget from JSON');
    }
  }

  // Build widget from XML string with caching and error handling
  static Widget buildFromXml(String xmlString, BuildContext context) {
    if (_widgetCache.containsKey(xmlString)) {
      return _widgetCache[xmlString]!;
    }

    try {
      final widgetDescription = XmlParser.parse(xmlString);
      if (kDebugMode) {
        print("Parsed XML to WidgetDescription: $widgetDescription");
      }
      final widget = wd.WidgetBuilder.build(widgetDescription, context);
      _widgetCache[xmlString] = widget;
      return widget;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error building widget from XML: $e');
        print(stacktrace);
      }
      return ErrorWidget('Failed to build widget from XML: $e');
    }
  }
}








