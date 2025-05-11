import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jem_disco/model/device.dart';
import 'package:jem_disco/data/services/permission_manager/permission_manager_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<FlutterReactiveBle>(),
  MockSpec<Stream>(),
  MockSpec<PermissionManager>(),
])
import 'ble_controller_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var mockFlutterReactiveBle = MockFlutterReactiveBle();
  var mockPersmissionManager = MockPermissionManager();

  //fake bluetooth device
  DiscoveredDevice discoveredDevice1 = DiscoveredDevice(
    id: "12:23:34:45:56:57", name:  "DISCO", serviceData: {}, manufacturerData: Uint8List(0), rssi: -55, serviceUuids: [Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e")]
    );


  group(
    "Startup Logic Test", () {
      setUpAll(() {//this runs once before all the test
        when(mockPersmissionManager.requestBluetoothPermissions()).thenAnswer((realInvocation) {
          return Future(() {});
        });
        
        when(mockFlutterReactiveBle.status).thenAnswer((realInvocation) => BleStatus.ready);

        when(mockFlutterReactiveBle.scanForDevices(
            withServices: anyNamed('withServices'),
          )).thenAnswer((realInvocation) {
          return Stream.fromIterable([discoveredDevice1]);
        });

      });

      setUp(() {//this runs before each test
        //put code that needs to be reset here. 
        //e.g. SharedPreferences values that change during the test
      });

      test('callback is called for each discovered device', () async {
        final completer = Completer<void>();
        BleController underTest = BleController(flutterReactiveBle: mockFlutterReactiveBle, permissionManager: mockPersmissionManager);
        List<Device> devices = [];
        await underTest.startBluetoothScan((device) {
          devices.add(device);
          completer.complete();
        });

        verify(mockFlutterReactiveBle.scanForDevices(withServices: anyNamed('withServices'))).called(1);

        await completer.future.timeout(const Duration(seconds: 1), 
          onTimeout: () => throw TimeoutException('Device discovery callback was not called'));

        expect(devices, contains(Device(id: "12:23:34:45:56:57", name:  "DISCO")));
      });

      test('no previous device, first device accepted', () async {
       //for example
      });
      // more tests here...
    }
  );
}