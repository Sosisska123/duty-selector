import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

Future<PackageInfo> getCurrentVersion() async =>
    await PackageInfo.fromPlatform();

Future<http.Response> getLatestVersion() async {
  return await http.get(
    Uri.parse(
      'https://api.github.com/repos/sosisska123/duty-selector/releases/latest',
    ),
  );
}

Future<bool> isUpdateAvailable() async {
  final pkgVersion = await getCurrentVersion().then((info) => info.version);

  final response = await getLatestVersion();

  // if (response.statusCode != 200) throw UpdateError();
  if (response.statusCode != 200) return false;

  final data = jsonDecode(response.body);
  final latestVersion = data['tag_name'].toString().replaceFirst('v', '');

  return Version.parse(latestVersion) > Version.parse(pkgVersion);
}
