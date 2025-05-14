import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../view_model/device_list_view_model.dart';

class DeviceListScreen extends StatelessWidget {
  final DeviceListViewModel _model;
  const DeviceListScreen({super.key, required model}) : _model = model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_model.title),
        actions: [
          IconButton(
            icon: Icon(_model.isScanning ? Icons.stop : Icons.search),
            onPressed: _model.isScanning ? _model.stopScan : _model.startScan,
            tooltip: _model.isScanning ? 'Stop Scan' : 'Start Scan',
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
            child: Builder(
              builder: (context) {
                if (_model.devices.isEmpty) {
                  if (_model.isScanning) {
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
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No devices found'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _model.startScan,
                            child: const Text('Start Scan'),
                          ),
                        ],
                      ),
                    );
                  }
                }

                return ListView.builder(
                  itemCount: _model.devices.length,
                  itemBuilder: (context, index) {
                    final device = _model.devices[index];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.id),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _model.stopScan();
                          _model.connect(device);
                          Navigator.pop(context);
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
          _model.isScanning
              ? FloatingActionButton(
                onPressed: _model.stopScan,
                tooltip: 'Stop Scan',
                child: const Icon(Icons.stop),
              )
              : FloatingActionButton(
                onPressed: _model.startScan,
                tooltip: 'Start Scan',
                child: const Icon(Icons.bluetooth_searching),
              ),
    );
  }
}
