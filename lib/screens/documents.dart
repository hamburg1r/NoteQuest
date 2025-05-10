import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents.g.dart';

class Documents extends ConsumerStatefulWidget {
  final Function(Text, List<Widget>) appbar;
  final Logger? logger;
  const Documents(
    this.appbar, {
    super.key,
    this.logger,
  });

  Future<void> requestMediaPermissions() async {
    Map<Permission, PermissionStatus> statuses;
    statuses = await [Permission.manageExternalStorage].request();

    logger?.d(statuses);

    if (statuses[Permission.manageExternalStorage]!.isDenied) {
      openAppSettings();
      statuses = await [Permission.manageExternalStorage].request();
      if (statuses[Permission.manageExternalStorage]!.isDenied) {}
    }
  }

  ListTile createTile(String path) {
    var mime = lookupMimeType(path);
    ListTile res = ListTile(
      title: Text(path),
    );
    logger?.i(mime);
    if (mime == 'text/plain') {
      res = ListTile(
        title: Text(path),
      );
    }
    return res;
  }

  @override
  ConsumerState<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends ConsumerState<Documents> {
  @override
  Widget build(BuildContext context) {
    List<String> documents = ref.watch(documentsStoreProvider);
    widget.logger?.i("documents: $documents");
    var documentsNotifier = ref.read(documentsStoreProvider.notifier);

    widget.logger?.d('Build method running');
    widget.requestMediaPermissions();
    return Scaffold(
      appBar: widget.appbar(
        Text("Documents"),
        [
          // IconButton(
          //   onPressed: () {
          //   },
          //   icon: Icon(Icons.delete),
          //   tooltip: 'Clear All',
          // ),
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  await documentsNotifier.clear();
                },
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    Text('Delete all'),
                  ],
                ),
              )
            ],
            // child: Icon(Icons.explicit),
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                //focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext ctx, int index) {
          return widget.createTile(documents[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          var res = await FilePicker.platform.pickFiles(
            allowMultiple: true,
          );
          widget.logger?.d(res?.paths);
          res?.paths.forEach(documentsNotifier.add);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

@riverpod
class DocumentsStore extends _$DocumentsStore {
  final Box<String> _documentBox = Hive.box<String>('documents');

  @override
  List<String> build() {
    return updateState();
  }

  void add(String? value) {
    if (value != null) {
      _documentBox.add(value);
    }
    updateState();
  }

  void addMultiple(List<String> value) {
    _documentBox.addAll(value);
    updateState();
  }

  Future<void> clear() async {
    await _documentBox.clear();
    state = [];
  }

  List<String> updateState() {
    state = _documentBox.values.toList();
    return state;
  }
}
