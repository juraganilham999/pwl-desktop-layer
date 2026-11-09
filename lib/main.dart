import 'package:flutter/material.dart';

void main() {
  runApp(const PWLApp());
}

class PWLApp extends StatelessWidget {
  const PWLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PWL Desktop Layer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF202020),
      ),
      home: const PWLDesktopShell(),
    );
  }
}

class PWLDesktopShell extends StatefulWidget {
  const PWLDesktopShell({super.key});

  @override
  State<PWLDesktopShell> createState() => _PWLDesktopShellState();
}

class _PWLDesktopShellState extends State<PWLDesktopShell> {
  final List<String> _openWindows = [];

  void _openApp(String appName) {
    setState(() {
      if (!_openWindows.contains(appName)) {
        _openWindows.add(appName);
      }
    });
  }

  void _closeApp(String appName) {
    setState(() {
      _openWindows.remove(appName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Desktop Wallpaper & Icons Area
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1E1E2E),
              child: GridView.count(
                crossAxisCount: 6,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildDesktopIcon(Icons.folder, 'File Manager', () => _openApp('File Manager')),
                  _buildDesktopIcon(Icons.language, 'Web Browser', () => _openApp('Web Browser')),
                  _buildDesktopIcon(Icons.music_note, 'Music Player', () => _openApp('Music Player')),
                  _buildDesktopIcon(Icons.code, 'Code Editor', () => _openApp('Code Editor')),
                  _buildDesktopIcon(Icons.storage, 'SQL Studio', () => _openApp('SQL Studio')),
                ],
              ),
            ),
          ),
          
          // Open Windows Container
          for (var app in _openWindows)
            Positioned(
              left: 50 + (_openWindows.indexOf(app) * 30).toDouble(),
              top: 50 + (_openWindows.indexOf(app) * 30).toDouble(),
              width: 400,
              height: 300,
              child: _buildWindow(app),
            ),

          // Bottom Taskbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 48,
            child: Container(
              color: const Color(0xFF11111B),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.grid_view, color: Colors.blue),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Start Menu Clicked')),
                      );
                    },
                  ),
                  const VerticalDivider(color: Colors.grey),
                  Row(
                    children: _openWindows.map((app) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Chip(
                        label: Text(app),
                        onDeleted: () => _closeApp(app),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildWindow(String title) {
    return Card(
      elevation: 8,
      color: const Color(0xFF313244),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF45475A),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                  onPressed: () => _closeApp(title),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Content of $title', style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
