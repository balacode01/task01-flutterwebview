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

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController =
        WebViewController()
          // ..setBackgroundColor(Colors.white)
          // ..setJavaScriptMode(
          //   JavaScriptMode.unrestricted,
          // ) // Ensure JavaScript mode works
          ..loadRequest(
            Uri.dataFromString(
              "<html><body style='display:flex; justify-content:center; align-items:center; height:100vh;'><h2>Enter Image URL</h2></body></html>",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebView Image Loader")),
      body: Column(
        children: [
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
    );
  }
}
