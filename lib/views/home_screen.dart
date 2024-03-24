import 'package:bluetooth_app_test_task/contrllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BluetoothController _bluetoothController;
  late double _width;
  late double _height;

  @override
  void initState() {
    _bluetoothController = BluetoothController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _width = MediaQuery.sizeOf(context).width;
    _height = MediaQuery.sizeOf(context).height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: GetBuilder<BluetoothController>(
        init: _bluetoothController,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: _height * 0.1,
                  color: Colors.amber,
                  child: Center(
                    child: Text(
                      'Bluetooth App',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.01),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _bluetoothController.scanDevice(),
                    child: const Text('Scan'),
                  ),
                ),
                SizedBox(height: _height * 0.01),
                StreamBuilder<List<ScanResult>>(
                  stream: _bluetoothController.scanResults.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data?[index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title:
                                  Text(data!.device.name ?? 'Unknown device'),
                              subtitle: Text(data.device.remoteId.toString()),
                              trailing: Text(data.rssi.toString()),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }
                    return const Center(child: Text('No devices found'));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
