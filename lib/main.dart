import 'package:flutter/material.dart';
import 'package:remotedroid/dynamic_widget_builder.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic UI Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DynamicScreen(),
    );
  }
}

class DynamicScreen extends StatefulWidget {
  const DynamicScreen({super.key});

  @override
  State<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends State<DynamicScreen> {
  final String remoteXmlUrl = 'http://192.168.1.100/remotedroid';
  String? _uiConfigXml; // Variabile per memorizzare la stringa XML
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUIConfig(); // Chiamiamo qui la tua funzione originale
  }

  // La tua funzione originale, leggermente modificata per aggiornare lo stato del widget
  Future<void> _fetchUIConfig() async {
    try {
      final response = await http.get(Uri.parse(remoteXmlUrl));
      if (response.statusCode == 200) {
        final String uiConfig = response.body;
        setState(() {
          _uiConfigXml = uiConfig;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load UI config: ${response.statusCode}';
          _isLoading = false;
        });
        print('Errore API: ${response.statusCode}');
        print('Corpo risposta: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching UI config: $e';
        _isLoading = false;
      });
      print('Errore durante il recupero della configurazione UI: $e');
    }
  }

  Widget buildDynamicUI(String uiConfigXml) {
    // Qui chiamiamo il tuo DynamicWidgetBuilder per costruire l'UI dall'XML
    return DynamicWidgetBuilder.buildFromXml(uiConfigXml, context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Errore Caricamento UI')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    // Se l'XML è stato caricato e non ci sono errori, usiamo buildDynamicUI
    if (_uiConfigXml != null) {
      return buildDynamicUI(_uiConfigXml!);
    }

    // Fallback in caso di stato indefinito
    return Scaffold(
      appBar: AppBar(title: const Text('Caricamento UI')),
      body: const Center(child: Text('Nessuna configurazione UI disponibile.')),
    );
  }
}