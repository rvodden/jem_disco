import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:jem_disco/device.dart';
import 'package:provider/provider.dart';
import 'ble.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  final String title = "Discovered Devices";

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
  }

  void _startBluetoothScan() {
    BleController bleController = Provider.of<BleController>(context, listen: false);
    setState(() {
      isScanning = true;
    });

    bleController.startBluetoothScan((DiscoveredDevice discoveredDevice) {
      developer.log(
        'Discovered Device: ${discoveredDevice.name}: ${discoveredDevice.id}',
      );
    });
  }

  void _stopBluetoothScan() {
    BleController bleController = Provider.of<BleController>(context, listen: false);
    setState(() {
      isScanning = false;
    });
    bleController.stopBluetoothScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.search),
            onPressed: isScanning ? _stopBluetoothScan : _startBluetoothScan,
            tooltip: isScanning ? 'Stop Scan' : 'Start Scan',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Discovered Devices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DiscoveredDevice>>(
              stream: Provider.of<BleController>(context).deviceStream,
              initialData: const [],
              builder: (context, snapshot) {
                final devices = snapshot.data ?? [];

                if (isScanning && devices.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Scanning for devices...'),
                      ],
                    ),
                  );
                }

                if (!isScanning && devices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No devices found'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _startBluetoothScan,
                          child: const Text('Start Scan'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.id),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _stopBluetoothScan();
                          Navigator.pop(context, Device(id: device.id, name: device.name));
                        },
                        child: const Text('Connect'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          isScanning
              ? FloatingActionButton(
                onPressed: _stopBluetoothScan,
                tooltip: 'Stop Scan',
                child: const Icon(Icons.stop),
              )
              : FloatingActionButton(
                onPressed: _startBluetoothScan,
                tooltip: 'Start Scan',
                child: const Icon(Icons.bluetooth_searching),
              ),
    );
  }
}
