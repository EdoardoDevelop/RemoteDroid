import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remotedroid/dynamic_widget_builder.dart'; // Assicurati che il percorso sia corretto
import 'package:http/http.dart' as http; // Per le richieste HTTP
import 'package:xml/xml.dart'; // Per il parsing XML

import 'package:remotedroid/app_config.dart'; // Nuovo file per AppSettings e SettingsService
import 'package:remotedroid/setup_screens.dart'; // Nuovo file per SettingsScreen e QRScannerPage

// Definisci una GlobalKey per il Navigator principale
// È cruciale per la navigazione affidabile da qualsiasi punto dell'app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

/// MyApp è il widget radice dell'applicazione.
/// Gestisce il caricamento asincrono delle rotte dinamiche all'avvio.
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
    _appSettingsFuture = SettingsService.loadAppSettings(); // Carica le impostazioni usando il nuovo servizio
  }

  Future<Map<String, String>> _loadDynamicRouteUrls(String remoteXmlRoot, String remoteXmlRoutesUrl) async {
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
              title: 'RemoteDroid',
              theme: ThemeData(primarySwatch: Colors.blue),
              navigatorKey: navigatorKey, // Assegna la GlobalKey al MaterialApp per la navigazione
              home: SettingsScreen(
                onSave: (settings) async {
                  await SettingsService.saveAppSettings(settings); // Salva usando il nuovo servizio
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
      future: _loadDynamicRouteUrls(_currentSettings!.remoteXmlRoot, _currentSettings!.remoteXmlRoutesUrl),
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
                          SettingsService.saveAppSettings(AppSettings(remoteXmlRoot: '', remoteXmlRoutesUrl: '')).then((_) {
                            setState(() {
                              _appSettingsFuture = SettingsService.loadAppSettings(); // Ricarica per andare alla configurazione
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
