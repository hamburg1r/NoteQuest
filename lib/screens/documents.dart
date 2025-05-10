import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class Documents extends ConsumerStatefulWidget {
  final Function(Text, List<Widget>) appbar;
  final Logger? logger;
  const Documents(
    this.appbar, {
    super.key,
    this.logger,
  });

  @override
  ConsumerState<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends ConsumerState<Documents> {
  late Map<Permission, PermissionStatus> statuses;
  late Logger? logger = widget.logger;

  Future<void> requestMediaPermissions() async {
    statuses = await [Permission.manageExternalStorage].request();

    logger?.d(statuses);

    if (statuses[Permission.manageExternalStorage]!.isDenied) {
      openAppSettings();
      statuses = await [Permission.manageExternalStorage].request();
      if (statuses[Permission.manageExternalStorage]!.isDenied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Denied')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    logger?.d('Build method running');
    requestMediaPermissions();
    return Scaffold(
      appBar: widget.appbar(Text("Documents"), []),
      // body: placeholder,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          var res = await FilePicker.platform.pickFiles(
            allowMultiple: true,
          );
          logger?.d(res?.paths);
          res?.paths.forEach((path) {
            logger?.i(path);
            // return path;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
