import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remotedroid/dynamic_widget_builder.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa shared_preferences
import 'package:permission_handler/permission_handler.dart'; // Importa permission_handler
import 'package:mobile_scanner/mobile_scanner.dart'; // Importa mobile_scanner
import 'dart:convert'; // Per la decodifica JSON

// Definisci una GlobalKey per il Navigator principale
// È cruciale per la navigazione affidabile da qualsiasi punto dell'app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

// Classe per le impostazioni dell'app
class AppSettings {
  final String remoteXmlRoot;
  final String remoteXmlRoutesUrl;
  final String? password; // Campo password aggiunto, può essere nullo

  AppSettings({
    required this.remoteXmlRoot,
    required this.remoteXmlRoutesUrl,
    this.password, // Rendi il parametro opzionale e nullable
  });

  // Metodo per convertire le impostazioni in una mappa per shared_preferences
  Map<String, dynamic> toJson() => {
    'remoteXmlRoot': remoteXmlRoot,
    'remoteXmlRoutesUrl': remoteXmlRoutesUrl,
    'password': password, // Includi la password
  };

  // Metodo per creare le impostazioni da una mappa (es. da shared_preferences o QR)
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      remoteXmlRoot: json['remoteXmlRoot'] as String,
      remoteXmlRoutesUrl: json['remoteXmlRoutesUrl'] as String,
      password: json['password'] as String?, // Leggi la password, può essere nulla
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<AppSettings?> _appSettingsFuture;
  Map<String, WidgetBuilder> _dynamicWidgetBuilders = {};
  bool _hasNavigatedInitially = false;

  // Variabili per le impostazioni caricate
  AppSettings? _currentSettings;

  @override
  void initState() {
    super.initState();
    _appSettingsFuture = _loadAppSettings();
  }

  Future<AppSettings?> _loadAppSettings() async {
    if (kDebugMode) print('SETTINGS_DEBUG: Caricamento impostazioni dall\'archiviazione locale...');
    final prefs = await SharedPreferences.getInstance();
    final String? settingsJson = prefs.getString('appSettings');

    if (settingsJson != null) {
      if (kDebugMode) print('SETTINGS_DEBUG: Impostazioni trovate: $settingsJson');
      try {
        final Map<String, dynamic> jsonMap = json.decode(settingsJson);
        final settings = AppSettings.fromJson(jsonMap);
        _currentSettings = settings; // Salva le impostazioni caricate
        if (kDebugMode) print('SETTINGS_DEBUG: Impostazioni caricate con successo.');
        return settings;
      } catch (e) {
        if (kDebugMode) print('SETTINGS_ERROR: Errore nel parsing delle impostazioni salvate: $e');
        await prefs.remove('appSettings'); // Rimuovi le impostazioni corrotte
        return null;
      }
    }
    if (kDebugMode) print('SETTINGS_DEBUG: Nessuna impostazione trovata.');
    return null;
  }

  Future<void> _saveAppSettings(AppSettings settings) async {
    if (kDebugMode) print('SETTINGS_DEBUG: Salvataggio impostazioni: ${settings.toJson()}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appSettings', json.encode(settings.toJson()));
    _currentSettings = settings; // Aggiorna le impostazioni correnti
    if (kDebugMode) print('SETTINGS_DEBUG: Impostazioni salvate con successo.');
  }

  Future<Map<String, String>> _loadDynamicRouteUrls(String remoteXmlRoutesUrl) async {
    if (kDebugMode) print('DEBUG: Inizio _loadDynamicRouteUrls. URL: $remoteXmlRoutesUrl');
    try {
      final response = await http.get(Uri.parse(remoteXmlRoutesUrl));
      if (kDebugMode) print('DEBUG: Risposta HTTP ricevuta per app_routes.xml. Stato: ${response.statusCode}');

      if (response.statusCode == 200) {
        final xmlString = response.body;
        if (kDebugMode) print('DEBUG: Contenuto app_routes.xml ricevuto:\n$xmlString');

        final document = XmlDocument.parse(xmlString);
        final Iterable<XmlElement> appRoutesElements = document.findAllElements('appRoutes');
        if (kDebugMode) print('DEBUG: Numero di elementi <appRoutes> trovati: ${appRoutesElements.length}');

        if (appRoutesElements.isEmpty) {
          throw Exception('Elemento radice <appRoutes> non trovato nel file XML delle rotte o il file è malformato.');
        }
        final appRoutesElement = appRoutesElements.first;

        Map<String, String> routeUrls = {};
        for (var routeElement in appRoutesElement.findAllElements('route')) {
          final String? routeName = routeElement.getAttribute('name');
          final String? pageUrlRelative = routeElement.getAttribute('pageUrl');

          if (routeName != null && pageUrlRelative != null) {
            routeUrls[routeName] = pageUrlRelative;
            if (kDebugMode) print('DEBUG: Route definita: "$routeName" -> "$pageUrlRelative"');
          } else {
            if (kDebugMode) print('WARNING: Rotta con nome o URL pagina mancante/nullo in app_routes.xml: $routeElement');
          }
        }
        if (kDebugMode) print('DEBUG: Mappa delle rotte URL finale (chiavi): (${routeUrls.keys.join(', ')})');
        return routeUrls;
      } else {
        throw Exception('Failed to load routes XML from $remoteXmlRoutesUrl: ${response.statusCode}. Corpo: ${response.body}');
      }
    } catch (e, st) {
      if (kDebugMode) print('ERROR: Errore durante il caricamento delle rotte URL dinamiche: $e');
      if (kDebugMode) print('STACK TRACE: $st');
      return {};
    }
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (kDebugMode) print('DEBUG ON_GENERATE_ROUTE: _onGenerateRoute Method entered for route: "${settings.name}"');

    final String? routeName = settings.name;

    if (routeName == null) {
      if (kDebugMode) print('DEBUG ON_GENERATE_ROUTE: settings.name è nullo. Restituisco pagina di errore.');
      return MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Errore Rotta')),
          body: const Center(child: Text('Errore: Il nome della rotta è nullo.', style: TextStyle(color: Colors.red))),
        ),
      );
    }

    final WidgetBuilder? builder = _dynamicWidgetBuilders[routeName];

    if (builder != null) {
      if (kDebugMode) print('DEBUG ON_GENERATE_ROUTE: Trovato builder per rotta "$routeName".');
      return MaterialPageRoute<void>(
        settings: settings,
        builder: builder,
      );
    } else {
      if (kDebugMode) print('DEBUG ON_GENERATE_ROUTE: Nessun builder trovato per rotta "$routeName". Restituisco pagina di errore.');
      return MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Errore Rotta')),
          body: Center(
            child: Text('Errore: La rotta "$routeName" non è stata trovata o non è valida.', style: const TextStyle(color: Colors.red)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppSettings?>(
      future: _appSettingsFuture,
      builder: (context, settingsSnapshot) {
        if (settingsSnapshot.connectionState == ConnectionState.done) {
          if (settingsSnapshot.hasData && settingsSnapshot.data != null) {
            _currentSettings = settingsSnapshot.data; // Assicurati che _currentSettings sia impostato
            return _buildAppWithLoadedSettings();
          } else {
            // Nessuna impostazione trovata o errore, mostra la schermata di configurazione
            return MaterialApp(
              title: 'RemoteDroid', // Titolo modificato qui
              theme: ThemeData(primarySwatch: Colors.blue),
              navigatorKey: navigatorKey, // Assegna la GlobalKey al MaterialApp per la navigazione
              home: SettingsScreen(
                onSave: (settings) async {
                  await _saveAppSettings(settings);
                  setState(() {
                    _appSettingsFuture = Future.value(settings); // Aggiorna il future per innescare rebuild
                  });
                },
              ),
            );
          }
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppWithLoadedSettings() {
    // Ora che le impostazioni sono caricate, possiamo caricare le rotte dinamiche
    return FutureBuilder<Map<String, String>>(
      future: _loadDynamicRouteUrls(_currentSettings!.remoteXmlRoutesUrl),
      builder: (context, routesSnapshot) {
        if (routesSnapshot.connectionState == ConnectionState.done) {
          if (routesSnapshot.hasData) {
            final Map<String, String> loadedRouteUrls = routesSnapshot.data!;
            if (kDebugMode) print('DEBUG: FutureBuilder principale - URL Rotte caricate (${loadedRouteUrls.length} rotte).');

            _dynamicWidgetBuilders = {};
            for (var entry in loadedRouteUrls.entries) {
              final String routeName = entry.key;
              final String pageUrlRelative = entry.value;
              final String fullPageUrl = '${_currentSettings!.remoteXmlRoot}${pageUrlRelative.startsWith('/') ? '' : '/'}$pageUrlRelative';

              _dynamicWidgetBuilders[routeName] = (BuildContext ctx) {
                if (kDebugMode) print('DEBUG PAGE FUTUREBUILDER: Rotta "$routeName" attivata. Inizio caricamento pagina da "$fullPageUrl".');
                return FutureBuilder<String>(
                  future: http.get(Uri.parse(fullPageUrl))
                      .catchError((error) {
                    if (kDebugMode) print('ERROR PAGE: Errore CRITICO nella richiesta HTTP per "$fullPageUrl": $error');
                    throw error;
                  })
                      .then((pageResponse) {
                    if (kDebugMode) print('DEBUG PAGE: Risposta HTTP ricevuta per "$fullPageUrl". Stato: ${pageResponse.statusCode}');
                    if (pageResponse.statusCode == 200) {
                      if (kDebugMode) print('DEBUG PAGE: Contenuto XML pagina "$fullPageUrl" ricevuto (primi 500 char):\n${pageResponse.body.substring(0, (pageResponse.body.length > 500 ? 500 : pageResponse.body.length))}...');
                      return pageResponse.body;
                    } else {
                      throw Exception('Failed to load page XML from $fullPageUrl: ${pageResponse.statusCode}');
                    }
                  }),
                  builder: (innerContext, pageSnapshot) {
                    if (kDebugMode) print('DEBUG PAGE FUTUREBUILDER: Builder per rotta "$routeName" stato: ${pageSnapshot.connectionState}, hasData: ${pageSnapshot.hasData}, hasError: ${pageSnapshot.hasError}');

                    if (pageSnapshot.connectionState == ConnectionState.done && pageSnapshot.hasData) {
                      if (kDebugMode) print('DEBUG PAGE: Caricamento pagina "$routeName" completato. Contenuto OK. Inizio costruzione UI.');
                      try {
                        // Passa la GlobalKey del Navigator al buildFromXml
                        return DynamicWidgetBuilder.buildFromXml(pageSnapshot.data!, innerContext);
                      } catch (e, st) {
                        if (kDebugMode) print('ERROR PAGE: Errore durante la costruzione della UI per rotta "$routeName": $e');
                        if (kDebugMode) print('STACK TRACE PAGE: $st');
                        return Center(child: Text('Errore nella costruzione della UI per la pagina "$routeName": $e', style: const TextStyle(color: Colors.red)));
                      }
                    } else if (pageSnapshot.hasError) {
                      if (kDebugMode) print('ERROR PAGE: Errore nel Future della pagina "$routeName": ${pageSnapshot.error}');
                      return Center(child: Text('Errore nel caricamento della pagina "$routeName": ${pageSnapshot.error}', style: const TextStyle(color: Colors.red)));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              };
            }
            if (kDebugMode) print('DEBUG: Popolata _dynamicWidgetBuilders. Chiavi: (${_dynamicWidgetBuilders.keys.join(', ')})');

            String? effectiveInitialRoute;
            if (loadedRouteUrls.containsKey('/')) {
              effectiveInitialRoute = '/';
            } else if (loadedRouteUrls.isNotEmpty) {
              effectiveInitialRoute = loadedRouteUrls.keys.first;
              if (kDebugMode) print('DEBUG: Rotta iniziale "/" non trovata, usando la prima rotta disponibile: $effectiveInitialRoute');
            }

            return MaterialApp(
              title: 'RemoteDroid',
              theme: ThemeData(primarySwatch: Colors.blue),
              navigatorKey: navigatorKey,
              home: Builder(
                builder: (navigatorContext) {
                  if (!_hasNavigatedInitially && effectiveInitialRoute != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        if (kDebugMode) print('DEBUG: Navigazione iniziale a "$effectiveInitialRoute" tramite pushReplacementNamed.');
                        navigatorKey.currentState?.pushReplacementNamed(effectiveInitialRoute!);
                        _hasNavigatedInitially = true;
                      }
                    });
                  }
                  return const Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Caricamento app...', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
              onGenerateRoute: _onGenerateRoute,
              routes: {},
            );
          } else if (routesSnapshot.hasError) {
            if (kDebugMode) print('DEBUG: FutureBuilder principale - Errore nel caricamento iniziale: ${routesSnapshot.error}');
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, color: Colors.grey, size: 60),
                      const SizedBox(height: 10),
                      Text('Errore nel caricamento delle rotte: ${routesSnapshot.error}. Controlla URL o QR.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Rimuovi le impostazioni e riavvia la schermata di configurazione
                          _saveAppSettings(AppSettings(remoteXmlRoot: '', remoteXmlRoutesUrl: '')).then((_) {
                            setState(() {
                              _appSettingsFuture = _loadAppSettings(); // Ricarica per andare alla configurazione
                              _hasNavigatedInitially = false;
                            });
                          });
                        },
                        child: const Text('Riconfigura'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Caricamento configurazione app...', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Nuova Schermata di Configurazione ---
class SettingsScreen extends StatefulWidget {
  final Function(AppSettings) onSave;

  const SettingsScreen({super.key, required this.onSave});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _rootUrlController = TextEditingController();
  final TextEditingController _routesUrlController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Controller per la password

  bool _isScanning = false;
  bool _obscurePassword = true; // Stato per nascondere/mostrare la password

  @override
  void dispose() {
    _rootUrlController.dispose();
    _routesUrlController.dispose();
    _passwordController.dispose(); // Dispose anche per la password
    super.dispose();
  }

  Future<void> _scanQrCode() async {
    // Richiedi il permesso della fotocamera prima di avviare lo scanner
    var status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isScanning = true;
      });

      // Avvia lo scanner QR
      final result = await navigatorKey.currentState?.push<String>(
        MaterialPageRoute(builder: (context) => const QRScannerPage()),
      );

      setState(() {
        _isScanning = false;
      });

      if (result != null) {
        try {
          final Map<String, dynamic> qrData = json.decode(result);
          final settings = AppSettings.fromJson(qrData);
          _rootUrlController.text = settings.remoteXmlRoot;
          _routesUrlController.text = settings.remoteXmlRoutesUrl;
          _passwordController.text = settings.password ?? ''; // Imposta la password (o stringa vuota se null)

          // Salva e notifica il cambio di stato per riavviare l'app
          widget.onSave(settings);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impostazioni caricate da QR! Riavvio app...')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore nel formato QR: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permesso fotocamera negato! Impossibile scansionare QR.')),
      );
    }
  }

  void _saveSettingsManually() {
    if (_rootUrlController.text.isEmpty || _routesUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila tutti i campi.')),
      );
      return;
    }

    final settings = AppSettings(
      remoteXmlRoot: _rootUrlController.text,
      remoteXmlRoutesUrl: _routesUrlController.text,
      password: _passwordController.text.isEmpty ? null : _passwordController.text, // Passa la password (o null se vuota)
    );
    widget.onSave(settings);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impostazioni salvate manualmente! Riavvio app...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurazione RemoteDroid', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Benvenuto! Sembra sia il tuo primo avvio o le impostazioni sono mancanti. Configura l\'app compilando i seguenti campi o scansionando un QR Code.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton.filled(
                    iconSize: 30,
                    onPressed: _isScanning ? null : _scanQrCode,
                    padding: const EdgeInsets.all(10.0),
                    style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                    icon: _isScanning
                        ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ):
                    const Icon(Icons.qr_code_scanner, color: Colors.white ),
                  ),
                ]
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _rootUrlController,
              decoration: const InputDecoration(
                labelText: 'URL Root Server (es. https://www.example.com/api)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _routesUrlController,
              decoration: const InputDecoration(
                labelText: 'URL File Routes (es. https://www.example.com/api/app_routes.xml)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 15), // Spazio per il nuovo campo password
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword, // Controlla la visibilità
              decoration: InputDecoration(
                labelText: 'Password (opzionale)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton( // Pulsante occhiolino
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword; // Inverti la visibilità
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 30),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton.filled(
                    iconSize: 30,
                    onPressed: _isScanning ? null : _saveSettingsManually,
                    padding: const EdgeInsets.all(10.0),
                    style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                    icon:  const Icon(Icons.save, color: Colors.white),
                  ),
                ]
            ),
            const SizedBox(height: 20),
            const Text(
              'Nota: Dopo il salvataggio, l\'app si riavvierà con le nuove impostazioni.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Nuova Pagina per lo Scanner QR ---
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansiona QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? qrCodeValue = barcodes.first.rawValue;
                if (qrCodeValue != null) {
                  if (kDebugMode) print('QR_SCANNER: Valore QR Code rilevato: $qrCodeValue');
                  // Una volta rilevato, torna indietro con il valore
                  Navigator.of(context).pop(qrCodeValue);
                }
              }
            },
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
