import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shared/src/network_discovery/network_client.dart';
import 'package:flutter_shared/src/utils/utils.dart';
import 'package:multicast_dns/multicast_dns.dart';

class Bonjour extends ChangeNotifier {
  Bonjour({
    this.serviceType = '_path-finder._tcp',
    this.port = 8765,
    this.serviceName = 'Path Finder',
  });

  final String serviceType;
  final int port;
  final String serviceName;

  BonsoirService broadcastService;
  BonsoirBroadcast broadcast;
  BonsoirDiscovery discovery;
  final List<ResolvedBonsoirService> _resolvedServices = [];
  final List<SrvResourceRecord> _resolvedServicesWeb = [];

  List<NetworkClient> get clients {
    return _resolvedServices.map((x) {
      return NetworkClient(name: x.name, url: 'http://${x.ip}:${x.port}');
    }).toList();
  }

  List<NetworkClient> get webClients {
    return _resolvedServicesWeb.map((x) {
      return NetworkClient(name: x.name, url: 'http://${x.target}:${x.port}');
    }).toList();
  }

  Future<void> startBroadcast() async {
    if (broadcastService != null) {
      return;
    }

    broadcastService = BonsoirService(
      name: serviceName,
      type: serviceType,
      port: port,
    );

    broadcast = BonsoirBroadcast(service: broadcastService);
    await broadcast.ready;
    await broadcast.start();
  }

  Future<void> stopBroadcast() async {
    await broadcast.stop();
  }

  Future<void> startDiscovery() async {
    if (Utils.isWeb) {
      await _startWebDiscovery();
    } else {
      if (discovery != null) {
        return;
      }

      discovery = BonsoirDiscovery(type: serviceType);
      await discovery.ready;
      await discovery.start();

      discovery.eventStream.listen((event) {
        if (event.type ==
            BonsoirDiscoveryEventType.DISCOVERY_SERVICE_RESOLVED) {
          final ResolvedBonsoirService service =
              event.service as ResolvedBonsoirService;

          print('Service found : ${service.toJson()}');
          _resolvedServices.add(service);
          notifyListeners();
        } else if (event.type ==
            BonsoirDiscoveryEventType.DISCOVERY_SERVICE_LOST) {
          _resolvedServices.remove(event.service);
          notifyListeners();

          print('Service lost : ${event.service.toJson()}');
        }
      });
    }
  }

  Future<void> stopDiscovery() async {
    await discovery?.stop();

    discovery = null;
  }

  Future<void> _startWebDiscovery() async {
    // Parse the command line arguments.

    final MDnsClient client = MDnsClient();
    await client.start();

    final pointers = client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceType));

    // Get the PTR record for the service.
    await for (final PtrResourceRecord ptr in pointers) {
      // Use the domainName from the PTR record to get the SRV record,
      // which will have the port and local hostname.
      // Note that duplicate messages may come through, especially if any
      // other mDNS queries are running elsewhere on the machine.

      final records = client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName));

      await for (final SrvResourceRecord srv in records) {
        // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
        final String bundleId =
            ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
        print('Dart observatory instance found at '
            '${srv.target}:${srv.port} for "$bundleId".');

        _resolvedServicesWeb.add(srv);
      }
    }
    client.stop();

    print('Done.');
  }
}
