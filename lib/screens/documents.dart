import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:notequest/utils.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:photo_view/photo_view.dart';

part 'documents.g.dart';

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
  Future<void> requestMediaPermissions() async {
    Map<Permission, PermissionStatus> statuses;
    statuses = await [Permission.manageExternalStorage].request();

    widget.logger?.d(statuses);

    if (statuses[Permission.manageExternalStorage]!.isDenied) {
      openAppSettings();
      statuses = await [Permission.manageExternalStorage].request();
      if (statuses[Permission.manageExternalStorage]!.isDenied) {}
    }
  }

  Widget createFolders(
    String name,
    int items,
    BuildContext context,
    DocumentsStore documentNotifier,
  ) {
    return ListTile(
      leading: Icon(Icons.folder),
      title: Text(name),
      subtitle: Text('$items items'),
      onTap: () {
        makeRoute(
          context,
          FilesView(
            folder: name,
            title: name,
          ),
        ).then((_) {
          setState(() {});
        });
      },
      trailing: MenuAnchor(
        menuChildren: [
          if (items > 0)
            MenuItemButton(
              onPressed: () async {
                await documentNotifier.empty(name);
                setState(() {});
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
              await documentNotifier.deletefolder(name);
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
    Map<String, Set<String>> documents = ref.watch(documentsStoreProvider);
    widget.logger?.i("documents: $documents");
    var documentsNotifier = ref.read(documentsStoreProvider.notifier);

    widget.logger?.d('Build method running');
    requestMediaPermissions();
    return Scaffold(
      appBar: widget.appbar(
        Text("Documents"),
        [
          IconButton(
            onPressed: () async {
              await documentsNotifier.deleteAll();
            },
            icon: Icon(Icons.clear_all),
          )
          // MenuAnchor(
          //   menuChildren: [
          //     MenuItemButton(
          //       onPressed: () async {
          //         await documentsNotifier.deleteAll();
          //       },
          //       child: Row(
          //         children: [
          //           Icon(Icons.delete),
          //           Text('Delete all'),
          //         ],
          //       ),
          //     )
          //   ],
          //   // child: Icon(Icons.explicit),
          //   builder: (_, MenuController controller, Widget? child) {
          //     return IconButton(
          //       //focusNode: _buttonFocusNode,
          //       onPressed: () {
          //         if (controller.isOpen) {
          //           controller.close();
          //         } else {
          //           controller.open();
          //         }
          //       },
          //       icon: const Icon(Icons.more_vert),
          //     );
          //   },
          // ),
        ],
      ),
      body: ListView.builder(
        itemCount: documents.keys.length,
        itemBuilder: (BuildContext ctx, int index) {
          return createFolders(
            documents.keys.elementAt(index),
            documents[documents.keys.elementAt(index)]?.length ?? 0,
            context,
            documentsNotifier,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController _controller = TextEditingController();
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
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FilesView extends ConsumerStatefulWidget {
  final String folder;
  final String? title;
  const FilesView({
    required this.folder,
    this.title,
    super.key,
  });

  @override
  ConsumerState<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends ConsumerState<FilesView> {
  Future<ListTile> createTile(
    String path,
    DocumentsStore documentsNotifier,
    BuildContext ctx,
  ) async {
    File file = File(path);
    var mime = lookupMimeType(path);
    String name = basenameWithoutExtension(path);
    String ext = extension(path);

    Widget heading = Expanded(
      child: Text(
        '$name$ext',
        style: Theme.of(ctx).textTheme.titleSmall,
      ),
    );
    Widget? content = Text(mime ?? 'unknown mime type');
    Widget body = Center(
      child: Text(
        "No preview available",
        style: Theme.of(ctx).textTheme.displaySmall,
      ),
    );
    Widget? icon = Icon(
      Icons.insert_drive_file,
      color: Colors.grey,
    );
    Widget? menu = MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () async {
            await documentsNotifier.delete(path, widget.folder);
            setState(() {});
          },
          child: Row(
            children: [
              Icon(Icons.clear),
              Text('Remove'),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () async {
            await documentsNotifier.delete(path, widget.folder);
            setState(() {});
          },
          child: Row(
            children: [
              Icon(Icons.delete),
              Text('Delete from disk'),
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
    );

    if (mime == 'text/plain') {
      var lines = await file.readAsLines();
      if (lines.length >= 2) {
        content = Text('${lines[0]}\n${lines[1]}\n...');
      } else if (lines.isNotEmpty) {
        content = Text(lines.join('\n'));
      } else {
        content = Text('Empty');
      }
      // FIXME: move to a different widget
      body = FutureBuilder<String>(
        future: file.readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final lines = snapshot.data!.split('\n');
            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: lines.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}'.padLeft(4, ' '),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lines[index],
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('File is empty'));
          }
        },
      );
    } else if (mime?.startsWith('image/') ?? false) {
      icon = Icon(
        Icons.image,
        color: Colors.orange,
      );
      content = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final size = constraints.maxWidth; // Get the max width of the parent
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.square(
              dimension: size, // Make it square and take the full width
              child: Image.file(
                file,
                fit: BoxFit.cover, // Ensures it fills the square proportionally
              ),
            ),
          );
        },
      );
      body = PhotoView(
        imageProvider: FileImage(file),
        enableRotation: true,
      );
    } else if (mime?.endsWith('/pdf') ?? false) {
      content = null;
      icon = Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
      );
    } else if (RegExp(
            r'application/(msword|vnd\.openxmlformats-officedocument\.wordprocessingml\.(document|template)|vnd\.oasis\.opendocument\.text)')
        .hasMatch(mime ?? '')) {
      content = null;
      icon = Icon(
        Icons.description,
        color: Colors.blue,
      );
    } else if (RegExp(
            r'application/(vnd\.ms-excel|vnd\.openxmlformats-officedocument\.spreadsheetml\.(sheet|template)|vnd\.oasis\.opendocument\.spreadsheet)')
        .hasMatch(mime ?? '')) {
      content = null;
      icon = Icon(
        Icons.table_chart,
        color: Colors.green,
      );
    }

    return ListTile(
      title: Row(
        children: [
          icon,
          SizedBox.square(
            dimension: 8,
          ),
          heading,
          menu,
        ],
      ),
      subtitle: content != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: 4,
                ),
                content,
              ],
            )
          : null,
      // leading: icon,
      onTap: () {
        makeRoute(
          ctx,
          Scaffold(
            appBar: AppBar(
              title: Text(name),
            ),
            body: body,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Set<String>> documents = ref.watch(documentsStoreProvider);
    var documentsNotifier = ref.read(documentsStoreProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: widget.title != null ? Text(widget.title!) : null,
        actions: [
          IconButton(
            onPressed: () async {
              await documentsNotifier.empty(widget.folder);
              setState(() {});
            },
            icon: Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.separated(
          itemCount: documents[widget.folder]?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder<Widget>(
              future: createTile(
                documents[widget.folder]!.elementAt(index),
                documentsNotifier,
                context,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error loading item'),
                    subtitle: Text(snapshot.error.toString()),
                  );
                } else {
                  return snapshot.data!;
                }
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          FilePicker.platform
              .pickFiles(
            allowMultiple: true,
          )
              .then((res) {
            while (res?.paths.contains(null) ?? false) {
              res?.paths.remove(null);
            }
            documentsNotifier.addMultiple(
              res?.paths.cast<String>() ?? [],
              widget.folder,
            );
            setState(() {});
          });
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
  Map<String, Set<String>> build() {
    return updateState();
  }

  Future<void> add(String file, String folder) async {
    Set<String> newList = {...?state[folder], file};
    await _documentBox.put(folder, newList.toList());
    state[folder] = newList;
  }

  Future<void> addMultiple(List<String> files, String folder) async {
    Set<String> newList = {...?state[folder], ...files};
    await _documentBox.put(folder, newList.toList());
    state[folder] = newList;
  }

  Future<void> delete(String file, String folder) async {
    Set<String> newList = {...?state[folder]}..remove(file);
    await _documentBox.put(folder, newList.toList());
    state[folder] = newList;
  }

  Future<void> deletefolder(String folder) async {
    _logger.d('Deleting folder');
    await _documentBox.delete(folder);
    final updatedMap = Map<String, Set<String>>.from(state);
    updatedMap.remove(folder);
    state = updatedMap;
  }

  Future<void> empty(String folder) async {
    await _documentBox.put(folder, []);
    state[folder] = {};
  }

  Future<void> deleteAll() async {
    _logger.d('Clear called');
    await _documentBox.clear();
    state = {};
  }

  Map<String, Set<String>> updateState() {
    Map<String, Set<String>> state = {};
    for (String key in _documentBox.keys.toList().map((val) {
      return val.toString();
    })) {
      if (_documentBox.get(key) != null)
        state[key] = _documentBox.get(key)!.toSet();
    }
    return state;
  }
}
