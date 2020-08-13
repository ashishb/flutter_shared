import 'package:flutter/material.dart';
import 'package:flutter_shared/src/network_discovery/network_client.dart';
import 'package:multicast_dns/multicast_dns.dart';

class BonjourWeb extends ChangeNotifier {
  BonjourWeb({
    this.serviceType = '_path-finder._tcp',
    this.port = 8765,
    this.serviceName = 'Path Finder',
  });

  final String serviceType;
  final int port;
  final String serviceName;

  final List<SrvResourceRecord> _resolvedServicesWeb = [];

  List<NetworkClient> get clients {
    return _resolvedServicesWeb.map((x) {
      return NetworkClient(name: x.name, url: 'http://${x.target}:${x.port}');
    }).toList();
  }

  Future<void> startDiscovery() async {
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
