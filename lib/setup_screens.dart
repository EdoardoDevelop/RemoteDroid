import 'package:flutter/foundation.dart'; // Per kDebugMode
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Importa permission_handler
import 'package:mobile_scanner/mobile_scanner.dart'; // Importa mobile_scanner
import 'dart:convert'; // Per la decodifica JSON

import 'package:remotedroid/app_config.dart'; // Importa AppSettings
import 'package:remotedroid/main.dart'; // Importa navigatorKey

// --- Schermata di Configurazione ---
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
        const SnackBar(content: Text('Compila tutti i campi URL.')),
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

// --- Pagina per lo Scanner QR ---
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
