import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import '../models/widget_description.dart';


class XmlParser {
  static WidgetDescription parse(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final root = document.rootElement;
    return _parseElement(root);
  }

  static WidgetDescription _parseElement(XmlElement element) {
    final type = element.name.local;
    final properties = <String, dynamic>{};
    if (kDebugMode) {
      print("XmlParser: Parsing element: $type"); // Verifica che questa venga stampata per 'Scaffold'
    }

    for (var attribute in element.attributes) {
      properties[attribute.name.local] = attribute.value;
      if (kDebugMode) {
        print("XmlParser:  - Attribute for $type: ${attribute.name.local} = ${attribute.value}");
      }
    }

    if (type == 'Scaffold') {
      if (kDebugMode) {
        print("XmlParser: Handling Scaffold children as named properties.");
      }
      for (var childElement in element.children.whereType<XmlElement>()) {
        final childName = childElement.name.local;
        if (kDebugMode) {
          print("XmlParser:  - Found child element for Scaffold: $childName"); // <--- NUOVA STAMPA CRUCIALE
        }
        if (childName == 'AppBar' ||
            childName == 'appBar' ||
            childName == 'body' ||
            childName == 'Body' ||
            childName == 'floatingActionButton' ||
            childName == 'drawer' ||
            childName == 'bottomNavigationBar') {
          // Ricorsivamente parsiamo il figlio e lo assegniamo alla proprietà con il nome del tag
          properties[childName] = _parseElement(childElement).toJson();
          if (kDebugMode) {
            print("XmlParser:  - Assigned '$childName' to Scaffold properties."); // <--- NUOVA STAMPA CRUCIALE
          }
        } else {
          if (kDebugMode) {
            print("XmlParser:  - Ignoring unknown Scaffold child: $childName"); // <--- NUOVA STAMPA CRUCIALE
          }
          // Gestisci altri figli dello Scaffold qui se necessario, ad esempio in una 'children' list
          // o logica specifica se uno Scaffold può avere figli non standard (meno comune)
        }
      }
    } else {
      // Logica esistente per 'child' e 'children' generici
      final children = element.children.whereType<XmlElement>().toList();
      if (children.isNotEmpty) {
        if (children.length == 1 && children[0].name.local != 'children') {
          // Quando c'è un singolo figlio (come il Text dentro l'AppBar)
          try {
            final parsedChildDescription = _parseElement(children[0]);
            if (parsedChildDescription != null) {
              // *** MODIFICA CRUCIALE QUI ***
              // Ricreiamo la mappa delle proprietà per il 'child' per assicurarci la pulizia delle chiavi
              final Map<String, dynamic> cleanChildProperties = {};
              parsedChildDescription.toJson().forEach((key, value) {
                cleanChildProperties[key.toString()] = value;
              });
              properties['child'] = cleanChildProperties; // Assegniamo la mappa pulita
              if (kDebugMode) {
                print("XmlParser: Assigned 'child' for $type with clean map: $cleanChildProperties");
              }
            } else {
              if (kDebugMode) {
                print("!!! WARNING XmlParser: Parsed single child for $type resulted in null WidgetDescription.");
              }
            }
          } catch (e, st) {
            if (kDebugMode) {
              print("!!! ERRORE XmlParser: Failed to parse single child of $type: $e");
              print(st);
            }
          }
        } else {
          // Logica per più figli (es. Column, Row) - applica la stessa logica di pulizia
          final parsedChildren = <Map<String, dynamic>>[];
          for (var child in children.where((c) => c.name.local != 'children')) {
            try {
              final parsedChildDescription = _parseElement(child);
              if (parsedChildDescription != null) {
                // *** MODIFICA CRUCIALE QUI ***
                final Map<String, dynamic> cleanChildProperties = {};
                parsedChildDescription.toJson().forEach((key, value) {
                  cleanChildProperties[key.toString()] = value;
                });
                parsedChildren.add(cleanChildProperties); // Aggiungiamo la mappa pulita
              }
            } catch (e, st) {
              if (kDebugMode) {
                print("!!! ERRORE XmlParser: Failed to parse list child of $type: ${child.name.local} - $e");
                print(st);
              }
            }
          }
          properties['children'] = parsedChildren;
        }
      }
    }

    if (kDebugMode) {
      print("XmlParser: Final properties for $type: $properties"); // <--- NUOVA STAMPA CRUCIALE
    }
    return WidgetDescription(type: type, properties: properties);
  }
}

