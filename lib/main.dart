import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  const BluetoothApp({Key? key}) : super(key: key);

  @override
  State<BluetoothApp> createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  final List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off) {
      } else if (state == BluetoothAdapterState.on) {
        startScan();
      }
    });
  }

  void startScan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        addDeviceToList(result.device);
      }
    });

    FlutterBluePlus.stopScan();
  }

  void addDeviceToList(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bluetooth Demo'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)),
        child: ListView.builder(
          itemCount: devicesList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(devicesList[index].platformName),
              subtitle: Text(devicesList[index].remoteId.toString()),
              trailing: ElevatedButton(
                child: const Text('Connect'),
                onPressed: () => connectToDevice(devicesList[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FlutterBluePlus.turnOn(),
        child: const Icon(Icons.bluetooth),
      ),
    );
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
  }
}
