import 'package:flutter/material.dart';

void main() {
  runApp(const BoviCareApp());
}

const forest = Color(0xFF176B45);
const green = Color(0xFF238653);
const cream = Color(0xFFF8F7F0);
const ink = Color(0xFF20352A);
const muted = Color(0xFF77857A);

class BoviCareApp extends StatelessWidget {
  const BoviCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BoviCare',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: forest),
      ),
      home: const HomeScreen(),
    );
  }
}

class Cow {
  const Cow({required this.name, required this.id, required this.status});

  final String name;
  final String id;
  final String status;
}

class HealthRecord {
  const HealthRecord();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  bool marathi = false;
  final List<Cow> cows = [];
  final List<HealthRecord> records = [];

  String _translate(String english, String marathiText) {
    return marathi ? marathiText : english;
  }

  void _selectTab(int index) {
    setState(() => selectedTab = index);
  }

  List<Widget> get pages => [
    DashboardScreen(
      cows: cows,
      records: records,
      marathi: marathi,
      tr: _translate,
      onAssess: () => _selectTab(2),
      onCows: () => _selectTab(1),
      onRecords: () => _selectTab(3),
    ),
    const SimpleScreen(
      icon: Icons.pets_rounded,
      title: 'My Cows',
      subtitle: 'Your registered cows will appear here.',
    ),
    const SimpleScreen(
      icon: Icons.health_and_safety_rounded,
      title: 'Health Assessment',
      subtitle: 'Record symptoms and review screening guidance.',
    ),
    const SimpleScreen(
      icon: Icons.history_rounded,
      title: 'Health Records',
      subtitle: 'Your saved observations will appear here.',
    ),
    const SimpleScreen(
      icon: Icons.person_rounded,
      title: 'Your Profile',
      subtitle: 'Manage your farm information.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: selectedTab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: _selectTab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDDEFE2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            label: 'My Cows',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            label: 'Assess',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.cows,
    required this.records,
    required this.marathi,
    required this.tr,
    required this.onAssess,
    required this.onCows,
    required this.onRecords,
  });

  final List<Cow> cows;
  final List<HealthRecord> records;
  final bool marathi;
  final String Function(String, String) tr;
  final VoidCallback onAssess;
  final VoidCallback onCows;
  final VoidCallback onRecords;

  static const Color forest = Color(0xFF176B45);
  static const Color cream = Color(0xFFF8F7F0);
  static const Color ink = Color(0xFF20352A);
  static const Color muted = Color(0xFF77857A);

  @override
  Widget build(BuildContext context) {
    final total = cows.length;
    final healthy = cows.where((c) => c.status == 'Healthy').length;
    final monitor = total - healthy;

    return Container(
      color: cream,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                // BoviCare branding and notification
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF176B45),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 11),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BoviCare',
                            style: TextStyle(
                              color: Color(0xFF176B45),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'YOUR FARM, HEALTHIER',
                            style: TextStyle(
                              color: Color(0xFF77857A),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE7EAE1)),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF20352A),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 23),

                // Farmer greeting
                const Text(
                  'Good morning, Farmer 👋',
                  style: TextStyle(
                    color: Color(0xFF20352A),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Every cow matters. Let's check in on your herd.",
                  style: TextStyle(
                    color: Color(0xFF77857A),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // HERO BANNER
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    height: 205,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 1. Full-width cow photograph
                        Image.asset(
                          'asset/images/cow_banner.jpeg',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('BoviCare cow image failed: $error');
                            return Container(
                              color: const Color(0xFF176B45),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: const Icon(
                                Icons.pets_rounded,
                                size: 85,
                                color: Colors.white54,
                              ),
                            );
                          },
                        ),

                        // 2. Dark green overlay behind the text
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF07583C),
                                Color(0xF207583C),
                                Color(0xB807583C),
                                Color(0x0007583C),
                              ],
                              stops: [0.0, 0.40, 0.62, 1.0],
                            ),
                          ),
                        ),

                        // 3. Banner text and button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 14, 12, 14),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 245,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF29996A),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.eco_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'HERD HEALTH',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Healthy cows,\nbetter tomorrow.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      height: 1.08,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  const Text(
                                    'Spot changes early. Record\nobservations. Care better.',
                                    style: TextStyle(
                                      color: Color(0xFFE1EEE5),
                                      fontSize: 11,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 35,
                                    child: FilledButton(
                                      onPressed: onAssess,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(
                                          0xFF07583C,
                                        ),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Start check',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 23),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Explore heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF20352A),
                          ),
                        ),
                        InkWell(
                          onTap: onCows,
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'See all',
                                  style: TextStyle(
                                    color: Color(0xFF176B45),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 13,
                                  color: Color(0xFF176B45),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Horizontal category tiles
                    SizedBox(
                      height: 78,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _exploreTile(
                            icon: Icons.pets_rounded,
                            label: 'My Cows',
                            background: const Color(0xFFE5F0DF),
                            onTap: onCows,
                          ),
                          _exploreTile(
                            icon: Icons.health_and_safety_rounded,
                            label: 'Symptoms',
                            background: const Color(0xFFFFF0CC),
                            onTap: onAssess,
                          ),
                          _exploreTile(
                            icon: Icons.water_drop_rounded,
                            label: 'Udder Health',
                            background: const Color(0xFFE5F0DF),
                            onTap: onAssess,
                          ),
                          _exploreTile(
                            icon: Icons.history_rounded,
                            label: 'Records',
                            background: const Color(0xFFFFF0CC),
                            onTap: onRecords,
                          ),
                          _exploreTile(
                            icon: Icons.notifications_active_outlined,
                            label: 'Reminders',
                            background: const Color(0xFFE5F0DF),
                            onTap: onRecords,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading and View all
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Your herd at a glance',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF20352A),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: onCows,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 8),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View all',
                                style: TextStyle(
                                  color: Color(0xFF176B45),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 12,
                                color: Color(0xFF176B45),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Three compact statistic cards
                    Row(
                      children: [
                        Expanded(
                          child: _herdStatCard(
                            icon: Icons.pets_rounded,
                            value: '$total',
                            label: 'Total cows',
                            iconBackground: const Color(0xFFDFF0E2),
                            iconColor: const Color(0xFF176B45),
                            decorationColor: const Color(0xFFDFF2E2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _herdStatCard(
                            icon: Icons.check_circle_rounded,
                            value: '$healthy',
                            label: 'Healthy',
                            iconBackground: const Color(0xFFDFF0E2),
                            iconColor: const Color(0xFF176B45),
                            decorationColor: const Color(0xFFDFF2E2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _herdStatCard(
                            icon: Icons.visibility_rounded,
                            value: '$monitor',
                            label: 'To monitor',
                            iconBackground: const Color(0xFFFFEFC6),
                            iconColor: const Color(0xFFAE7414),
                            decorationColor: const Color(0xFFFFF1CE),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 23),

                // RECENTLY CHECKED COWS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr('Your cows', 'तुमच्या गायी'),
                      style: const TextStyle(
                        color: ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: onCows,
                      child: Text(
                        tr('See all →', 'सर्व पहा →'),
                        style: const TextStyle(color: forest),
                      ),
                    ),
                  ],
                ),
                if (cows.isEmpty)
                  _emptyCows()
                else
                  ...cows
                      .take(3)
                      .map(
                        (cow) => Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: const Color(0xFFE7EAE1)),
                          ),
                          child: ListTile(
                            onTap: onCows,
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFDDEFE2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.pets_rounded,
                                color: forest,
                              ),
                            ),
                            title: Text(
                              cow.name,
                              style: const TextStyle(
                                color: ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${cow.id} · ${cow.status}',
                              style: const TextStyle(
                                color: muted,
                                fontSize: 12,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                          ),
                        ),
                      ),

                const SizedBox(height: 13),

                // RECENT ACTIVITY
                Material(
                  color: const Color(0xFFE7F3E5),
                  borderRadius: BorderRadius.circular(13),
                  child: InkWell(
                    onTap: onRecords,
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      height: 62,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          // Calendar icon
                          Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9EED9),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.calendar_month_outlined,
                              color: Color(0xFF176B45),
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 11),

                          // Activity title and subtitle
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recent health activity',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF20352A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  records.isEmpty
                                      ? 'No assessments saved yet'
                                      : '${records.length} saved assessments',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF77857A),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Right arrow
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF176B45),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _exploreTile({
    required IconData icon,
    required String label,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 13),
      child: SizedBox(
        width: 54,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 49,
                height: 45,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 25, color: const Color(0xFF15583B)),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 68,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  style: const TextStyle(
                    color: Color(0xFF202B24),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _herdStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconBackground,
    required Color iconColor,
    required Color decorationColor,
  }) {
    return Container(
      height: 87,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFECEDE5), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF20352A).withValues(alpha: 0.035),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Soft decorative curved corner
          Positioned(
            right: -10,
            bottom: -19,
            child: Container(
              width: 68,
              height: 49,
              decoration: BoxDecoration(
                color: decorationColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(42),
                ),
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 7, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 19, color: iconColor),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF173D2D),
                    fontSize: 20,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF77857A),
                        fontSize: 9,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCows() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        tr(
          'No cows registered yet. Add your first cow in My Cows.',
          'अजून गाय नोंदवलेली नाही. माझ्या गायी विभागात गाय जोडा.',
        ),
        style: const TextStyle(color: muted),
      ),
    );
  }
}

class PremiumActionCard extends StatelessWidget {
  const PremiumActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.value,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE7EAE1)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEFE2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF176B45), size: 25),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF20352A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF77857A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: 12),
                Text(
                  value!,
                  style: const TextStyle(
                    color: Color(0xFF20352A),
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF77857A)),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleScreen extends StatelessWidget {
  const SimpleScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F0E3),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(icon, color: forest, size: 48),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: const TextStyle(
                color: ink,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
