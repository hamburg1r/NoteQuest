import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:notequest/screens/documents.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'screens/todo.dart';

part 'main.g.dart';

void main() async {
  Logger? logger;
  if (kDebugMode) {
    logger = Logger();
  }
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  logger?.i(path);

  Hive.init(path.path);
  Hive.initFlutter(path.path);
  //Hive.registerAdapter(TodoModel);
  await Hive.openBox<Map<dynamic, dynamic>>('todos');
  logger?.t('opened todos hive box');
  await Hive.openBox<String>('markdowns');
  logger?.t('opened markdowns hive box');
  await Hive.openBox<List<String>>('mainScreenTodos');
  logger?.t('opened mainScreenTodos hive box');
  await Hive.openBox<List<String>>('documents');
  logger?.t('opened documents hive box');

  runApp(ProviderScope(
    child: App(
      logger: logger,
    ),
  ));
}

class App extends StatelessWidget {
  const App({
    super.key,
    this.logger,
  });
  final Logger? logger;

  @override
  Widget build(BuildContext context) {
    logger?.t('Running app root build method');
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        logger?.t('setting colorscheme');
        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
          // (Optional) If applicable, harmonize custom colors.
          // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
          // darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
          // darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

          // _isDemoUsingDynamicColors = true; // ignore, only for demo purposes
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "NoteQuest",
          theme: ThemeData(
            // primaryColor: MaterialAccentColor(accentColor),
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          home: HomeScreen(
            logger: logger,
          ),
        );
      },
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    this.logger,
  });
  final Logger? logger;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  final placeholder = Center(child: Text("placeholder"));
  late final logger = widget.logger;

  @override
  Widget build(BuildContext context) {
    int widgetIndex = ref.watch(indexStorageProvider);
    logger?.t('Running HomeScreen build method');
    appBar(
      Widget title, [
      List<Widget> actions = const [],
    ]) =>
        AppBar(
          title: title,
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
          actions: actions,
        );
    logger?.t('Adding scaffolds in screen list');
    var screens = <Widget>[
      Todo(
        appBar,
        logger: logger,
      ),
      Documents(
        appBar,
        logger: logger,
      ),
      Scaffold(
          appBar: AppBar(
            title: Text("2"),
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
          ),
          body: placeholder,
          floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () => print("sup sucka"),
            child: Icon(Icons.add),
          )),
    ];

    return AdvancedDrawer(
      backdrop: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).focusColor,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
        //   ),
        // ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: const Duration(milliseconds: 500),
      animateChildDecoration: true,
      rtlOpening: false,
      openScale: 0.83,
      openRatio: 0.6,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 1.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              ListTile(
                onTap: () {
                  if (widgetIndex != 0) {
                    setState(() {
                      ref.read(indexStorageProvider.notifier).update(0);
                    });
                  }
                },
                leading: Icon(Icons.notes),
                title: Text('Todo'),
              ),
              ListTile(
                onTap: () {
                  if (widgetIndex != 1) {
                    setState(() {
                      ref.read(indexStorageProvider.notifier).update(1);
                    });
                  }
                },
                leading: Icon(Icons.folder),
                title: Text('Documents'),
              ),
              ListTile(
                onTap: () {
                  if (widgetIndex != 2) {
                    setState(() {
                      ref.read(indexStorageProvider.notifier).update(2);
                    });
                  }
                },
                leading: Icon(Icons.calendar_month),
                title: Text('Calendar'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              Spacer(flex: 4),
            ],
          ),
        ),
      ),
      child: screens[widgetIndex],
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}

@riverpod
class IndexStorage extends _$IndexStorage {
  @override
  int build() {
    // Initial value
    return 0;
  }

  void update(int value) {
    state = value;
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
