import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter WebView Image Loader',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  late final WebViewController _webViewController;
  bool _isMenuOpen = false;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController =
        WebViewController()
          //..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.dataFromString(
              "<html><body><h2>Enter Image URL</h2></body></html>",
              mimeType: 'text/html',
            ),
          );
  }

  void _loadImage() {
    String imageUrl = _controller.text.trim();
    if (imageUrl.isEmpty) return;

    String htmlContent = '''
      <html>
        <body style="display: flex; justify-content: center; align-items: center; height: 100vh;">
          <img src="$imageUrl" style="max-width: 100%; max-height: 100%;" />
        </body>
      </html>
    ''';

    _webViewController.loadRequest(
      Uri.dataFromString(htmlContent, mimeType: 'text/html'),
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      _isMenuOpen = false; // Close the menu
    });
  }

  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _isFullscreen
              ? null
              : AppBar(title: const Text("WebView Image Loader")),
      body: Stack(
        children: [
          Column(
            children: [
              if (!_isFullscreen)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter Image URL',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _loadImage,
                        child: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ),
              Expanded(child: WebViewWidget(controller: _webViewController)),
            ],
          ),
          // Dimming Background When Menu is Open
          if (_isMenuOpen)
            GestureDetector(
              onTap: _closeMenu,
              child: Container(
                color: Colors.black54, // Dimming effect
              ),
            ),
          // Floating Action Button with Context Menu
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isMenuOpen) ...[
                  _buildMenuButton(
                    "Enter fullscreen",
                    _isFullscreen ? null : _toggleFullscreen,
                  ),
                  _buildMenuButton(
                    "Exit fullscreen",
                    _isFullscreen ? _toggleFullscreen : null,
                  ),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  onPressed: _toggleMenu,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback? onPressed) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: onPressed == null ? 0.5 : 1.0, // Disable button appearance
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.black54,
        ),
        child: Text(text),
      ),
    );
  }
}
