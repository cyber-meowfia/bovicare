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
  const HealthRecord({
    required this.cowName,
    required this.cowId,
    required this.date,
    required this.result,
    this.notes = '',
  });

  final String cowName;
  final String cowId;
  final DateTime date;
  final String result;
  final String notes;
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
    MyCowsPage(cows: cows, onBack: () => _selectTab(0)),
    AssessPage(onBack: () => _selectTab(0)),
    HealthRecordsPage(records: records, onBack: () => _selectTab(0)),
    const SimpleScreen(
      icon: Icons.person_rounded,
      title: 'Your Profile',
      subtitle: 'Manage your farm information.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
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
            selectedIcon: Icon(Icons.pets_rounded),
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
            constraints: const BoxConstraints(maxWidth: 1200),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
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
                          'asset/images/cow_assessment_banner.jpeg',
                          fit: BoxFit.contain,
                          alignment: const Alignment(0.55, 0.35),
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.pets_rounded,
                              color: Color(0xFF176B45),
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

class AssessPage extends StatelessWidget {
  const AssessPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F0),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Keep the content at a phone-like width in Chrome.
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AssessHeader(onBack: onBack),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Welcome to health screening',
                          style: TextStyle(
                            color: Color(0xFF20352A),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Record observations and check for possible warning signs.',
                          style: TextStyle(
                            color: Color(0xFF77857A),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      AssessmentBanner(
                        onAssessNow: () {
                          showMessage(
                            context,
                            'Assessment form will be connected next.',
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Before you begin',
                          style: TextStyle(
                            color: Color(0xFF20352A),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFFE7EAE1)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF176B45),
                                size: 22,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Choose the cow you want to assess and '
                                  'record any changes you observe. Screening '
                                  'provides guidance, not a veterinary diagnosis.',
                                  style: TextStyle(
                                    color: Color(0xFF77857A),
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCowsPage extends StatelessWidget {
  const MyCowsPage({super.key, required this.cows, required this.onBack});

  final List<Cow> cows;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final total = cows.length;
    final healthy = cows.where((cow) => cow.status == 'Healthy').length;
    final monitor = total - healthy;

    return Column(
      children: [
        MyCowsHeader(onBack: onBack, onAddCow: () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              HerdStatCard(
                icon: Icons.pets_rounded,
                value: '$total',
                label: 'Total cows',
                iconBackground: const Color(0xFFDDF0E0),
                iconColor: const Color(0xFF176B45),
                curveColor: const Color(0xFFE4F4E5),
              ),
              const SizedBox(width: 8),
              HerdStatCard(
                icon: Icons.check_circle_rounded,
                value: '$healthy',
                label: 'Healthy',
                iconBackground: const Color(0xFFDDF0E0),
                iconColor: const Color(0xFF176B45),
                curveColor: const Color(0xFFE4F4E5),
              ),
              const SizedBox(width: 8),
              HerdStatCard(
                icon: Icons.visibility_rounded,
                value: '$monitor',
                label: 'To monitor',
                iconBackground: const Color(0xFFFFEFC7),
                iconColor: const Color(0xFFAD7412),
                curveColor: const Color(0xFFFFF1CE),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: cows.isEmpty
              ? const SimpleScreen(
                  icon: Icons.pets_rounded,
                  title: 'My Cows',
                  subtitle: 'Your registered cows will appear here.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: cows.length,
                  itemBuilder: (context, index) {
                    final cow = cows[index];

                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFE7EAE1)),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFDDEFE2),
                          child: Icon(
                            Icons.pets_rounded,
                            color: Color(0xFF176B45),
                          ),
                        ),
                        title: Text(
                          cow.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF20352A),
                          ),
                        ),
                        subtitle: Text('${cow.id} • ${cow.status}'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({
    super.key,
    required this.records,
    required this.onBack,
  });

  final List<HealthRecord> records;
  final VoidCallback onBack;

  static const cream = Color(0xFFF8F7F0);
  static const forest = Color(0xFF176B45);
  static const ink = Color(0xFF20352A);
  static const muted = Color(0xFF77857A);

  @override
  Widget build(BuildContext context) {
    final followUps = records
        .where((r) => r.result.toLowerCase().contains('follow-up'))
        .length;

    return Container(
      color: cream,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Row(
                children: [
                  Material(
                    color: const Color(0xFFE5F2E4),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(14),
                      child: const SizedBox(
                        width: 44,
                        height: 46,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: forest,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Records',
                          style: TextStyle(
                            color: ink,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Track your herd's health history",
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  // Overview heading
                  const Text(
                    'Health overview',
                    style: TextStyle(
                      color: ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _recordStat(
                          icon: Icons.description_rounded,
                          value: '${records.length}',
                          label: 'Total records',
                          iconBg: const Color(0xFFDFF0E2),
                          iconColor: forest,
                          curveColor: const Color(0xFFDFF2E2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _recordStat(
                          icon: Icons.visibility_rounded,
                          value: '$followUps',
                          label: 'Follow-up needed',
                          iconBg: const Color(0xFFFFEFC7),
                          iconColor: const Color(0xFFAD7412),
                          curveColor: const Color(0xFFFFF1CE),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Record list heading
                  const Text(
                    'Recent records',
                    style: TextStyle(
                      color: ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (records.isEmpty)
                    _emptyRecords()
                  else
                    ...records.reversed.map((record) => _recordCard(record)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordStat({
    required IconData icon,
    required String value,
    required String label,
    required Color iconBg,
    required Color iconColor,
    required Color curveColor,
  }) {
    return Container(
      height: 104,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE7EAE1)),
        boxShadow: [
          BoxShadow(
            color: ink.withValues(alpha: 0.035),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -5,
            bottom: -18,
            child: Container(
              width: 75,
              height: 55,
              decoration: BoxDecoration(
                color: curveColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(55),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyRecords() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EAE1)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F2E4),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: forest.withValues(alpha: 0.07),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.history_rounded, color: forest, size: 36),
          ),
          const SizedBox(height: 17),
          const Text(
            'No records yet',
            style: TextStyle(
              color: ink,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Your completed cow assessments will appear here '
            'with their dates and screening results.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _recordCard(HealthRecord record) {
    final needsFollowUp = record.result.toLowerCase().contains('follow-up');

    final dateText =
        '${record.date.day.toString().padLeft(2, '0')}/'
        '${record.date.month.toString().padLeft(2, '0')}/'
        '${record.date.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EAE1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: needsFollowUp
                  ? const Color(0xFFFFF0CE)
                  : const Color(0xFFDFF0E2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: needsFollowUp ? const Color(0xFFAD7412) : forest,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.cowName,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${record.cowId}  •  $dateText',
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: needsFollowUp
                        ? const Color(0xFFFFF0CE)
                        : const Color(0xFFE2F4DF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    record.result,
                    style: TextStyle(
                      color: needsFollowUp ? const Color(0xFF98620B) : forest,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (record.notes.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    record.notes,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: forest, size: 23),
        ],
      ),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class MyCowsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAddCow;

  const MyCowsHeader({super.key, required this.onBack, required this.onAddCow});

  static const Color green = Color(0xFF087448);
  static const Color paleGreen = Color(0xFFE5F2E4);
  static const Color darkText = Color(0xFF172E27);
  static const Color subtitleColor = Color(0xFF758078);
  static const Color cream = Color(0xFFF8F7F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: cream,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          // Back button
          SizedBox(
            width: 44,
            height: 46,
            child: Material(
              color: paleGreen,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(14),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: green,
                  size: 23,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Title and subtitle
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Cows',
                  maxLines: 1,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Manage your herd',
                  maxLines: 1,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Add Cow button
          SizedBox(
            height: 46,
            child: FilledButton(
              onPressed: onAddCow,
              style: FilledButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 21),
                  SizedBox(width: 5),
                  Text(
                    'Add Cow',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HerdStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconBackground;
  final Color iconColor;
  final Color curveColor;

  const HerdStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconBackground,
    required this.iconColor,
    required this.curveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 86,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFECEDE5), width: 0.8),
        ),
        child: Stack(
          children: [
            // Soft curved decoration
            Positioned(
              right: -4,
              bottom: -17,
              child: Container(
                width: 70,
                height: 52,
                decoration: BoxDecoration(
                  color: curveColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(55),
                  ),
                ),
              ),
            ),

            // Card information
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 5, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 31,
                    height: 31,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF172E25),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      height: 1.1,
                      color: Color(0xFF778078),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssessHeader extends StatelessWidget {
  final VoidCallback onBack;

  const AssessHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pale-green back button
          Material(
            color: const Color(0xFFEAF5E9),
            borderRadius: BorderRadius.circular(17),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(17),
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF176B45),
                  size: 24,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title and subtitle
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Assess',
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    color: Color(0xFF172E27),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Check your cow’s udder health',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF758078),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssessmentBanner extends StatelessWidget {
  const AssessmentBanner({super.key, required this.onAssessNow});

  final VoidCallback onAssessNow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 122,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F7EC),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE5EDE0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF176B45).withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Use the image across the entire banner.
            Image.asset(
              'asset/images/cow_assessment_banner.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(color: Color(0xFFEAF5E5));
              },
            ),

            // Text and button remain functional.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 190,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start a new\nassessment',
                        style: TextStyle(
                          color: Color(0xFF172E27),
                          fontSize: 15,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Check for early signs of mastitis\n'
                        'in just a few simple steps.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF758078),
                          fontSize: 9,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      SizedBox(
                        height: 26,
                        child: FilledButton(
                          onPressed: onAssessNow,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF087448),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: Size.zero,
                            shape: const StadiumBorder(),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Assess now',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(Icons.arrow_forward_rounded, size: 14),
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
    );
  }
}

class AddCowHeader extends StatelessWidget {
  final VoidCallback onBack;

  const AddCowHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF176B50);
    const ink = Color(0xFF20352A);
    const muted = Color(0xFF77857A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      color: const Color(0xFFF6F5EC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                color: forest,
                tooltip: 'Back to My Cows',
              ),
              const SizedBox(width: 8),
              const Text(
                'My Cows',
                style: TextStyle(color: forest, fontSize: 14),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.chevron_right, size: 18, color: muted),
              ),
              const Text(
                'Add Cow',
                style: TextStyle(
                  color: ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Register a cow',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add your cow's details to keep health records organized.",
            style: TextStyle(fontSize: 15, color: muted),
          ),
        ],
      ),
    );
  }
}
