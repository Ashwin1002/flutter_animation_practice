import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/src/animated_splash/animated_splash_screen.dart';
import 'package:flutter_animation_practice/src/animated_tabbar_scroll/tab_bar_scrollable.dart';
import 'package:flutter_animation_practice/src/logo_loading/logo_loading_widget.dart';
import 'package:flutter_animation_practice/src/overlay_widget/autocomplete_overlay_widget.dart';
import 'package:flutter_animation_practice/src/render_object_chat/chat_widget.dart';
import 'package:flutter_animation_practice/src/sliverpersisentheaderdelegate/detail_page.dart';
import 'package:flutter_animation_practice/src/staggered_animation/staggered_animation_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets Practice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AlbumDetailPage(),
                ),
              ),
              child: const Text('Custom Sliver App bar delegate'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AnimatedSplashScreen(),
                ),
              ),
              child: const Text('Animated Splash Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LogoLoadingWidget(),
                ),
              ),
              child: const Text('Skill Sewa Logo Loading'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StaggeredDemo(),
                ),
              ),
              child: const Text('Staggered Animation Demo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatBubbleRenderWidget(),
                ),
              ),
              child: const Text('Render Object Chat Text Bubble Demo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const AutoCompleteSearchableOverlayWidgt(),
                ),
              ),
              child: const Text('Overlay AutoComplete Form Field'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CustomScrollableTabBar(),
                ),
              ),
              child: const Text('Scrollable Tab Bar'),
            ),
          ],
        ),
      ),
    );
  }
}

class TestLifeCycle extends StatefulWidget {
  const TestLifeCycle({super.key});

  @override
  State<TestLifeCycle> createState() => _TestLifeCycleState();
}

class _TestLifeCycleState extends State<TestLifeCycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
