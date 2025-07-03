import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/widget_action.dart';
import '../parsers/action_handler.dart';
import 'package:xml/xml.dart';
import '../models/widget_description.dart';

typedef WidgetBuilderFunction = Widget Function(
    Map<String, dynamic> properties);

class WidgetBuilder {
  static final Map<String, WidgetBuilderFunction> _customBuilders = {};

  static void registerCustomBuilder(
      String type, WidgetBuilderFunction builder) {
    _customBuilders[type] = builder;
  }

  static Widget build(WidgetDescription description, BuildContext context) {
    // Check if the widget type has a custom builder registered
    print( 'Building widget: ${description.type} with properties: ${description.properties}');

    if (_customBuilders.containsKey(description.type)) {
      return _customBuilders[description.type]!(description.properties);
    }

    try {
      print( 'Building widget step2: ${description.type}');
      switch (description.type) {
        case 'Text':
          return _buildText(description.properties, context);
        case 'Container':
          return _buildContainer(description.properties, context);
        case 'Column':
          return _buildColumn(description.properties, context);
        case 'Row':
          return _buildRow(description.properties, context);
        case 'ListView':
          return _buildListView(description.properties, context);
        case 'Expanded':
          return _buildExpanded(description.properties, context);
        case 'Padding':
          return _buildPadding(description.properties, context );
        case 'Center':
          return _buildCenter(description.properties, context);

        case 'Align':
          return _buildAlign(description.properties, context);
        case 'SizedBox':
          return _buildSizedBox(description.properties, context);
        case 'AspectRatio':
          return _buildAspectRatio(description.properties, context);
        case 'FittedBox':
          return _buildFittedBox(description.properties, context);
        case 'FractionallySizedBox':
            return _buildFractionallySizedBox(description.properties, context);
        case 'LimitedBox':
          return _buildLimitedBox(description.properties, context);
        case 'Offstage':
          return _buildOffstage(description.properties, context);
        case 'OverflowBox':
          return _buildOverflowBox(description.properties, context);
        case 'SizedOverflowBox':
          return _buildSizedOverflowBox(description.properties, context);
        case 'Transform':
          return _buildTransform(description.properties, context);
        case 'CustomPaint': 
          return _buildCustomPaint(description.properties, context);
        case 'ClipPath':
          return _buildClipPath(description.properties, context);
        case 'ClipRect':
          return _buildClipRect(description.properties, context);
        case 'ClipOval':
          return _buildClipOval(description.properties, context);
        case 'Opacity':
          return _buildOpacity(description.properties, context);
        case 'BackdropFilter':
          return _buildBackdropFilter(description.properties, context);
        case 'DecoratedBox':
          return _buildDecoratedBox(description.properties, context);
        case 'FractionalTranslation':
          return _buildFractionalTranslation(description.properties, context); 
        case 'RotatedBox':
          return _buildRotatedBox(description.properties, context);
        case 'ConstrainedBox':
          return _buildConstrainedBox(description.properties, context);
        case 'UnconstrainedBox':
          return _buildUnconstrainedBox(description.properties, context);
        case 'Scaffold':
          return _buildScaffold(description.properties, context);
        case 'AppBar':
          return _buildAppBar(description.properties, context);
        case 'BottomNavigationBar':
          return _buildBottomNavigationBar(description.properties, context); 
        case 'Drawer':
          return _buildDrawer(description.properties, context);
        case 'SingleChildScrollView':
          return _buildSingleChildScrollView(description.properties, context);  
        case 'TabBar':
          return _buildTabBar(description.properties, context);
        case 'TabBarView':
          return _buildTabBarView(description.properties, context);
        case 'AlertDialog':
          return _buildAlertDialog(description.properties, context);
        case 'SnackBar':
          return _buildSnackBar(description.properties, context);

        case 'Icon':
          return _buildIcon(description.properties, context);
        case 'BottomSheet':
          return _buildBottomSheet(description.properties, context);
        case 'Divider':
          return _buildDivider(description.properties, context);
        case 'CircularProgressIndicator':
          return _buildCircularProgressIndicator(description.properties, context);
        case 'LinearProgressIndicator':
          return _buildLinearProgressIndicator(description.properties, context);
        case 'Slider':
          return _buildSlider(description.properties, context);
        case 'Switch':
          return _buildSwitch(description.properties, context);
        case 'Checkbox':
          return _buildCheckbox(description.properties, context);
        case  'Image':
          return _buildImage(description.properties, context);

        case 'CustomScrollView':
          return _buildCustomScrollView(description.properties, context);
        case 'Scrollable':
          return _buildScrollable(description.properties, context);
        case 'Scrollbar':
          return _buildScrollbar(description.properties, context);
        case 'ScrollConfiguration':
          return _buildScrollConfiguration(description.properties, context );
        case 'ScrollNotification':
          return _buildScrollNotification(description.properties, context);

        case 'ScrollController':
          return _buildScrollController(description.properties, context);
        case 'body':
          return _buildBody(description.properties, context);          

        case 'Radio':
            return _buildRadio(description.properties, context);
        case 'DropdownButton':
          return _buildDropdownButton(description.properties, context);
        case 'Chip':
          return _buildChip(description.properties, context);
        case 'Tooltip':
          return _buildTooltip(description.properties, context);
        case 'AnimatedContainer':
          return _buildAnimatedContainer(description.properties, context);
        case 'FadeTransition':
          return _buildFadeTransition(description.properties, context);
        case 'ScaleTransition':
          return _buildScaleTransition(description.properties, context);
        case 'SlideTransition':
          return _buildSlideTransition(description.properties, context);
        case 'Stack':
          return _buildStack(description.properties, context);   
        case 'Positioned':
          return _buildPositioned(description.properties, context); 
        case 'GridView':
          return _buildGridView(description.properties, context);
        case 'Card': 
          return _buildCard(description.properties, context);
        case 'ElevatedButton':
          return _buildElevatedButton(description.properties, context);
        case 'RotatedBox':
          return _buildRotatedBox(description.properties, context);
        case 'FlatButton':
          return _buildTextButton(description.properties, context);
        case 'OutlineButton': 
          return _buildOutlinedButton(description.properties, context);  
        case 'IconButton': 
          return _buildIconButton(description.properties, context);
        case 'FloatingActionButton': 
          return _buildFloatingActionButton(description.properties, context);
        case 'TextButton': // Added missing widget
          return _buildTextButton(description.properties, context); // Added missing widget
        default:
          throw Exception('Unsupported widget type: ${description.type}');
      }
    } catch (e, stacktrace) {
      print('Error building widget ${description.type}: $e');
      print('Stacktrace: $stacktrace');
      return ErrorWidget('Failed to build widget: ${description.type}');
    }
  }

static Widget _buildText(Map<String, dynamic> properties, BuildContext context) {
    // Wrap widget building in try-catch
    try {
      TextStyle? style;
      if (properties.containsKey('color') || properties.containsKey('fontSize')) {
        style = TextStyle(
          color: _parseColor(properties['color']),
          fontSize: double.tryParse(properties['fontSize']?.toString() ?? ''),
          fontWeight: _parseFontWeight(properties['fontWeight']),
          fontFamily: properties['fontFamily'],
        );
      }

      String text = properties['text'] ?? '';
      return Text(text, style: style, key: properties['key'] != null ? Key(properties['key']) : null);
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Text widget: $e');
      return const Text('Error loading text', style: TextStyle(color: Colors.red));
    }
  }


  static FontWeight? _parseFontWeight(String? fontWeight) {
    switch (fontWeight?.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      case 'w500':
        return FontWeight.w500;
      default:
        return null;
    }
  }

  static Widget _buildContainer(Map<String, dynamic> properties, BuildContext context) {
      // Wrap widget building in try-catch
      try {
        Color? color = _parseColor(properties['color']);
        BoxDecoration? decoration;
        
        if (properties['decoration'] != null) {
          Map<String, dynamic> decorationProps = 
              Map<String, dynamic>.from(properties['decoration'] is String 
                  ? json.decode(properties['decoration']) 
                  : properties['decoration']);
          
          BorderRadius? borderRadiusValue;
          if (decorationProps['borderRadius'] is Map) {
            Map<String, dynamic> borderRadiusMap = Map<String, dynamic>.from(decorationProps['borderRadius']);
            borderRadiusValue = BorderRadius.only(
              topLeft: borderRadiusMap.containsKey('topLeft') 
                  ? Radius.circular(double.tryParse(borderRadiusMap['topLeft'].toString()) ?? 0.0) 
                  : Radius.zero,
              topRight: borderRadiusMap.containsKey('topRight') 
                  ? Radius.circular(double.tryParse(borderRadiusMap['topRight'].toString()) ?? 0.0) 
                  : Radius.zero,
              bottomLeft: borderRadiusMap.containsKey('bottomLeft') 
                  ? Radius.circular(double.tryParse(borderRadiusMap['bottomLeft'].toString()) ?? 0.0) 
                  : Radius.zero,
              bottomRight: borderRadiusMap.containsKey('bottomRight') 
                  ? Radius.circular(double.tryParse(borderRadiusMap['bottomRight'].toString()) ?? 0.0) 
                  : Radius.zero,
            );
          } else {
            double? borderRadius = double.tryParse(decorationProps['borderRadius']?.toString() ?? '');
            borderRadiusValue = borderRadius != null 
                ? BorderRadius.circular(borderRadius) 
                : null;
          }

          Color? decorationColor = _parseColor(decorationProps['color']);
          
          decoration = BoxDecoration(
            color: decorationColor ?? color,
            borderRadius: borderRadiusValue,
                // Start of Selection
                border: decorationProps['border'] != null 
                    ? Border.all(
                        color: _parseColor(decorationProps['border']['color']) ?? Colors.black,
                        width: double.tryParse(decorationProps['border']['width'].toString()) ?? 1.0,
                      )
                    : null,
              );
          
          // If decoration is specified, we use its color instead of the container's color property
          color = null;
        }

        return Container(
          key: properties['key'] != null ? Key(properties['key']) : null,
          alignment: _parseAlignment(properties['alignment']),
          padding: _parsePadding(properties['padding']),
          color: color,
          decoration: decoration,
          foregroundDecoration: properties['foregroundDecoration'] != null ? const BoxDecoration() : null, 
          width: properties['width'] != null ? double.tryParse(properties['width'].toString()) : null,
          height: properties['height'] != null ? double.tryParse(properties['height'].toString()) : null,
          constraints: properties['constraints'] != null ? const BoxConstraints() : null, 
          margin: _parsePadding(properties['margin']),
          transform: properties['transform'] != null ? Matrix4.identity() : null, 
          transformAlignment: _parseAlignment(properties['transformAlignment']),
          clipBehavior: properties['clipBehavior'] != null ? Clip.values.firstWhere((e) => e.toString() == 'Clip.${properties['clipBehavior']}') : Clip.none,
          child: properties['child'] != null
              ? build(WidgetDescription.fromJson(properties['child']), context)
              : null,
        );
      } catch (e) {
        print('Error building Container widget: $e');
        return const SizedBox.shrink(); 
      }
    }

    static Widget _buildSingleChildScrollView(Map<String, dynamic> properties, BuildContext context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
                try {
                    return SingleChildScrollView(
                        scrollDirection: _parseScrollDirection(properties['scrollDirection']),
                        reverse: properties['reverse'] ?? false,
                        padding: _parsePadding(properties['padding']),
                        clipBehavior: properties['clipBehavior'] != null 
                            ? Clip.values.firstWhere((e) => e.toString() == 'Clip.${properties['clipBehavior']}', orElse: () => Clip.none) 
                            : Clip.none,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.minHeight,
                                maxHeight: constraints.maxHeight,
                                minWidth: constraints.minWidth,
                                maxWidth: constraints.maxWidth,
                            ),
                            child: IntrinsicHeight(
                                child: properties['child'] != null 
                                    ? build(WidgetDescription.fromJson(properties['child']), context) 
                                    : Container(), // Provide an empty Container as a fallback
                            ),
                        ),
                    );
                } catch (e) {
                    print('Error building SingleChildScrollView: $e');
                    return Container(
                        color: Colors.grey, // Placeholder color
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: const Center(child: Text('Error loading content')),
                    );
                }
            },
        );
    }

static Widget _buildListView(Map<String, dynamic> properties, BuildContext context) {
  try {
    // Parse optional properties for ListView
    Axis scrollDirection = _parseScrollDirection(properties['scrollDirection']);
    bool reverse = properties['reverse'] ?? false;
    bool primary = properties['primary'] ?? false;
    bool shrinkWrap = properties['shrinkWrap'] ?? true;
    double? itemExtent = properties['itemExtent'] != null ? double.tryParse(properties['itemExtent'].toString()) : null;
    EdgeInsetsGeometry? padding = _parsePadding(properties['padding']);
    ScrollPhysics? physics = _parseScrollPhysics(properties['physics']);

    // List of supported widget types
    const List<String> supportedWidgetTypes = [
      'Container', 'Row', 'Column', 'Text', 'SizedBox', 'Icon', 'Divider',
      'ListTile', 'Card', 'Padding', 'Center', 'Align', 'Expanded', 'Flexible',
      'InkWell', 'GestureDetector', 'Image', 'CircleAvatar', 'Checkbox', 'Radio',
      'Switch', 'TextField', 'ElevatedButton', 'TextButton', 'OutlinedButton',
      'IconButton', 'Wrap', 'Stack', 'Positioned', 'AspectRatio', 'ConstrainedBox',
      'Opacity', 'Visibility', 'Placeholder', 'Spacer',
    ];

    // Helper function to validate and build widget descriptions
    Widget _safeBuild(dynamic widgetData) {
      if (widgetData is! Map<String, dynamic>) {
        print('Invalid widget data: Expected Map<String, dynamic>, got ${widgetData.runtimeType}');
        return const SizedBox.shrink();
      }
      try {
        String? type = widgetData['type'];
        if (type == null || !supportedWidgetTypes.contains(type)) {
          throw Exception("Invalid or unsupported widget type: $type");
        }
        return build(WidgetDescription.fromJson(widgetData), context);
      } catch (e) {
        print('Error building child widget: $e');
        return const SizedBox.shrink();
      }
    }

    // Build ListView with children
    if (properties['children'] is List) {
      List<Widget> children = (properties['children'] as List)
          .map((child) => _safeBuild(child))
          .toList();
      
      return ListView(
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        shrinkWrap: shrinkWrap,
        itemExtent: itemExtent,
        padding: padding,
        physics: physics,
        children: children,
      );
    }
    // Build ListView.builder
    else if (properties['itemBuilder'] is List && properties['itemCount'] is int) {
      List itemBuilderData = properties['itemBuilder'] as List;
      int itemCount = properties['itemCount'] as int;

      return ListView.builder(
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        shrinkWrap: shrinkWrap,
        itemExtent: itemExtent,
        padding: padding,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index < itemBuilderData.length) {
            return _safeBuild(itemBuilderData[index]);
          }
          return const SizedBox.shrink();
        },
      );
    }
    // Fallback to empty ListView
    else {
      print('Invalid or missing "children" or "itemBuilder" with "itemCount" for ListView.');
      return ListView();
    }
  } catch (e) {
    print('Error building ListView: $e');
    return const SizedBox.shrink();
  }
}


    static Widget _buildGridView(Map<String, dynamic> properties, BuildContext context) {
        try {
            // Parse common properties
            int crossAxisCount = int.tryParse(properties['crossAxisCount']?.toString() ?? '2') ?? 2;
            double mainAxisSpacing = double.tryParse(properties['mainAxisSpacing']?.toString() ?? '0') ?? 0;
            double crossAxisSpacing = double.tryParse(properties['crossAxisSpacing']?.toString() ?? '0') ?? 0;
            double childAspectRatio = double.tryParse(properties['childAspectRatio']?.toString() ?? '1') ?? 1;

            // Parse optional height and width properties
            double? height = double.tryParse(properties['height']?.toString() ?? '');
            double? width = double.tryParse(properties['width']?.toString() ?? '');

            // Determine if using GridView.builder or GridView.count
            Widget gridView;
            if (properties['itemCount'] != null) {
                gridView = GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                        childAspectRatio: childAspectRatio,
                    ),
                    scrollDirection: _parseScrollDirection(properties['scrollDirection']),
                    shrinkWrap: properties['shrinkWrap'] ?? false,
                    padding: _parsePadding(properties['padding']),
                    physics: _parseScrollPhysics(properties['physics']),
                    itemCount: properties['itemCount'],
                    itemBuilder: (context, index) {
                        return properties['children'] != null && index < properties['children'].length
                            ? build(WidgetDescription.fromJson(properties['children'][index]), context)
                            : const SizedBox.shrink();
                    },
                );
            } else {
                gridView = GridView.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: mainAxisSpacing,
                    crossAxisSpacing: crossAxisSpacing,
                    childAspectRatio: childAspectRatio,
                    children: _buildChildren(properties['children'], context),
                );
            }

            // Apply height and/or width constraints if provided
            if (height != null || width != null) {
                gridView = SizedBox(
                    height: height,
                    width: width,
                    child: gridView,
                );
            }

            return gridView;
        } catch (e) {
            // Return a placeholder in case of an error
            print('Error building GridView widget: $e');
            return const SizedBox.shrink(); // Fallback if the GridView fails to build
        }
    }

    static Widget _buildScrollController(Map<String, dynamic> properties, BuildContext context) {
        try {
            // Create a ScrollController
            final ScrollController controller = ScrollController(
                initialScrollOffset: properties['initialScrollOffset'] != null 
                    ? double.parse(properties['initialScrollOffset'].toString()) 
                    : 0.0,
                keepScrollOffset: properties['keepScrollOffset'] ?? true,
            );

            // If there's a child widget, wrap it with a ScrollController
            if (properties['child'] != null) {
                return PrimaryScrollController(
                    controller: controller,
                    child: build(WidgetDescription.fromJson(properties['child']), context),
                );
            } else {
                // If there's no child, return an empty container
                return Container();
            }
        } catch (e) {
            print('Error building ScrollController: $e');
            return const SizedBox.shrink();
        }
    }


    static Widget _buildScrollbar(Map<String, dynamic> properties, BuildContext context) {
        try {
            return Scrollbar(
                thickness: properties['thickness'] != null ? double.parse(properties['thickness'].toString()) : null,
                radius: properties['radius'] != null ? Radius.circular(double.parse(properties['radius'].toString())) : null,
                thumbVisibility: properties['thumbVisibility'] ?? false,
                child: properties['child'] != null 
                    ? build(WidgetDescription.fromJson(properties['child']), context) 
                    : const SizedBox.shrink(),
            );
        } catch (e) {
            print('Error building Scrollbar: $e');
            return const SizedBox.shrink();
        }
    }

    static Widget _buildScrollConfiguration(Map<String, dynamic> properties, BuildContext context) {
        try {
            return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                    physics: _parseScrollPhysics(properties['physics']),
                    dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                    },
                ),
                child: properties['child'] != null 
                    ? build(WidgetDescription.fromJson(properties['child']), context) 
                    : const SizedBox.shrink(),
            );
        } catch (e) {
            print('Error building ScrollConfiguration: $e');
            return const SizedBox.shrink();
        }
    }

    static Widget _buildScrollNotification(Map<String, dynamic> properties, BuildContext context) {
        try {
            return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                    // Handle scroll notification here
                    print('Scroll notification: ${notification.metrics}');
                    return true;
                },
                child: properties['child'] != null 
                    ? build(WidgetDescription.fromJson(properties['child']), context) 
                    : const SizedBox.shrink(),
            );
        } catch (e) {
            print('Error building ScrollNotification: $e');
            return const SizedBox.shrink();
        }
    }


    static Widget _buildCustomScrollView(Map<String, dynamic> properties, BuildContext context) {
        try {
            return CustomScrollView(
                scrollDirection: _parseScrollDirection(properties['scrollDirection']),
                reverse: properties['reverse'] ?? false,
                shrinkWrap: properties['shrinkWrap'] ?? false,
                slivers: properties['slivers'] != null 
                    ? (properties['slivers'] as List).map<Widget>((sliver) {
                        return build(WidgetDescription.fromJson(sliver), context);
                    }).toList() 
                    : [],
            );
        } catch (e) {
            print('Error building CustomScrollView: $e');
            return const SizedBox.shrink();
        }
    }

    static Widget _buildScrollable(Map<String, dynamic> properties, BuildContext context) {
        try {
            return Scrollable(
                axisDirection: _parseAxisDirection(properties['axisDirection']),
                physics: _parseScrollPhysics(properties['physics']),
                viewportBuilder: (context, offset) {
                    return properties['child'] != null 
                        ? build(WidgetDescription.fromJson(properties['child']), context) 
                        : const SizedBox.shrink();
                },
            );
        } catch (e) {
            print('Error building Scrollable: $e');
            return const SizedBox.shrink();
        }
    }

    static Axis _parseScrollDirection(String? direction) {
        switch (direction?.toLowerCase()) {
            case 'horizontal':
                return Axis.horizontal;
            case 'vertical':
            default:
                return Axis.vertical;
        }
    }

    static ScrollPhysics _parseScrollPhysics(dynamic physics) {
        if (physics is String) {
            switch (physics.toLowerCase()) {
                case 'bouncing':
                    return const BouncingScrollPhysics();
                case 'clamping':
                    return const ClampingScrollPhysics();
                case 'alwaysscrollable':
                    return const AlwaysScrollableScrollPhysics();
                case 'neverscrollable':
                    return const NeverScrollableScrollPhysics();
                default:
                    return const ScrollPhysics();
            }
        } else if (physics is ScrollPhysics) {
            return physics;
        }
        // Return default ScrollPhysics if the input is not recognized
        return const ScrollPhysics();
    }

    static SliverGridDelegate _parseGridDelegate(dynamic gridDelegate) {
        // Implement parsing logic for GridDelegate
        return const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2); // Placeholder
    }

    static AxisDirection _parseAxisDirection(String? direction) {
        switch (direction?.toLowerCase()) {
            case 'up':
                return AxisDirection.up;
            case 'down':
                return AxisDirection.down;
            case 'left':
                return AxisDirection.left;
            case 'right':
                return AxisDirection.right;
            default:
                return AxisDirection.down;
        }
    }




  static Widget _buildBody(Map<String, dynamic> properties, BuildContext context) {
    try {
      final color = _parseColor(properties['backgroundColor']) ?? Colors.white;
      final padding = _parsePadding(properties['padding']) ?? const EdgeInsets.all(16.0);
      final margin = _parsePadding(properties['margin']);
      final width = properties['width'] != null ? double.tryParse(properties['width'].toString()) : null;
      final height = properties['height'] != null ? double.tryParse(properties['height'].toString()) : null;
      final constraints = properties['constraints'] != null ? _parseBoxConstraints(properties['constraints']) : null;
      final alignment = _parseAlignment(properties['alignment']);
      final key = properties['key'] != null ? Key(properties['key']) : null;

      Widget content;

      if (properties['children'] != null && properties['children'] is List) {
        final children = _buildChildren(properties['children'], context);
        content = Column(
          children: children,
        );
      } else if (properties['child'] != null) {
        content = build(WidgetDescription.fromJson(properties['child']), context);
      } else {
        content = const SizedBox.shrink();
      }

      // Avvolgi il contenuto in un SingleChildScrollView per rendere possibile lo swipe
      // indipendentemente dalla dimensione del contenuto.
      Widget scrollableContent = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Importante per far funzionare il pull-to-refresh anche se il contenuto non riempie lo schermo
        child: Container(
          key: key,
          color: color,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          constraints: constraints,
          alignment: alignment,
          child: content,
        ),
      );

      // Qui avvolgiamo il contenuto scrollabile con il RefreshIndicator.
      return RefreshIndicator(
        onRefresh: () async {
          String? currentRouteName = ModalRoute.of(context)?.settings.name;
          if (currentRouteName != null) {
            Navigator.pushReplacementNamed(context, currentRouteName);
          }

          // Potresti voler aggiungere un piccolo ritardo o una logica per indicare che il refresh è completo
          // se l'ActionHandler non fornisce un feedback visivo immediato.
          // Ad esempio: await Future.delayed(const Duration(milliseconds: 500));
        },
        child: scrollableContent,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Error building Body widget with RefreshIndicator: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
      return ErrorWidget('Failed to build body: $e');
    }
  }


    static BoxConstraints _parseBoxConstraints(dynamic constraints) {
      if (constraints is Map<String, dynamic>) {
        double? minWidth = constraints['minWidth'] != null ? double.tryParse(constraints['minWidth'].toString()) : null;
        double? maxWidth = constraints['maxWidth'] != null ? double.tryParse(constraints['maxWidth'].toString()) : null;
        double? minHeight = constraints['minHeight'] != null ? double.tryParse(constraints['minHeight'].toString()) : null;
        double? maxHeight = constraints['maxHeight'] != null ? double.tryParse(constraints['maxHeight'].toString()) : null;

        return BoxConstraints(
          minWidth: minWidth ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          minHeight: minHeight ?? 0,
          maxHeight: maxHeight ?? double.infinity,
        );
      }
      // Return default constraints if the input is not a valid map
      return const BoxConstraints();
    }


    static Widget _buildColumn(Map<String, dynamic> properties, BuildContext context) {
    // Wrap widget building in try-catch
    try {
      return Column(
        children: _buildChildren(properties['children'], context),
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Column widget: $e');
      return const SizedBox.shrink(); // Fallback if the Column fails to build
    }
  }


static Widget _buildImage(Map<String, dynamic> properties, BuildContext context) {
  // Wrap widget building in try-catch
  try {
    final String? imageUrl = properties['url'];
    
    // Ensure the URL is provided and starts with 'http'
    if (imageUrl == null || !imageUrl.startsWith('http')) {
      throw Exception("Invalid image URL. It must start with 'http'.");
    }

    return Image.network(
      imageUrl,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        return const SizedBox.shrink(); // Fallback if the image fails to load
      },
    );
  } catch (e) {
    // Return a placeholder in case of an error
    print('Error building Image widget: $e');
    return const SizedBox.shrink(); // Fallback if the Image fails to build
  }
}


static Widget _buildRow(Map<String, dynamic> properties, BuildContext context) {
  try {
    return Row(
      crossAxisAlignment: _parseCrossAxisAlignment(properties['crossAxisAlignment']),
      mainAxisAlignment: _parseMainAxisAlignment(properties['mainAxisAlignment']),
      mainAxisSize: _parseMainAxisSize(properties['mainAxisSize']),
      children: properties['children'] != null
          ? _buildChildren(properties['children'], context)
          : [], // Ensure children is not null
    );
  } catch (e) {
    // Return a placeholder in case of an error
    print('Error building Row widget: $e');
    return const SizedBox.shrink(); // Fallback if the Row fails to build
  }
}

 static Widget _buildStack(Map<String, dynamic> properties, BuildContext context) {
  try {
    // Handle the 'alignment' property
    Alignment alignment = _parseAlignment(properties['alignment']);
    
    // Handle the 'fit' property for StackFit
    StackFit fit = _parseStackFit(properties['fit']);
    
    // Handle the 'overflow' property for Overflow.clip or Overflow.visible
    Clip clipBehavior = _parseClipBehavior(properties['overflow']);
    
    // Build the Stack widget with refined rules
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: _buildChildren(properties['children'], context),
    );
  } catch (e) {
    // Return a placeholder in case of an error
    print('Error building Stack widget: $e');
    return const SizedBox.shrink(); // Fallback if the Stack fails to build
  }
}

  static Widget _buildListTile(Map<String, dynamic> properties, BuildContext context) {
    try {
      return ListTile(
        leading: properties['leading'] != null
            ? Icon(_parseIconData(properties['leading']))
            : null,
        title: properties['title'] != null
            ? Text(properties['title'])
            : const Text('No Title'),
        subtitle: properties['subtitle'] != null
            ? Text(properties['subtitle'])
            : null,
        trailing: properties['trailing'] != null
            ? Icon(_parseIconData(properties['trailing']))
            : null,
        onTap: properties['onTap'] != null
            ? () {
                try {
                  properties['onTap']();
                } catch (e) {
                  print('Error handling ListTile tap: $e');
                }
              }
            : null,
        enabled: properties['enabled'] ?? true,
        selected: properties['selected'] ?? false,
      );
    } catch (e) {
      print('Error building ListTile: $e');
      return const SizedBox.shrink(); // Fallback if the ListTile fails to build
    }
  }

  static Widget _buildCheckboxListTile(Map<String, dynamic> properties, BuildContext context) {
    try {
      return CheckboxListTile(
        value: properties['value'] ?? false,
        onChanged: properties['onChanged'] != null
            ? (bool? newValue) {
                try {
                  properties['onChanged'](newValue);
                } catch (e) {
                  print('Error handling CheckboxListTile change: $e');
                }
              }
            : null,
        activeColor: _parseColor(properties['activeColor']) ?? Colors.blue,
        checkColor: _parseColor(properties['checkColor']) ?? Colors.white,
        title: properties['title'] != null
            ? Text(properties['title'])
            : const Text('No Title'),
        subtitle: properties['subtitle'] != null
            ? Text(properties['subtitle'])
            : null,
        secondary: properties['secondary'] != null
            ? Icon(_parseIconData(properties['secondary']))
            : null,
      );
    } catch (e) {
      print('Error building CheckboxListTile: $e');
      return const SizedBox.shrink(); // Fallback if the CheckboxListTile fails to build
    }
  }

  static Widget _buildRadioListTile(Map<String, dynamic> properties, BuildContext context) {
    try {
      return RadioListTile(
        value: properties['value'],
        groupValue: properties['groupValue'],
        onChanged: properties['onChanged'] != null
            ? (dynamic newValue) {
                try {
                  properties['onChanged'](newValue);
                } catch (e) {
                  print('Error handling RadioListTile change: $e');
                }
              }
            : null,
        activeColor: _parseColor(properties['activeColor']) ?? Colors.blue,
        title: properties['title'] != null
            ? Text(properties['title'])
            : const Text('No Title'),
        subtitle: properties['subtitle'] != null
            ? Text(properties['subtitle'])
            : null,
      );
    } catch (e) {
      print('Error building RadioListTile: $e');
      return const SizedBox.shrink(); // Fallback if the RadioListTile fails to build
    }
  }



  static Widget _buildSwitchListTile(Map<String, dynamic> properties, BuildContext context) {
    try {
      return SwitchListTile(
        value: properties['value'] ?? false,
        onChanged: properties['onChanged'] != null
            ? (bool newValue) {
                try {
                  properties['onChanged'](newValue);
                } catch (e) {
                  print('Error handling SwitchListTile change: $e');
                }
              }
            : (value) {
                print('onChanged callback is not provided for SwitchListTile');
              },
        activeColor: _parseColor(properties['activeColor']) ?? Colors.blue,
        title: properties['title'] != null
            ? Text(properties['title'])
            : const Text('No Title'),
        subtitle: properties['subtitle'] != null
            ? Text(properties['subtitle'])
            : null,
        secondary: properties['secondary'] != null
            ? Icon(_parseIconData(properties['secondary']))
            : null,
      );
    } catch (e) {
      print('Error building SwitchListTile: $e');
      return const SizedBox.shrink(); // Fallback if the SwitchListTile fails to build
    }
  }

  static Widget _buildForm(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Form(
        key: properties['key'],
        autovalidateMode: properties['autovalidateMode'] ?? AutovalidateMode.disabled,
        onWillPop: properties['onWillPop'],
        child: properties['child'] ?? const SizedBox.shrink(),
      );
    } catch (e) {
      print('Error building Form: $e');
      return const SizedBox.shrink(); // Fallback if the Form fails to build
    }
  }

  static Widget _buildTextFormField(Map<String, dynamic> properties, BuildContext context) {
    try {
      return TextFormField(
        controller: properties['controller'],
        initialValue: properties['initialValue'],
        decoration: properties['decoration'] ?? const InputDecoration(),
        keyboardType: properties['keyboardType'],
        textInputAction: properties['textInputAction'],
        onFieldSubmitted: properties['onFieldSubmitted'] != null
            ? (String value) {
                try {
                  properties['onFieldSubmitted'](value);
                } catch (e) {
                  print('Error handling field submission: $e');
                }
              }
            : null,
      );
    } catch (e) {
      print('Error building TextFormField: $e');
      return const SizedBox.shrink(); // Fallback if the TextFormField fails to build
    }
  }




  static Widget _buildSnackBar(Map<String, dynamic> properties, BuildContext context) {
    try {
      final content = properties['content'] ?? const Text('No Content');
      final duration = properties['duration'] != null
          ? Duration(milliseconds: properties['duration'])
          : const Duration(seconds: 4);
      final action = properties['action'] != null
          ? SnackBarAction(
              label: properties['action']['label'] ?? 'Action',
              onPressed: () {
                try {
                  properties['action']['onPressed']();
                } catch (e) {
                  print('Error handling SnackBar action: $e');
                }
              },
            )
          : null;
      final backgroundColor = _parseColor(properties['backgroundColor']) ?? Colors.black;
      final behavior = properties['behavior'] ?? SnackBarBehavior.fixed;
      final shape = properties['shape'] ?? const RoundedRectangleBorder();

      return SnackBar(
        content: content,
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: behavior,
        shape: shape,
      );
    } catch (e) {
      print('Error building SnackBar: $e');
      return const SizedBox.shrink(); // Fallback if the SnackBar fails to build
    }
  }

  static Widget _buildBottomSheet(Map<String, dynamic> properties, BuildContext context) {
    try {
      final builder = properties['builder'] ?? (context) => const SizedBox.shrink();
      final backgroundColor = _parseColor(properties['backgroundColor']) ?? Colors.white;
      final elevation = properties['elevation'] ?? 0.0;
      final shape = properties['shape'] ?? const RoundedRectangleBorder();
      final clipBehavior = properties['clipBehavior'] ?? Clip.antiAlias;

      return BottomSheet(
        onClosing: properties['onClosing'],
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
      );
    } catch (e) {
      print('Error building BottomSheet: $e');
      return const SizedBox.shrink(); // Fallback if the BottomSheet fails to build
    }
  }

  static Widget _buildTabBar(Map<String, dynamic> properties, BuildContext context) {
    try {
      final tabs = properties['tabs'] ?? <Widget>[];
      final controller = properties['controller'];
      final isScrollable = properties['isScrollable'] ?? false;
      final indicator = properties['indicator'] ?? const BoxDecoration();
      final labelColor = _parseColor(properties['labelColor']) ?? Colors.blue;
      final unselectedLabelColor = _parseColor(properties['unselectedLabelColor']) ?? Colors.grey;

      return TabBar(
        tabs: tabs,
        controller: controller,
        isScrollable: isScrollable,
        indicator: indicator,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
      );
    } catch (e) {
      print('Error building TabBar: $e');
      return const SizedBox.shrink(); // Fallback if the TabBar fails to build
    }
  }

  

  static Widget _buildTabBarView(Map<String, dynamic> properties, BuildContext context) {
    try {
      final controller = properties['controller'];
      final children = properties['children'] ?? <Widget>[];
      final physics = properties['physics'] ?? const NeverScrollableScrollPhysics();

      if (controller != null && children.length == controller.length) {
        return TabBarView(
          controller: controller,
          children: children,
          physics: physics,
        );
      } else {
        print('Error: Controller and children count mismatch or controller is null.');
        return const SizedBox.shrink(); // Fallback if the TabBarView fails to build
      }
    } catch (e) {
      print('Error building TabBarView: $e');
      return const SizedBox.shrink(); // Fallback if the TabBarView fails to build
    }
  }

    // Start Generation Here
        // Start of Selection
  static Widget _buildElevatedButton(Map<String, dynamic> properties, BuildContext context) {
    try {
      // 1. Parse delle proprietà base con valori di default
      final String text = properties['text']?.toString() ?? 'Button';
      final Color backgroundColor = _parseColor(properties['backgroundColor']) ?? Theme.of(context).primaryColor;
      final Color textColor = _parseColor(properties['textColor']) ?? Colors.white;
      final double fontSize = double.tryParse(properties['fontSize']?.toString() ?? '14') ?? 14;
      final double borderRadius = double.tryParse(properties['borderRadius']?.toString() ?? '8') ?? 8;
      final double elevation = double.tryParse(properties['elevation']?.toString() ?? '2') ?? 2;
      final EdgeInsetsGeometry padding = _parsePadding(properties['padding']) ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

      // 2. Gestione più robusta dell'azione
      WidgetAction? action;
      Map<String, dynamic>? actionParams;

      final onPressedValue = properties['onPressed'];
      if (onPressedValue is String) {
        action = _mapStringToWidgetAction(onPressedValue);
      } else if (onPressedValue is Map) {
        // Se onPressed è già una mappa (caso raro)
        actionParams = Map<String, dynamic>.from(onPressedValue);
      }

      // 3. Parsing avanzato degli actionParams
      final rawActionParams = properties['actionParams'];
      if (rawActionParams != null) {
        if (rawActionParams is Map) {
          actionParams = Map<String, dynamic>.from(rawActionParams);
        } else if (rawActionParams is String) {
          try {
            actionParams = jsonDecode(rawActionParams) as Map<String, dynamic>;
          } catch (e) {
            debugPrint('Failed to parse actionParams JSON: $e');
            actionParams = {'rawValue': rawActionParams};
          }
        }
      }

      print('Executing onPressed function for TextButton: $action + $actionParams');
      // 4. Costruzione del bottone
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: action != null
            ? () => ActionHandler(context).handleAction(action!, actionParams)
            : null,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error building ElevatedButton: $e');
      debugPrintStack(stackTrace: stackTrace);
      return ElevatedButton(
        onPressed: null,
        child: const Text('Error', style: TextStyle(color: Colors.red)),
      );
    }
  }




    static Widget _buildTextButton(Map<String, dynamic> properties, BuildContext context) {
      try {
        // Validate properties
        if (properties == null) {
          print('Error: properties map is null for TextButton');
          return const SizedBox.shrink();
        }

        // Extract properties with default values
        final onPressedString = properties['onPressed'];
        if (onPressedString == null || !(onPressedString is String)) {
          print('Error: onPressed is missing or is not a string for TextButton');
          return const SizedBox.shrink();
        }

        final text = properties['text'] ?? 'TextButton';
        final textColor = _parseColor(properties['textColor']) ?? Colors.blue;
        final fontSize = double.tryParse(properties['fontSize']?.toString() ?? '16') ?? 16;

        // Parse action parameters
        final actionParams = properties['actionParams'] as Map<String, dynamic>?;

        // Convert the onPressed string to a WidgetAction
        WidgetAction? action;
        try {
          action = WidgetAction.values.firstWhere(
            (e) => e.toString().split('.').last == onPressedString,
          );
        } catch (e) {
          print('Unsupported action "$onPressedString" for TextButton');
          action = null;
        }

        // Initialize the ActionHandler
        final actionHandler = ActionHandler(context);

        return TextButton(
          onPressed: () {
            try {
              if (action != null) {
                actionHandler.handleAction(action, actionParams);
              }
            } catch (e) {
              print('Error executing onPressed function for TextButton: $e');
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: textColor,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        );
      } catch (e) {
        print('Error building TextButton: $e');
        return const SizedBox.shrink();
      }
    }




    static Widget _buildOutlinedButton(Map<String, dynamic> properties, BuildContext context) {
      try {
        // Validate properties
        if (properties == null) {
          print('Error: properties map is null for OutlinedButton');
          return const SizedBox.shrink();
        }

        // Extract properties with default values
        final onPressedString = properties['onPressed'];
        if (onPressedString == null || !(onPressedString is String)) {
          print('Error: onPressed is missing or is not a string for OutlinedButton');
          return const SizedBox.shrink();
        }

        final text = properties['text'] ?? 'OutlinedButton';
        final textColor = _parseColor(properties['textColor']) ?? Colors.blue;
        final borderColor = _parseColor(properties['borderColor']) ?? Colors.blue;
        final fontSize = double.tryParse(properties['fontSize']?.toString() ?? '16') ?? 16;
        final borderWidth = double.tryParse(properties['borderWidth']?.toString() ?? '1') ?? 1;

        // Parse action parameters
        final actionParams = properties['actionParams'] as Map<String, dynamic>?;

         // Convert the onPressed string to a WidgetAction
        WidgetAction? action;
        try {
          action = WidgetAction.values.firstWhere(
            (e) => e.toString().split('.').last == onPressedString,
          );
        } catch (e) {
          print('Unsupported action "$onPressedString" for OutlinedButton');
          action = null;
        }

        // Initialize the ActionHandler
        final actionHandler = ActionHandler(context);

        return OutlinedButton(
          onPressed: () {
            try {
              if (action != null) { // Check if action is not null
                actionHandler.handleAction(action, actionParams);
              }
            } catch (e) {
              print('Error executing onPressed function for OutlinedButton: $e');
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor, side: BorderSide(color: borderColor, width: borderWidth),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        );
      } catch (e) {
        print('Error building OutlinedButton: $e');
        return const SizedBox.shrink();
      }
    }


  static Widget _buildIconButton(Map<String, dynamic> properties, BuildContext context) {
    if (kDebugMode) {
      print('DEBUG _buildIconButton: Inizio costruzione con proprietà: $properties');
    }
    try {
      // Validate properties
      if (properties == null) { // Questo check è ridondante se il parametro è Map<String, dynamic>
        if (kDebugMode) print('ERRORE _buildIconButton: properties map is null for IconButton.');
        return const SizedBox.shrink();
      }

      // Extract properties
      final onPressedString = properties['onPressed'];
      // Reso più robusto: se onPressedString non è una stringa, stampa errore e ritorna SizedBox.shrink.
      // Questo è il comportamento che avevi e che genera l'errore se onPressed è mancante nell'XML.
      if (onPressedString == null || !(onPressedString is String)) {
        if (kDebugMode) print('ERRORE _buildIconButton: onPressed is missing or is not a string for IconButton.');
        return const SizedBox.shrink();
      }

      final iconName = properties['icon'];
      if (iconName == null || !(iconName is String)) {
        if (kDebugMode) print('ERRORE _buildIconButton: icon is missing or is not a string for IconButton.');
        return const SizedBox.shrink();
      }

      // Qui cerchi 'iconColor'. Assicurati che l'XML per IconButton usi 'iconColor' e non 'color'.
      final iconColor = _parseColor(properties['iconColor'] as String?) ?? Colors.black;
      final size = double.tryParse(properties['size']?.toString() ?? '24') ?? 24;

      // --- CORREZIONE QUI: Parsare la stringa JSON per actionParams ---
      Map<String, dynamic>? actionParams;
      final dynamic rawActionParams = properties['actionParams'];

      if (rawActionParams != null) {
        if (rawActionParams is String) {
          try {
            actionParams = json.decode(rawActionParams) as Map<String, dynamic>;
            if (kDebugMode) print('DEBUG _buildIconButton: actionParams parsati correttamente: $actionParams');
          } catch (e) {
            if (kDebugMode) print('ERRORE _buildIconButton: Impossibile parsare actionParams come JSON: "$rawActionParams" - $e');
            actionParams = null; // Imposta a null se il parsing fallisce
          }
        } else if (rawActionParams is Map<String, dynamic>) {
          // Questo caso si applica se actionParams è già una Map (es. in debug/test diretti)
          actionParams = rawActionParams;
        } else {
          if (kDebugMode) print('WARNING _buildIconButton: actionParams ha un tipo inatteso: ${rawActionParams.runtimeType}');
        }
      }


      // Convert the onPressed string to a WidgetAction
      WidgetAction? action;
      try {
        action = WidgetAction.values.firstWhere(
              (e) => e.toString().split('.').last == onPressedString,
        );
        if (kDebugMode) print('DEBUG _buildIconButton: Azione parsata: $action');
      } catch (e) {
        if (kDebugMode) print('WARNING _buildIconButton: Unsupported action "$onPressedString" for IconButton. $e');
        action = null; // L'azione non è stata trovata nell'enum
      }

      // Initialize the ActionHandler
      final actionHandler = ActionHandler(context);

      // Parse IconData
      final IconData iconData;
      try {
        iconData = _parseIconData(iconName as String); // Cast a String è più sicuro qui
        if (kDebugMode) print('DEBUG _buildIconButton: IconData ottenuta: $iconData da "$iconName"');
      } catch (e, st) {
        if (kDebugMode) {
          print('ERRORE _buildIconButton: Errore nel parsing IconData per "$iconName": $e');
          print(st);
        }
        return const Icon(Icons.error); // Icona di errore visibile
      }

      return IconButton(
        icon: Icon(iconData, color: iconColor, size: size),
        // L'onPressed rimane una funzione anonima che gestisce l'azione parsata.
        onPressed: () {
          try {
            if (action != null) {
              actionHandler.handleAction(action, actionParams);
            } else {
              if (kDebugMode) print('DEBUG _buildIconButton: Nessuna azione valida per onPressed, non eseguito.');
            }
          } catch (e, st) {
            if (kDebugMode) {
              print('ERRORE _buildIconButton: Errore durante esecuzione onPressed function per IconButton: $e');
              print(st);
            }
          }
        },
      );
    } catch (e, st) {
      // Questo catch generale cattura errori inaspettati nella costruzione del pulsante.
      if (kDebugMode) {
        print('!!! ERRORE CRITICO _buildIconButton: Errore generale nella costruzione di IconButton: $e');
        print(st);
      }
      return const SizedBox.shrink(); // Ritorna un widget vuoto in caso di errore critico
    } finally {
      if (kDebugMode) print('DEBUG _buildIconButton: Fine costruzione IconButton.');
    }
  }


    static Widget _buildFloatingActionButton(Map<String, dynamic> properties, BuildContext context) {
      try {
        // Validate properties
        if (properties == null) {
          print('Error: properties map is null for FloatingActionButton');
          return const SizedBox.shrink();
        }

        // Extract properties
        final onPressedString = properties['onPressed'];
        if (onPressedString == null || !(onPressedString is String)) {
          print('Error: onPressed is missing or is not a string for FloatingActionButton');
          return const SizedBox.shrink();
        }

        final backgroundColor = _parseColor(properties['backgroundColor']) ?? Colors.blue;
        final foregroundColor = _parseColor(properties['foregroundColor']) ?? Colors.white;
        final tooltip = properties['tooltip']?.toString() ?? '';
        final elevation = double.tryParse(properties['elevation']?.toString() ?? '6') ?? 6;
        final hoverElevation = double.tryParse(properties['hoverElevation']?.toString() ?? '8') ?? 8;
        final shape = properties['shape'] != null ? _parseShape(properties['shape']) : const CircleBorder();
        final mini = properties['mini'] ?? false;

        // Parse action parameters
        final actionParams = properties['actionParams'] as Map<String, dynamic>?;

        // Convert the onPressed string to a WidgetAction


         // Convert the onPressed string to a WidgetAction
        WidgetAction? action;
        try {
          action = WidgetAction.values.firstWhere(
            (e) => e.toString().split('.').last == onPressedString,
          );
        } catch (e) {
          print('Unsupported action "$onPressedString" for FloatingActionButton');
          action = null;
        }
        // final action = WidgetAction.values.firstWhere(
        //   (e) => e.toString().split('.').last == onPressedString,
        //   orElse: () {
        //     print('Unsupported action "$onPressedString" for FloatingActionButton');
        //     return WidgetAction.none; // Assuming 'none' is a valid fallback
        //   },
        // );

        // Initialize the ActionHandler
        final actionHandler = ActionHandler(context);

        // Parse child widget
        Widget child;
        if (properties['child'] != null) {
          child = build(WidgetDescription.fromJson(properties['child']), context);
        } else {
          // Parse icon if provided, otherwise use default
          final iconName = properties['icon'] as String?;
          final IconData iconData = iconName != null 
              ? _parseIconData(iconName) 
              : Icons.add;
          child = Icon(iconData, color: foregroundColor);
        }

        return FloatingActionButton(
          onPressed: () {
            try {
              if (action != null) {
                actionHandler.handleAction(action, actionParams);
              }
            } catch (e) {
              print('Error executing onPressed function for FloatingActionButton: $e');
            }
          },
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          tooltip: tooltip,
          elevation: elevation,
          hoverElevation: hoverElevation,
          shape: shape,
          mini: mini,
          child: child,
        );
      } catch (e) {
        print('Error building FloatingActionButton: $e');
        return const SizedBox.shrink();
      }
    }

    static IconData _parseIconData(String iconName) {
      switch (iconName) {
        case 'Icons.favorite':
      return Icons.favorite;
    case 'Icons.add':
      return Icons.add;
    case 'Icons.delete':
      return Icons.delete;
    case 'Icons.edit':
      return Icons.edit;
    case 'Icons.share':
      return Icons.share;
    case 'Icons.home':
      return Icons.home;
    case 'Icons.settings':
      return Icons.settings;
    case 'Icons.person':
      return Icons.person;

    case 'Icons.bot':
      return Icons.person;
    case 'Icons.notifications':
      return Icons.notifications;
    case 'Icons.search':
      return Icons.search;
    case 'Icons.camera':
      return Icons.camera;
    case 'Icons.location_on':
      return Icons.location_on;
    case 'Icons.message':
      return Icons.message;
    case 'Icons.video_call':
      return Icons.video_call;
    case 'Icons.shopping_cart':
      return Icons.shopping_cart;
    case 'Icons.favorite_border':
      return Icons.favorite_border;
    case 'Icons.access_alarm':
      return Icons.access_alarm;
    case 'Icons.accessibility':
      return Icons.accessibility;
    case 'Icons.account_circle':
      return Icons.account_circle;
    case 'Icons.arrow_back':
      return Icons.arrow_back;
    case 'Icons.arrow_forward':
      return Icons.arrow_forward;
    case 'Icons.brightness_6':
      return Icons.brightness_6;
    case 'Icons.camera_alt':
      return Icons.camera_alt;
    case 'Icons.chat':
      return Icons.chat;
    case 'Icons.check_circle':
      return Icons.check_circle;
    case 'Icons.clear':
      return Icons.clear;
    case 'Icons.cloud':
      return Icons.cloud;
    case 'Icons.date_range':
      return Icons.date_range;
    case 'Icons.directions':
      return Icons.directions;
    case 'Icons.edit_location':
      return Icons.edit_location;
    case 'Icons.favorite_outline':
      return Icons.favorite_outline;
    case 'Icons.file_copy':
      return Icons.file_copy;
    case 'Icons.folder':
      return Icons.folder;
    case 'Icons.group':
      return Icons.group;
    case 'Icons.help':
      return Icons.help;
    case 'Icons.info':
      return Icons.info;
    case 'Icons.lock':
      return Icons.lock;
    case 'Icons.lock_open':
      return Icons.lock_open;
    case 'Icons.map':
      return Icons.map;
    case 'Icons.more_horiz':
      return Icons.more_horiz;
    case 'Icons.more_vert':
      return Icons.more_vert;
    case 'Icons.notifications_active':
      return Icons.notifications_active;
    case 'Icons.palette':
      return Icons.palette;
    case 'Icons.phone':
      return Icons.phone;
    case 'Icons.print':
      return Icons.print;
    case 'Icons.public':
      return Icons.public;
    case 'Icons.refresh':
      return Icons.refresh;
    case 'Icons.save':
      return Icons.save;
    case 'Icons.share_location':
      return Icons.share_location;
    case 'Icons.star':
      return Icons.star;
    case 'Icons.star_border':
      return Icons.star_border;
    case 'Icons.thumb_up':
      return Icons.thumb_up;
    case 'Icons.visibility':
      return Icons.visibility;
    case 'Icons.visibility_off':
      return Icons.visibility_off;


        default:
          print('Unrecognized icon name "$iconName", defaulting to Icons.error');
          return Icons.error;
      }
    }

    static ShapeBorder _parseShape(String shapeString) {
      switch (shapeString.toLowerCase()) {
        case 'circle':
          return const CircleBorder();
        case 'roundedrectangle':
          double radius = double.tryParse(shapeString.split('_').last) ?? 8.0;
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          );
        default:
          print('Unrecognized shape "$shapeString", defaulting to CircleBorder');
          return const CircleBorder();
      }
    }


static Widget _buildChild(Map<String, dynamic> childProperties, BuildContext context) {
  if (childProperties.isEmpty) {
    return const SizedBox.shrink(); // Return an empty widget if properties are null
  }

  final String type = childProperties['type'];

  switch (type) {
    case 'Icon':
      return _buildIcon(childProperties, context);
    case 'Text':
      return _buildText(childProperties, context);
    case 'Padding':
      return _buildPadding(childProperties, context);
    case 'Center':
      return _buildCenter(childProperties, context);
    case 'Container':
      return _buildContainer(childProperties, context);
    case 'Column':
      return _buildColumn(childProperties, context);
    case 'Row':
      return _buildRow(childProperties, context);
    case 'Stack':
      return _buildStack(childProperties, context);
    case 'Positioned':
      return _buildPositioned(childProperties, context);
    case 'GridView':
      return _buildGridView(childProperties, context);
    case 'SingleChildScrollView':
      return _buildSingleChildScrollView(childProperties, context);
    case 'Scaffold':
      return _buildScaffold(childProperties, context);
    case 'appBar':
      return _buildAppBar(childProperties, context);
    default:
      return const Icon(Icons.error); // Return an error icon for unsupported child types
  }
}

// Mapping string to WidgetAction enum
static WidgetAction? _mapStringToWidgetAction(String actionString) {
  switch (actionString.toLowerCase()) {
    case 'showalert':
      return WidgetAction.showAlert;
    case 'navigate':
      return WidgetAction.navigate;
    case 'updatestate':
      return WidgetAction.updateState;
    case 'printmessage':
      return WidgetAction.printMessage;
    case 'logevent':
      return WidgetAction.logEvent;
    case 'togglevisibility':
      return WidgetAction.toggleVisibility;
    case 'openurl':
      return WidgetAction.openURL;
    case 'sharecontent':
      return WidgetAction.shareContent;
    case 'copytoclipboard':
      return WidgetAction.copyToClipboard;
    case 'scanqrcode':
      return WidgetAction.scanQRCode;
    case 'pickimage':
      return WidgetAction.pickImage;
    case 'sendemail':
      return WidgetAction.sendEmail;
    case 'makephonecall':
      return WidgetAction.makePhoneCall;
    case 'showsnackbar':
      return WidgetAction.showSnackBar;
    case 'launchmap':
      return WidgetAction.launchMap;
    case 'openwebview':
      return WidgetAction.openWebView;
    case 'refreshdata':
      return WidgetAction.refreshData;
    case 'submitform':
      return WidgetAction.submitForm;
    case 'validateinput':
      return WidgetAction.validateInput;
    case 'showdatepicker':
      return WidgetAction.showDatePicker;
    case 'showtimepicker':
      return WidgetAction.showTimePicker;
    case 'toggletheme':
      return WidgetAction.toggleTheme;
    case 'togglelanguage':
      return WidgetAction.toggleLanguage;
    case 'downloadfile':
      return WidgetAction.downloadFile;
    case 'uploadfile':
      return WidgetAction.uploadFile;
    case 'starttimer':
      return WidgetAction.startTimer;
    case 'stoptimer':
      return WidgetAction.stopTimer;
    case 'resettimer':
      return WidgetAction.resetTimer;
    case 'incrementcounter':
      return WidgetAction.incrementCounter;
    case 'decrementcounter':
      return WidgetAction.decrementCounter;
    case 'toggleswitch':
      return WidgetAction.toggleSwitch;
    case 'opensettings':
      return WidgetAction.openSettings;
    case 'logout':
      return WidgetAction.logout;
    case 'deleteitem':
      return WidgetAction.deleteItem;
    case 'archiveitem':
      return WidgetAction.archiveItem;
    case 'favoriteitem':
      return WidgetAction.favoriteItem;
    case 'unfavoriteitem':
      return WidgetAction.unfavoriteItem;
    case 'rateapp':
      return WidgetAction.rateApp;
    case 'contactsupport':
      return WidgetAction.contactSupport;
    case 'bookmarkpage':
      return WidgetAction.bookmarkPage;
    case 'unbookmarkpage':
      return WidgetAction.unbookmarkPage;
    case 'sharelocation':
      return WidgetAction.shareLocation;
    case 'togglesound':
      return WidgetAction.toggleSound;
    case 'togglenotifications':
      return WidgetAction.toggleNotifications;
    default:
      print('Error: Unsupported action string "$actionString"');
      return null;
  }
}

  // Helper function to compile Dart code at runtime
Function compileFunction(String code) {
  final dartCode = '''
    import 'package:flutter/material.dart';
    $code
  ''';
  final library = Library.fromSource(dartCode);
  final function = library.getFunction('anonymous');
  return function;
}

static Widget _buildCard(Map<String, dynamic> properties, BuildContext context) {
  try {
    return Card(
      color: _parseColor(properties['color']) ?? Colors.white,
      elevation: properties['elevation'] != null
          ? double.tryParse(properties['elevation'].toString()) ?? 1.0
          : 1.0,
      shape: properties['borderRadius'] != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  double.tryParse(properties['borderRadius'].toString()) ?? 4.0),
            )
          : null,
      child: properties['child'] != null
          ? build(WidgetDescription.fromJson(properties['child']), context)
          : Container(),
    );
  } catch (e) {
    // Handle the error and return a placeholder
    print('Error building Card widget: $e');
    return const SizedBox.shrink(); // Fallback if the Card fails to build
  }
}


// Helper function to parse StackFit from string
static StackFit _parseStackFit(String? fitString) {
  switch (fitString?.toLowerCase()) {
    case 'loose':
      return StackFit.loose;
    case 'expand':
      return StackFit.expand;
    case 'passthrough':
    default:
      return StackFit.passthrough;
  }
}

// Helper function to parse Clip behavior
static Clip _parseClipBehavior(String? overflowString) {
  switch (overflowString?.toLowerCase()) {
    case 'visible':
      return Clip.none;
    case 'clip':
    default:
      return Clip.hardEdge;
  }
}

static Widget _buildPositioned(Map<String, dynamic> properties, BuildContext context) {
  try {
    // Parse positional values, ensuring proper defaults and type checking
    double? left = properties['left'] != null
        ? double.tryParse(properties['left'].toString())
        : null;
    double? top = properties['top'] != null
        ? double.tryParse(properties['top'].toString())
        : null;
    double? right = properties['right'] != null
        ? double.tryParse(properties['right'].toString())
        : null;
    double? bottom = properties['bottom'] != null
        ? double.tryParse(properties['bottom'].toString())
        : null;
    double? width = properties['width'] != null
        ? double.tryParse(properties['width'].toString())
        : null;
    double? height = properties['height'] != null
        ? double.tryParse(properties['height'].toString())
        : null;

    // Handle cases where left/right or top/bottom constraints are not both null
    if (left != null && right != null && width != null) {
      throw Exception(
          "Only two of 'left', 'right', and 'width' should be provided.");
    }
    if (top != null && bottom != null && height != null) {
      throw Exception(
          "Only two of 'top', 'bottom', and 'height' should be provided.");
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: properties['child'] != null
          ? build(_getWidgetDescription(properties['child']), context)
          : Container(), 
    );
  } catch (e) {
    // Return a placeholder in case of an error
    print('Error building Positioned widget: $e');
    return const SizedBox.shrink(); // Fallback if the Positioned fails to build
  }
}




    static Widget _buildSizedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return SizedBox(
        width: double.tryParse(properties['width']?.toString() ?? ''),
        height: double.tryParse(properties['height']?.toString() ?? ''),
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building SizedBox widget: $e');
      return const SizedBox.shrink(); // Fallback if the SizedBox fails to build
    }
  }

  static Widget _buildPadding(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Padding(
        padding: _parsePadding(properties['padding']) ?? EdgeInsets.zero,
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Padding widget: $e');
      return const SizedBox.shrink(); // Fallback if the Padding fails to build
    }
  }

  static Widget _buildCenter(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Center(
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Center widget: $e');
      return const SizedBox.shrink(); // Fallback if the Center fails to build
    }
  }

  static Widget _buildAlign(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Align(
        alignment: _parseAlignment(properties['alignment']),
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Align widget: $e');
      return const SizedBox.shrink(); // Fallback if the Align fails to build
    }
  }

  static Widget _buildAspectRatio(Map<String, dynamic> properties, BuildContext context) {
    try {
      return AspectRatio(
        aspectRatio:
            double.tryParse(properties['aspectRatio']?.toString() ?? '1.0') ??
                1.0,
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building AspectRatio widget: $e');
      return const AspectRatio(
        aspectRatio: 1.0,
        child: SizedBox.shrink(), // Fallback if the AspectRatio fails to build
      );
    }
  }

  static Widget _buildFittedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return FittedBox(
        fit: _parseBoxFit(properties['fit']),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building FittedBox widget: $e');
      return const FittedBox(child: SizedBox.shrink()); // Fallback if the FittedBox fails to build
    }
  }

  static Widget _buildFractionallySizedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return FractionallySizedBox(
        widthFactor: double.tryParse(properties['widthFactor']?.toString() ?? ''),
        heightFactor:
            double.tryParse(properties['heightFactor']?.toString() ?? ''),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building FractionallySizedBox widget: $e');
      return const FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: SizedBox.shrink(), // Fallback if the FractionallySizedBox fails to build
      );
    }
  }

  static Widget _buildLimitedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return LimitedBox(
        maxWidth:
            double.tryParse(properties['maxWidth']?.toString() ?? '0') ?? 0.0,
        maxHeight:
            double.tryParse(properties['maxHeight']?.toString() ?? '0') ?? 0.0,
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building LimitedBox widget: $e');
      return const LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: SizedBox.shrink(), // Fallback if the LimitedBox fails to build
      );
    }
  }

  static Widget _buildOffstage(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Offstage(
        offstage: properties['offstage'] ?? true,
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Offstage widget: $e');
      return const Offstage(offstage: true, child: SizedBox.shrink()); // Fallback if the Offstage fails to build
    }
  }

  static Widget _buildOverflowBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return OverflowBox(
        minWidth: double.tryParse(properties['minWidth']?.toString() ?? '0'),
        maxWidth: double.tryParse(
            properties['maxWidth']?.toString() ?? 'double.infinity'),
        minHeight: double.tryParse(properties['minHeight']?.toString() ?? '0'),
        maxHeight: double.tryParse(
            properties['maxHeight']?.toString() ?? 'double.infinity'),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building OverflowBox widget: $e');
      return const OverflowBox(
        minWidth: 0,
        maxWidth: double.infinity,
        minHeight: 0,
        maxHeight: double.infinity,
        child: SizedBox.shrink(), // Fallback if the OverflowBox fails to build
      );
    }
  }

  static Widget _buildSizedOverflowBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return SizedOverflowBox(
        size: Size(
          double.tryParse(properties['width']?.toString() ?? '0') ?? 0,
          double.tryParse(properties['height']?.toString() ?? '0') ?? 0,
        ),
        child: properties['children'] != null
              ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building SizedOverflowBox widget: $e');
      return const SizedOverflowBox(
        size: Size(0, 0),
        child: SizedBox.shrink(), // Fallback if the SizedOverflowBox fails to build
      );
    }
  }

  static Widget _buildTransform(Map<String, dynamic> properties, BuildContext context) {
    try {
      Matrix4? transformMatrix = _parseMatrix4(properties['transform']);
      return Transform(
        transform: transformMatrix ?? Matrix4.identity(),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Transform widget: $e');
      return Transform(
        transform: Matrix4.identity(),
        child: const SizedBox.shrink(), // Fallback if the Transform fails to build
      );
    }
  }

  static Widget _buildCustomPaint(Map<String, dynamic> properties, BuildContext context) {
    try {
      // CustomPaint needs a painter, which may be user-provided
      // For simplicity, we assume no painter is passed and focus on child rendering
      return CustomPaint(
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building CustomPaint widget: $e');
      return const CustomPaint(
        child: SizedBox.shrink(), // Fallback if the CustomPaint fails to build
      );
    }
  }

  static Widget _buildClipPath(Map<String, dynamic> properties, BuildContext context) {
    try {
      // ClipPath would normally need a custom clipper
      // This implementation assumes a null clipper and focuses on child rendering
      return ClipPath(
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building ClipPath widget: $e');
      return const ClipPath(
        child: SizedBox.shrink(), // Fallback if the ClipPath fails to build
      );
    }
  }

  static Widget _buildClipRect(Map<String, dynamic> properties, BuildContext context) {
    try {
      return ClipRect(
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building ClipRect widget: $e');
      return const ClipRect(
        child: SizedBox.shrink(), // Fallback if the ClipRect fails to build
      );
    }
  }

  static Widget _buildClipOval(Map<String, dynamic> properties, BuildContext context) {
    try {
      return ClipOval(
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building ClipOval widget: $e');
      return const ClipOval(child: SizedBox.shrink()); // Fallback if the ClipOval fails to build
    }
  }

  static Widget _buildOpacity(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Opacity(
        opacity:
            double.tryParse(properties['opacity']?.toString() ?? '1.0') ?? 1.0,
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Opacity widget: $e');
      return const Opacity(opacity: 1.0, child: SizedBox.shrink()); // Fallback if the Opacity fails to build
    }
  }

  static Widget _buildBackdropFilter(Map<String, dynamic> properties, BuildContext context) {
    try {
      // BackdropFilter requires a filter
      // This implementation assumes a default filter and focuses on child rendering
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building BackdropFilter widget: $e');
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: const SizedBox.shrink(), // Fallback if the BackdropFilter fails to build
      );
    }
  }

  static Widget _buildDecoratedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      // Ensure that 'decoration' is provided, or throw an error
      if (properties['decoration'] == null) {
        throw Exception("The 'decoration' property is required for DecoratedBox.");
      }
      
      return DecoratedBox(
        decoration: _parseBoxDecoration(properties['decoration']),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building DecoratedBox widget: $e');
      return const DecoratedBox(
        decoration: BoxDecoration(), // Provide a default decoration
        child: SizedBox.shrink(),
      ); // Fallback if the DecoratedBox fails to build
    }
  }

  static Widget _buildFractionalTranslation(Map<String, dynamic> properties, BuildContext context) {
    try {
      return FractionalTranslation(
        translation: Offset(
          double.tryParse(properties['translateX']?.toString() ?? '0') ?? 0,
          double.tryParse(properties['translateY']?.toString() ?? '0') ?? 0,
        ),
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building FractionalTranslation widget: $e');
      return const FractionalTranslation(
        translation: Offset(0, 0),
        child: SizedBox.shrink(), // Fallback if the FractionalTranslation fails to build
      );
    }
  }



  static Widget _buildRotatedBox(Map<String, dynamic> properties, BuildContext context) {
  try {
    // Parse the 'quarterTurns' property
    int quarterTurns = properties['quarterTurns'] ?? 0;

    // Parse the 'child' property
    Widget? child;
    if (properties['child'] != null) {
      child = build(WidgetDescription.fromJson(properties['child']), context);
    }

    return RotatedBox(
      quarterTurns: quarterTurns,
      child: child ?? const SizedBox.shrink(),
    );
  } catch (e) {
    print('Error building RotatedBox: $e');
    return const SizedBox.shrink(); // Fallback if the RotatedBox fails to build
  }
}

  static Widget _buildConstrainedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth:
              double.tryParse(properties['minWidth']?.toString() ?? '0') ?? 0,
          maxWidth: double.tryParse(
                  properties['maxWidth']?.toString() ?? 'double.infinity') ??
              double.infinity,
          minHeight:
              double.tryParse(properties['minHeight']?.toString() ?? '0') ?? 0,
          maxHeight: double.tryParse(
                  properties['maxHeight']?.toString() ?? 'double.infinity') ??
              double.infinity,
        ),
        child: properties['children'] != null
              ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building ConstrainedBox widget: $e');
      return ConstrainedBox(
        constraints: const BoxConstraints(),
        child: const SizedBox.shrink(), // Fallback if the ConstrainedBox fails to build
      );
    }
  }

  static Widget _buildUnconstrainedBox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return UnconstrainedBox(
        child: properties['children'] != null
            ? Column(children: _buildChildren(properties['children'], context))
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building UnconstrainedBox widget: $e');
      return const UnconstrainedBox(
        child: SizedBox.shrink(), // Fallback if the UnconstrainedBox fails to build
      );
    }
  }

  static Widget _buildExpanded(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Expanded(
        flex: int.tryParse(properties['flex']?.toString() ?? '1') ?? 1,
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : Container(),
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Expanded widget: $e');
      return const Expanded(child: SizedBox.shrink()); // Fallback if the Expanded fails to build
    }
  }

static Widget _buildScaffold(Map<String, dynamic> properties, BuildContext context) {
  if (kDebugMode) {
    print('DynamicWidgetBuilder: _buildScaffold chiamato con proprietà: $properties'); // <--- NUOVA STAMPA CRUCIALE
    print('DynamicWidgetBuilder: Scaffold has appBar property: ${properties.containsKey('appBar')}'); // <--- NUOVA STAMPA CRUCIALE
  }
  try {
    return Scaffold(
      appBar: properties['appBar'] != null
          ? _buildAppBar(properties['appBar'], context) as PreferredSizeWidget?
          : null,
      body: properties['body'] != null
          ? _buildConstrainedBody(properties['body'], context) // Add constrained body method
          : null,
      floatingActionButton: properties['floatingActionButton'] != null
          ? build(WidgetDescription.fromJson(properties['floatingActionButton']), context)
          : null,
      drawer: properties['drawer'] != null
          ? _buildDrawer(properties['drawer'], context)
          : null,
      bottomNavigationBar: properties['bottomNavigationBar'] != null
          ? _buildBottomNavigationBar(properties['bottomNavigationBar'], context)
          : null,
      backgroundColor: properties['backgroundColor'] != null
          ? _parseColor(properties['backgroundColor'])
          : null,
    );
  } catch (e) {
    // Return a placeholder in case of an error
    print('Error building Scaffold widget: $e');
    return ErrorWidget('Failed to build Scaffold: $e'); // Ritorna ErrorWidget per visibilità
  }
}

  static Widget _buildConstrainedBody(Map<String, dynamic> bodyProperties, BuildContext context) {
    try {
      Widget bodyContent = build(WidgetDescription.fromJson(bodyProperties), context);

      return LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
            ),
            child: bodyContent,
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error building constrained body: $e');
      }
      // MODIFICA QUI: Ritorna un ErrorWidget visibile
      return ErrorWidget('Failed to build body: $e');
    }
  }

  static AppBar _buildAppBar(Map<String, dynamic> properties, BuildContext context) {
    if (kDebugMode) {
      print('DEBUG _buildAppBar: Chiamato con proprietà RAW: $properties');
    }

    // Questo passaggio è corretto se la mappa esterna contiene 'properties'
    // come valore (come da output: {type: appBar, properties: {...}})
    properties = properties['properties'];

    if (kDebugMode) {
      print('DEBUG _buildAppBar (dopo properties = properties[\'properties\']): $properties');
    }

    try {
      Widget? titleWidget;
      Widget? leadingWidget;
      List<Widget>? actionWidgets;

      // --- Parsing della lista 'children' ---
      // Controlliamo se esiste una chiave 'children' e se è una lista
      if (properties.containsKey('children') && properties['children'] is List) {
        final List<dynamic> appBarChildrenData = properties['children'] as List<dynamic>;

        for (var childData in appBarChildrenData) {
          if (childData is Map<String, dynamic>) {
            // Creiamo una WidgetDescription dal dato del figlio
            final childDescription = WidgetDescription.fromJson(childData);

            // Assegniamo il widget basandoci sul suo tipo
            switch (childDescription.type.toLowerCase()) { // Usiamo toLowerCase per confronto robusto
              case 'text':
              // Se l'elemento Text è il titolo principale
                titleWidget = build(childDescription, context);
                if (kDebugMode) print('DEBUG _buildAppBar: Titolo Text costruito.');
                break;
              case 'leading':
                if (kDebugMode) {
                  print('DEBUG _buildAppBar: Tentativo di costruire Leading Widget.');
                }

                if (childDescription.properties.containsKey('child') && childDescription.properties['child'] is Map<String, dynamic>) {
                  try {
                    leadingWidget = build(WidgetDescription.fromJson(childDescription.properties['child'] as Map<String, dynamic>), context);
                    if (kDebugMode) print('DEBUG _buildAppBar: Leading Widget (Icona) costruito con successo: $leadingWidget ');
                  } catch (e, st) {
                    if (kDebugMode) {
                      print('!!! ERRORE _buildAppBar: Eccezione durante la costruzione del leading widget: $e');
                      print(st);
                    }
                    leadingWidget = const Icon(Icons.error_outline, color: Colors.red); // Icona di errore visibile
                  }
                } else {
                  if (kDebugMode) print('DEBUG _buildAppBar: "child" non trovato o non è una mappa valida nelle proprietà di "leading".');
                }
                break;
              case 'actions':
              // Il wrapper actions contiene una lista di children
                if (childDescription.properties.containsKey('children') && childDescription.properties['children'] is List) {
                  actionWidgets = _buildChildren(childDescription.properties['children'] as List<dynamic>, context);
                  if (kDebugMode) print('DEBUG _buildAppBar: Actions Widgets costruiti.');
                }
                break;
            // Potresti aggiungere altri casi qui per altri tipi di widget diretti nell'AppBar
              default:
                if (kDebugMode) {
                  print('DEBUG _buildAppBar: Tipo di widget non riconosciuto nella lista children: ${childDescription.type}');
                }
                break;
            }
          } else {
            if (kDebugMode) {
              print('DEBUG _buildAppBar: Elemento non valido nella lista children dell\'AppBar: $childData');
            }
          }
        }
      } else {
        // Logica fallback se non c'è una lista 'children' ma un singolo 'child' per il titolo (vecchia logica)
        // Questo blocco mantiene la compatibilità se hai ancora XML che usa 'child' direttamente
        final singleChildData = properties['child'];
        if (singleChildData != null && singleChildData is Map<String, dynamic>) {
          titleWidget = build(WidgetDescription.fromJson(singleChildData), context);
          if (kDebugMode) print('DEBUG _buildAppBar: Titolo singolo "child" costruito.');
        } else {
          if (kDebugMode) print('DEBUG _buildAppBar: Nessuna lista "children" o singolo "child" valido trovato.');
        }
      }

      // --- Parsing delle proprietà dirette dell'AppBar (elevation, centerTitle, toolbarHeight) ---

      double? elevationValue;
      if (properties['elevation'] != null) {
        elevationValue = double.tryParse(properties['elevation'].toString());
        if (kDebugMode && elevationValue == null) {
          print('WARNING _buildAppBar: Impossibile parsare elevation: ${properties['elevation']}');
        }
      }

      bool? centerTitleValue;
      if (properties['centerTitle'] != null) {
        centerTitleValue = properties['centerTitle'].toString().toLowerCase() == 'true';
      }

      double? toolbarHeightValue;
      if (properties['toolbarHeight'] != null) {
        toolbarHeightValue = double.tryParse(properties['toolbarHeight'].toString());
        if (kDebugMode && toolbarHeightValue == null) {
          print('WARNING _buildAppBar: Impossibile parsare toolbarHeight: ${properties['toolbarHeight']}');
        }
      }

      // Verifica il colore di sfondo
      Color? bgColor = _parseColor(properties['backgroundColor']);
      if (kDebugMode) {
        print('DEBUG _buildAppBar: Colore di sfondo parsato: $bgColor');
      }

      // Fallback per il colore se non parsato o non specificato
      bgColor ??= Colors.grey[800];

      return AppBar(
        title: titleWidget,
        backgroundColor: bgColor,
        elevation: elevationValue,
        centerTitle: centerTitleValue,
        toolbarHeight: toolbarHeightValue,
        leading: leadingWidget,
        actions: actionWidgets,
        // Aggiungi qui altre proprietà se necessario
      );
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('!!! ERRORE CRITICO in _buildAppBar: $e');
        print(stacktrace);
      }
      return AppBar(
        title: const Text('ERRORE: Caricamento AppBar', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.red,
      );
    }
  }

  static Widget _buildBottomNavigationBar(Map<String, dynamic> properties, BuildContext context) {
    try {
      return BottomNavigationBar(
        items: properties['items'] != null
            ? _buildBottomNavigationBarItems(properties['items'], context)
            : [],
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building BottomNavigationBar widget: $e');
      return BottomNavigationBar(
        items: [],
      ); // Fallback if the BottomNavigationBar fails to build
    }
  }

  static WidgetDescription _parseElement(XmlElement element, BuildContext context) {
    final type = element.name.local;
    final properties = <String, dynamic>{};
    print(
        "Parsing element: $type with attributes ${element.attributes.map((e) => '${e.name.local}: ${e.value}').join(', ')}");

    for (var attribute in element.attributes) {
      properties[attribute.name.local] = attribute.value;
    }

    final children = element.children.whereType<XmlElement>().toList();
    if (children.isNotEmpty) {
      properties['children'] =
          children.map((child) => _parseElement(child, context).toJson()).toList();
    } else {
      print("Warning: Element '$type' has no children.");
    }

    print("Parsed properties for element '$type': $properties");
    return WidgetDescription(type: type, properties: properties);
  }

  static List<BottomNavigationBarItem> _buildBottomNavigationBarItems(
      List<dynamic> items, BuildContext context ) {
    try {
      return items.map((item) {
        final itemProps = item as Map<String, dynamic>;
        return BottomNavigationBarItem(
          icon: build(WidgetDescription.fromJson(itemProps['icon']), context),
          label: itemProps['label'],
        );
      }).toList();
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building BottomNavigationBarItems: $e');
      return [const BottomNavigationBarItem(icon: Icon(Icons.error), label: 'Error')]; // Fallback if the items fail to build
    }
  }

  static Widget _buildDrawer(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Drawer(
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Drawer widget: $e');
      return const Drawer(
        child: Center(child: Text('Error loading drawer', style: TextStyle(color: Colors.red))),
      ); // Fallback if the Drawer fails to build
    }
  }



  static Widget _buildAlertDialog(Map<String, dynamic> properties, BuildContext context) {
    try {
      return AlertDialog(
        title: properties['title'] != null
            ? build(WidgetDescription.fromJson(properties['title']), context)
            : null,
        content: properties['content'] != null
            ? build(WidgetDescription.fromJson(properties['content']), context)
            : null,
        actions: properties['actions'] != null
            ? _buildChildren(properties['actions'], context)
            : null,
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building AlertDialog widget: $e');
      return AlertDialog(
        title: const Text('Error loading AlertDialog', style: TextStyle(color: Colors.red)),
        content: const Text('An error occurred while building the content.', style: TextStyle(color: Colors.red)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('OK'),
          ),
        ],
      ); // Fallback if the AlertDialog fails to build
    }
  }

  

  static Widget _buildDivider(Map<String, dynamic> properties, BuildContext context) {
    try {
      return const Divider();
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Divider widget: $e');
      return const Divider(color: Colors.grey); // Fallback if the Divider fails to build
    }
  }

  static Widget _buildCircularProgressIndicator(
      Map<String, dynamic> properties, BuildContext context) {
    try {
      return const CircularProgressIndicator();
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building CircularProgressIndicator widget: $e');
      return const Center(child: CircularProgressIndicator()); // Fallback if the CircularProgressIndicator fails to build
    }
  }

  static Widget _buildLinearProgressIndicator(Map<String, dynamic> properties, BuildContext context) {
    try {
      return const LinearProgressIndicator();
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building LinearProgressIndicator widget: $e');
      return const LinearProgressIndicator(value: 0); // Fallback if the LinearProgressIndicator fails to build
    }
  }

  static Widget _buildSlider(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Slider(
        value: double.tryParse(properties['value']?.toString() ?? '0') ?? 0,
        onChanged: (value) {},
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Slider widget: $e');
      return const Slider(value: 0, onChanged: null); // Fallback if the Slider fails to build
    }
  }

  static Widget _buildSwitch(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Switch(
        value: properties['value'] ?? false,
        onChanged: (value) {},
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Switch widget: $e');
      return const Switch(value: false, onChanged: null); // Fallback if the Switch fails to build
    }
  }

  static Widget _buildCheckbox(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Checkbox(
        value: properties['value'] ?? false,
        onChanged: (value) {},
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Checkbox widget: $e');
      return const Checkbox(value: false, onChanged: null); // Fallback if the Checkbox fails to build
    }
  }

  static Widget _buildRadio(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Radio(
        value: properties['value'] ?? false,
        groupValue: properties['groupValue'],
        onChanged: (value) {},
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building Radio widget: $e');
      return const Radio(value: false, groupValue: null, onChanged: null); // Fallback if the Radio fails to build
    }
  }

  static Widget _buildDropdownButton(Map<String, dynamic> properties, BuildContext context) {
    try {
      return DropdownButton(
        items: properties['items'] != null
            ? _buildDropdownButtonItems(properties['items'], context)
            : [],
        onChanged: (value) {},
      );
    } catch (e) {
      // Return a placeholder in case of an error
      print('Error building DropdownButton widget: $e');
      return  DropdownButton(
        items: [],
        onChanged: null,
      ); // Fallback if the DropdownButton fails to build
    }
  }

  static List<DropdownMenuItem> _buildDropdownButtonItems(List<dynamic> items, BuildContext context) {
    try {
      return items.map((item) {
        final itemProps = item as Map<String, dynamic>;
        return DropdownMenuItem(
          value: itemProps['value'],
          child: build(WidgetDescription.fromJson(itemProps['child']), context),
        );
      }).toList();
    } catch (e) {
      print('Error building DropdownMenuItem: $e');
      return [const DropdownMenuItem(value: null, child: Text('Error'))]; // Fallback for DropdownMenuItem
    }
  }

    static Widget _buildChip(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Chip(
        label: properties['label'] != null
            ? build(WidgetDescription.fromJson(properties['label']), context)
            : Container(),
      );
    } catch (e) {
      print('Error building Chip widget: $e');
      return const Chip(label: Text('Error')); // Fallback for Chip
    }
  }

  static Widget _buildTooltip(Map<String, dynamic> properties, BuildContext context) {
    try {
      return Tooltip(
        message: properties['message'],
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      print('Error building Tooltip widget: $e');
      return Tooltip(message: 'Error', child: Container()); // Fallback for Tooltip
    }
  }

  static Widget _buildAnimatedContainer(Map<String, dynamic> properties, BuildContext context) {
    try {
      return AnimatedContainer(
        duration: Duration(milliseconds: properties['duration'] ?? 300),
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      print('Error building AnimatedContainer widget: $e');
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Fallback with default duration
        child: Container(), // Placeholder compatible with AnimatedContainer
      );
    }
  }

  static Widget _buildFadeTransition(Map<String, dynamic> properties, BuildContext context) {
    try {
      return FadeTransition(
        opacity: AlwaysStoppedAnimation(
          double.tryParse(properties['opacity']?.toString() ?? '1.0') ?? 1.0,
        ),
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      print('Error building FadeTransition widget: $e');
      return const FadeTransition(opacity: AlwaysStoppedAnimation(1.0), child: SizedBox()); // Fallback for FadeTransition
    }
  }

  static Widget _buildScaleTransition(Map<String, dynamic> properties, BuildContext context) {
    try {
      return ScaleTransition(
        scale: AlwaysStoppedAnimation(
          double.tryParse(properties['scale']?.toString() ?? '1.0') ?? 1.0,
        ),
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      print('Error building ScaleTransition widget: $e');
      return const ScaleTransition(
        scale: AlwaysStoppedAnimation(1.0),
        child: SizedBox.shrink(), // Fallback for ScaleTransition
      );
    }
  }



static Widget _buildIcon(Map<String, dynamic> properties, BuildContext context) {
    // Default values for icon size and color
    double size = properties['size'] != null
        ? double.tryParse(properties['size'].toString()) ?? 24.0
        : 24.0;
    Color color = properties['color'] != null
        ? _parseColor(properties['color'].toString()) ?? Colors.black
        : Colors.black;

    // Parse the icon name and retrieve the corresponding IconData
    String? iconName = properties['icon'];
    IconData? iconData;

    try {
      if (iconName != null) {
        iconData = _parseIconData(iconName); // Check _parseIconData for the icon mapping
      }

      if (iconData == null) {
        throw Exception('Icon data is null or unsupported for icon: $iconName');
      }

      return Icon(
        iconData,
        size: size,
        color: color,
      );
    } catch (e) {
      print('Error building Icon widget: $e');
      return const Icon(Icons.error); // Return error icon if any issue occurs
    }
  }

  static Widget _buildSlideTransition(Map<String, dynamic> properties, BuildContext context) {
    try {
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(
            double.tryParse(properties['offsetX']?.toString() ?? '0') ?? 0,
            double.tryParse(properties['offsetY']?.toString() ?? '0') ?? 0,
          ),
        ).animate(CurvedAnimation(
          parent: const AlwaysStoppedAnimation(1.0),
          curve: Curves.easeInOut,
        )),
        child: properties['child'] != null
            ? build(WidgetDescription.fromJson(properties['child']), context)
            : null,
      );
    } catch (e) {
      print('Error building SlideTransition widget: $e');
      return const SlideTransition(
        position: AlwaysStoppedAnimation(Offset.zero),
        child: SizedBox.shrink(), // Fallback for SlideTransition
      );
    }
  }


   static List<Widget> _buildChildren(List<dynamic>? children, BuildContext context) {
    return children?.map((child) {
      try {
        if (child is Map<String, dynamic>) {
          return build(WidgetDescription.fromJson(child), context);
        }
      } catch (e) {
        print('Error building child widget: $e');
        return const SizedBox.shrink(); // Fallback for child widgets that fail to build
      }
      return const SizedBox.shrink();
    }).toList() ?? [];
  }

  static Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      if (kDebugMode) print("DEBUG _parseColor: Stringa colore in input è null o vuota.");
      return null;
    }

    // Rimuovi il '#' se presente
    String cleanColorString = colorString.trim();
    if (cleanColorString.startsWith('#')) {
      cleanColorString = cleanColorString.substring(1);
    }

    // Gestione dei colori esadecimali RRGGBB (aggiungiamo l'alpha FF)
    if (cleanColorString.length == 6) {
      cleanColorString = 'FF' + cleanColorString; // Aggiungi FF per l'opacità
    }

    // Ora la stringa dovrebbe essere AARRGGBB
    if (cleanColorString.length == 8) {
      try {
        // *** MODIFICA CRUCIALE QUI: Aggiunto radix: 16 ***
        return Color(int.parse(cleanColorString, radix: 16));
      } catch (e) {
        if (kDebugMode) {
          print("ERRORE _parseColor: Impossibile parsare stringa esadecimale '$colorString' ($cleanColorString): $e");
        }
        return null; // Ritorna null in caso di errore di parsing
      }
    }

    // Aggiungi qui la gestione per nomi di colori semplici come "red", "blue", ecc.
    // Se non l'hai già fatto, altrimenti il tuo sistema capirà solo #RRGGBB.
    switch (cleanColorString.toLowerCase()) {
      case 'white': return Colors.white;
      case 'black': return Colors.black;
      case 'red': return Colors.red;
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
    // Aggiungi altri colori che vuoi supportare
      default:
        if (kDebugMode) {
          print("WARNING _parseColor: Formato colore non supportato o nome non riconosciuto: '$colorString'");
        }
        return null; // Ritorna null se non è né esadecimale valido né un nome riconosciuto
    }
  }

  Widget _parseText(Map<String, dynamic> json, BuildContext context) {
  return Text(
    json['text']?.toString() ?? 'Default Text',
    style: TextStyle(
      color: _parseColor(json['color']),
      fontSize: json['fontSize']?.toDouble() ?? 14.0,
      fontWeight: _parseFontWeight(json['fontWeight']),
      fontFamily: json['fontFamily'] ?? 'Arial',
    ),
  );
}

EdgeInsets _parseEdgeInsets(String edgeInsetsString) {
  List<String> values = edgeInsetsString.split(',');
  return EdgeInsets.fromLTRB(
    double.parse(values[0]),
    double.parse(values[1]),
    double.parse(values[2]),
    double.parse(values[3]),
  );
}

static EdgeInsetsGeometry? _parsePadding(dynamic padding) {
  if (padding == null) return null;
  if (padding is String) {
    List<String> values = padding.split(',');
    if (values.length == 4) {
      return EdgeInsets.fromLTRB(
        double.parse(values[0]),
        double.parse(values[1]),
        double.parse(values[2]),
        double.parse(values[3]),
      );
    } else if (values.length == 1) {
      return EdgeInsets.all(double.parse(values[0]));
    }
  }
  return null;
}


static Alignment _parseAlignment(String? alignmentString) {
  switch (alignmentString?.toLowerCase()) {
    case 'topleft':
      return Alignment.topLeft;
    case 'topcenter':
      return Alignment.topCenter;
    case 'topright':
      return Alignment.topRight;
    case 'centerleft':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'centerright':
      return Alignment.centerRight;
    case 'bottomleft':
      return Alignment.bottomLeft;
    case 'bottomcenter':
      return Alignment.bottomCenter;
    case 'bottomright':
      return Alignment.bottomRight;
    default:
      // Default alignment is center
      return Alignment.center;
  }
}


Widget _parseWidget(Map<String, dynamic> json, BuildContext context) {
  switch (json['type']) {
    case 'Text':
      return _parseText(json, context);
    case 'Container':
      return _buildContainer(json, context);
    case 'Column':
      return _buildColumn(json, context);
    case 'Row':
      return _buildRow(json, context);
    case 'Stack':
      return _buildStack(json, context);
    case 'Positioned':
      return _buildPositioned(json, context);
    case 'GridView':
      return _buildGridView(json, context);
    case 'SingleChildScrollView':
      return _buildSingleChildScrollView(json, context);
    case 'Scaffold':
      return _buildScaffold(json, context);
    case 'appBar':
      return _parseAppBar(json, context);
    default:
      return const SizedBox.shrink(); // Return an empty widget for unsupported types
  }
}

Widget _parseAppBar(Map<String, dynamic> json, BuildContext context) {
  return AppBar(
    title: _parseText(json['title'], context),
    backgroundColor: _parseColor(json['backgroundColor']),
    leading: json['leading'] != null ? _parseWidget(json['leading'], context) : null,
    actions: json['actions'] != null ? _buildChildren(json['actions'], context) : null,
  );
}



  static BoxFit _parseBoxFit(String? fitString) {
    switch (fitString) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

static Matrix4? _parseMatrix4(String? matrixString) {
  if (matrixString == null) return Matrix4.identity();
  final values = matrixString.split(',').map(double.parse).toList();
  if (values.length == 16) {
    return Matrix4.fromList(values);
  }
  // Return identity matrix in case of error
  return Matrix4.identity();
}


  static BoxDecoration _parseBoxDecoration(
      Map<String, dynamic>? decorationProps) {
    if (decorationProps == null) return const BoxDecoration();
    return BoxDecoration(
      color: _parseColor(decorationProps['color']),
      borderRadius: decorationProps['borderRadius'] != null
          ? BorderRadius.circular(double.tryParse(
                  decorationProps['borderRadius']?.toString() ?? '0') ??
              0)
          : null,
      boxShadow: decorationProps['boxShadow'] != null
          ? [_parseBoxShadow(decorationProps['boxShadow'])]
          : null,
      // Add more decoration properties if needed
    );
  }

  static BoxShadow _parseBoxShadow(Map<String, dynamic> shadowProps) {
    return BoxShadow(
      color: _parseColor(shadowProps['color']) ?? Colors.black,
      offset: Offset(
        double.tryParse(shadowProps['offsetX']?.toString() ?? '0') ?? 0,
        double.tryParse(shadowProps['offsetY']?.toString() ?? '0') ?? 0,
      ),
      blurRadius:
          double.tryParse(shadowProps['blurRadius']?.toString() ?? '0') ?? 0,
    );
  }

  static WidgetDescription _getWidgetDescription(dynamic child) {
    if (child is XmlElement) {
      return WidgetDescription.fromXml(child);
    } else if (child is Map<String, dynamic>) {
      return WidgetDescription.fromJson(child);
    } else {
      throw Exception('Unsupported child format');
    }
  }
  
// Parsing alignment
static CrossAxisAlignment _parseCrossAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'end':
      return CrossAxisAlignment.end;
    case 'center':
      return CrossAxisAlignment.center;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    default:
      return CrossAxisAlignment.center;
  }
}

// Parsing main axis alignment
static MainAxisAlignment _parseMainAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'start':
      return MainAxisAlignment.start;
    case 'end':
      return MainAxisAlignment.end;
    case 'center':
      return MainAxisAlignment.center;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start;
  }
}

// Parsing main axis size
static MainAxisSize _parseMainAxisSize(String? size) {
  switch (size) {
    case 'min':
      return MainAxisSize.min;
    case 'max':
      return MainAxisSize.max;
    default:
      return MainAxisSize.max;
  }
}



}


class Library {
  static Library fromSource(String code) {
    // This is a placeholder for a real implementation that compiles Dart code at runtime
    // In a real implementation, you would use a Dart compiler to compile the code
    // and return a Library object that can be used to get functions.
    return Library();
  }

  Function getFunction(String name) {
    // This is a placeholder for a real implementation that returns a function
    // from the compiled Dart code.
    return () {};
  }
}
