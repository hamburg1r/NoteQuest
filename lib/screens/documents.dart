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

  @override
  ConsumerState<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends ConsumerState<Documents> {
  String? folder;

  ListTile createTile(String path) {
    var mime = lookupMimeType(path);
    ListTile res = ListTile(
      title: Text(path),
    );
    if (mime == 'text/plain') {
      res = ListTile(
        title: Text(path),
      );
    }
    return res;
  }

  Widget createFolders(String name, int items) {
    return ListTile(
      leading: Icon(Icons.folder),
      title: Text(name),
      subtitle: Text('$items items'),
      onTap: () {
        setState(() {
          folder = name;
        });
      },
      trailing: MenuAnchor(
        menuChildren: [
          if (items > 0)
            MenuItemButton(
              onPressed: () async {
                await ref.read(documentsStoreProvider.notifier).empty(name);
              },
              child: Row(
                children: [
                  Icon(Icons.clear),
                  Text('Empty'),
                ],
              ),
            ),
          MenuItemButton(
            onPressed: () async {
              await ref
                  .read(documentsStoreProvider.notifier)
                  .deletefolder(name);
            },
            child: Row(
              children: [
                Icon(Icons.delete),
                Text('Delete'),
              ],
            ),
          ),
        ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> documents = ref.watch(documentsStoreProvider);
    widget.logger?.i("documents: $documents");
    var documentsNotifier = ref.read(documentsStoreProvider.notifier);

    widget.logger?.d('Build method running');
    widget.requestMediaPermissions();
    return Scaffold(
      appBar: folder == null
          ? widget.appbar(
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
                        await documentsNotifier.deleteAll();
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
            )
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    folder = null;
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
      body: ListView.builder(
        itemCount: folder == null
            ? documents.keys.length
            : documents[folder]?.length ?? 0,
        itemBuilder: (BuildContext ctx, int index) {
          if (folder == null) {
            return createFolders(
              documents.keys.elementAt(index),
              documents[documents.keys.elementAt(index)]?.length ?? 0,
            );
          }
          return createTile(documents[folder]![index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          if (folder == null) {
            showDialog(
              context: context,
              builder: (context) {
                final TextEditingController _controller =
                    TextEditingController();
                return AlertDialog(
                  title: Text('Enter Folder Name'),
                  content: TextField(
                    autofocus: true,
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Folder Name"),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        String folderName = _controller.text;
                        Navigator.of(context).pop();
                        documentsNotifier.addMultiple([], folderName);
                      },
                      child: Text('Create'),
                    ),
                  ],
                );
              },
            );
            return;
          }

          var res = await FilePicker.platform.pickFiles(
            allowMultiple: true,
          );
          while (res?.paths.contains(null) ?? false) {
            res?.paths.remove(null);
          }
          widget.logger?.d(res?.paths);
          // res?.paths.forEach((file) {
          //   if (file == null) return;
          //   documentsNotifier.add(file, folder!);
          // });
          documentsNotifier.addMultiple(
              res?.paths.cast<String>() ?? [], folder!);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

@riverpod
class DocumentsStore extends _$DocumentsStore {
  final Box<List<String>> _documentBox = Hive.box<List<String>>('documents');
  final Logger _logger = Logger();

  @override
  Map<String, List<String>> build() {
    return updateState();
  }

  Future<void> add(String file, String folder) async {
    List<String> newList = [...?state[folder], file];
    await _documentBox.put(folder, newList);
    state[folder] = newList;
  }

  Future<void> addMultiple(List<String> files, String folder) async {
    List<String> newList = [...?state[folder], ...files];
    await _documentBox.put(folder, newList);
    state[folder] = newList;
  }

  Future<void> delete(String file, String folder) async {
    List<String> newList = [...?state[folder]]..remove(file);
    await _documentBox.put(folder, newList);
    state[folder] = newList;
  }

  Future<void> deletefolder(String folder) async {
    _logger.d('Deleting folder');
    await _documentBox.delete(folder);
    final updatedMap = Map<String, List<String>>.from(state);
    updatedMap.remove(folder);
    state = updatedMap;
  }

  Future<void> empty(String folder) async {
    await _documentBox.put(folder, []);
    state[folder] = [];
  }

  Future<void> deleteAll() async {
    _logger.d('Clear called');
    await _documentBox.clear();
    state = {};
  }

  Map<String, List<String>> updateState() {
    Map<String, List<String>> state = {};
    for (String key in _documentBox.keys.toList().map((val) {
      return val.toString();
    })) {
      if (_documentBox.get(key) != null) state[key] = _documentBox.get(key)!;
    }
    return state;
  }
}
