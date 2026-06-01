import 'package:flutter/material.dart';
import 'package:auto_shimmer_widget/auto_shimmer_widget.dart';

void main() {
  runApp(const AutoShimmerDarkModeTestApp());
}

class AutoShimmerDarkModeTestApp extends StatefulWidget {
  const AutoShimmerDarkModeTestApp({super.key});

  @override
  State<AutoShimmerDarkModeTestApp> createState() =>
      _AutoShimmerDarkModeTestAppState();
}

class _AutoShimmerDarkModeTestAppState
    extends State<AutoShimmerDarkModeTestApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8FB),
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: AutoShimmerDarkModeTestPage(
        isDark: isDark,
        onToggleTheme: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

class AutoShimmerDarkModeTestPage extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const AutoShimmerDarkModeTestPage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _compareLayout({
    required Widget shimmer,
    required Widget original,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('AutoShimmer'),
        shimmer,
        const SizedBox(height: 20),
        _label('Original Widget'),
        original,
      ],
    );
  }

  Widget _profileCard() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 34),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vinod Metha'),
                    SizedBox(height: 8),
                    Text('Flutter Developer'),
                  ],
                ),
              ),
              Icon(Icons.more_vert),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 8),
              Text('Bangalore, India'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Follow'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCard() {
    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: const Icon(
              Icons.image,
              size: 60,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premium Wireless Headphone'),
                SizedBox(height: 8),
                Text('Noise cancellation | 40hr battery'),
                SizedBox(height: 18),
                Text('₹4,999'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listCard() {
    return SizedBox(
      height: 310,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _userTile('Vinod', 'Flutter Developer'),
          _userTile('Rahul', 'Backend Developer'),
          _userTile('Alex', 'UI Designer'),
        ],
      ),
    );
  }

  Widget _userTile(String name, String role) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const CircleAvatar(radius: 24),
        title: Text(name),
        subtitle: Text(role),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }

  Widget _arabicCard() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(radius: 34),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('فينود ميثا'),
                      SizedBox(height: 8),
                      Text('مطوّر فلاتر أول'),
                    ],
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8),
                Text('بنغالور، الهند'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('متابعة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('رسالة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _testBlock({
    required String title,
    required Widget child,
    ShimmerAnimationType animationType = ShimmerAnimationType.slide,
    ShimmerDirection direction = ShimmerDirection.startToEnd,
    TextDirection? textDirection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        _compareLayout(
          shimmer: AutoShimmer(
            themeMode: ShimmerThemeMode.system,
            animationType: animationType,
            direction: direction,
            textDirection: textDirection,
            speed: const Duration(milliseconds: 1100),
            child: child,
          ),
          original: child,
        ),
      ],
    );
  }

  Widget _manualDarkShimmerBlock() {
    final child = _productCard();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('5. Force Dark Shimmer'),
        _compareLayout(
          shimmer: AutoShimmer(
            themeMode: ShimmerThemeMode.dark,
            animationType: ShimmerAnimationType.glow,
            direction: ShimmerDirection.topLeftToBottomRight,
            speed: const Duration(milliseconds: 1300),
            child: child,
          ),
          original: child,
        ),
      ],
    );
  }

  Widget _manualLightShimmerBlock() {
    final child = _profileCard();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('6. Force Light Shimmer'),
        _compareLayout(
          shimmer: AutoShimmer(
            themeMode: ShimmerThemeMode.light,
            animationType: ShimmerAnimationType.wave,
            direction: ShimmerDirection.leftToRight,
            speed: const Duration(milliseconds: 1000),
            child: child,
          ),
          original: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final modeText = isDark ? 'Dark Mode' : 'Light Mode';

    return Scaffold(
      appBar: AppBar(
        title: Text('AutoShimmer $modeText'),
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _testBlock(
            title: '1. Profile Card - System Theme',
            child: _profileCard(),
          ),
          _testBlock(
            title: '2. Product Card - System Theme',
            child: _productCard(),
            animationType: ShimmerAnimationType.wave,
          ),
          _testBlock(
            title: '3. ListView - System Theme',
            child: _listCard(),
            animationType: ShimmerAnimationType.breathe,
          ),
          _testBlock(
            title: '4. Arabic RTL - System Theme',
            child: _arabicCard(),
            direction: ShimmerDirection.startToEnd,
            textDirection: TextDirection.rtl,
          ),
          _manualDarkShimmerBlock(),
          _manualLightShimmerBlock(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
