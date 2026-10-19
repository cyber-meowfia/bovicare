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
  const Cow({
    required this.name,
    required this.id,
    required this.status,
    this.breed = 'Gir',
    this.healthScore = 95,
  });

  final String name;
  final String id;
  final String status;
  final String breed;
  final int healthScore;
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
  String topNavMode = 'Home'; // 'Login', 'Home', 'Profile'
  bool marathi = false;

  final List<Cow> cows = [
    const Cow(
      name: 'Ganga',
      id: 'COW-001',
      status: 'Healthy',
      breed: 'Holstein',
      healthScore: 95,
    ),
    const Cow(
      name: 'Nandini',
      id: 'COW-002',
      status: 'Attention',
      breed: 'Jersey',
      healthScore: 64,
    ),
    const Cow(
      name: 'Lakshmi',
      id: 'COW-003',
      status: 'Healthy',
      breed: 'Sahiwal',
      healthScore: 92,
    ),
  ];

  final List<HealthRecord> records = [
    HealthRecord(
      cowName: 'Lakshmi',
      cowId: 'COW-003',
      date: DateTime.now().subtract(const Duration(days: 1)),
      result: 'Healthy',
      notes: 'Routine herd assessment. Clear milk, healthy udder.',
    ),
    HealthRecord(
      cowName: 'Nandini',
      cowId: 'COW-002',
      date: DateTime.now().subtract(const Duration(days: 2)),
      result: 'Needs follow-up',
      notes: 'Slight redness observed on rear quarter.',
    ),
  ];

  String _translate(String english, String marathiText) {
    return marathi ? marathiText : english;
  }

  void _selectTab(int index) {
    setState(() {
      selectedTab = index;
      topNavMode = 'Home';
    });
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
        BoviCareProfilePage(
          onBack: () => _selectTab(0),
          onLogout: () {
            setState(() => topNavMode = 'Login');
          },
        ),
      ];

  Widget _buildTopPills() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _topPill('Login', () {
          setState(() => topNavMode = 'Login');
        }),
        const SizedBox(width: 8),
        _topPill('Home', () {
          setState(() {
            topNavMode = 'Home';
            selectedTab = 0;
          });
        }),
        const SizedBox(width: 8),
        _topPill('Profile', () {
          setState(() {
            topNavMode = 'Home';
            selectedTab = 4;
          });
        }),
      ],
    );
  }

  Widget _topPill(String title, VoidCallback onTap) {
    final isSelected = (title == 'Home' && topNavMode == 'Home' && selectedTab != 4) ||
        (title == 'Profile' && (topNavMode == 'Profile' || (topNavMode == 'Home' && selectedTab == 4))) ||
        (title == 'Login' && topNavMode == 'Login');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF232724) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF5A635B) : const Color(0xFF323633),
            width: 1.2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9EAAA0),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE9ECE5), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navDestination(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
          _navDestination(1, Icons.pets_rounded, Icons.pets_outlined, 'My Cows'),
          _navDestination(
            2,
            Icons.health_and_safety_rounded,
            Icons.health_and_safety_outlined,
            'Assess',
          ),
          _navDestination(
            3,
            Icons.assignment_rounded,
            Icons.assignment_outlined,
            'Records',
          ),
          _navDestination(
            4,
            Icons.person_rounded,
            Icons.person_outline_rounded,
            'Profile',
          ),
        ],
      ),
    );
  }

  Widget _navDestination(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = (topNavMode == 'Home' && selectedTab == index);

    return InkWell(
      onTap: () => _selectTab(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFCFE4B9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  activeIcon,
                  color: const Color(0xFF385F14),
                  size: 20,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Icon(
                  inactiveIcon,
                  color: const Color(0xFF5A665D),
                  size: 20,
                ),
              ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF385F14) : const Color(0xFF5A665D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWide = screenSize.width > 480;

    Widget currentScreenContent;
    if (topNavMode == 'Login') {
      currentScreenContent = BoviCareLoginPage(
        onLoginSuccess: () {
          setState(() {
            topNavMode = 'Home';
            selectedTab = 0;
          });
        },
      );
    } else {
      currentScreenContent = Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedTab,
              children: pages,
            ),
          ),
          _buildPhoneBottomNav(),
        ],
      );
    }

    if (!isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8F4),
        body: SafeArea(
          bottom: false,
          child: currentScreenContent,
        ),
      );
    }

    final phoneHeight = (screenSize.height - 90).clamp(740.0, 850.0);

    return Scaffold(
      backgroundColor: const Color(0xFF131514),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopPills(),
                const SizedBox(height: 16),
                Container(
                  width: 390,
                  height: phoneHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F4),
                    borderRadius: BorderRadius.circular(44),
                    border: Border.all(
                      color: const Color(0xFF2B2E2B),
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 36,
                        spreadRadius: 2,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: currentScreenContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
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

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedAction = 'All';

  Widget _quickActionItem(String title, IconData icon) {
    final isSelected = selectedAction == title;

    return InkWell(
      onTap: () {
        setState(() => selectedAction = title);
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 58,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF487222) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF487222) : const Color(0xFFE5EAE1),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF487222).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : const Color(0xFF436B1E),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF223528),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8F4),
      child: Column(
        children: [
          // Header Area
          Container(
            width: double.infinity,
            color: const Color(0xFF679C28),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Row(
              children: [
                // Avatar RP
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBF5D5),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'RP',
                      style: TextStyle(
                        color: Color(0xFF3E6319),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title and location
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFFE4F0CD),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Your farm',
                            style: TextStyle(
                              color: Color(0xFFE4F0CD),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Patil Dairy, Nashik',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Trailing notification bell
                IconButton(
                  onPressed: () {
                    showMessage(context, 'No new notifications for Patil Dairy.');
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                // TODAY Hero Banner Card
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF679C28),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TODAY',
                              style: TextStyle(
                                color: Color(0xFFE2F0CB),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Quick herd\nhealth check',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton(
                              onPressed: widget.onAssess,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF395C16),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                minimumSize: Size.zero,
                                shape: const StadiumBorder(),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Assess now',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Outlined translucent frame graphic
                      Container(
                        width: 72,
                        height: 82,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.38),
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.document_scanner_outlined,
                          size: 38,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick actions section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick actions',
                        style: TextStyle(
                          color: Color(0xFF1E2E24),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 72,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _quickActionItem('All', Icons.grid_view_rounded),
                            const SizedBox(width: 10),
                            _quickActionItem(
                              'Fever',
                              Icons.device_thermostat_outlined,
                            ),
                            const SizedBox(width: 10),
                            _quickActionItem('Feed', Icons.grass_outlined),
                            const SizedBox(width: 10),
                            _quickActionItem('Milk', Icons.water_drop_outlined),
                            const SizedBox(width: 10),
                            _quickActionItem('Vaccine', Icons.vaccines_outlined),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Check again section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Check again',
                            style: TextStyle(
                              color: Color(0xFF1E2E24),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: widget.onRecords,
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: Color(0xFF5E8E25),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE8ECE4)),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2EECF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.pets_rounded,
                                color: Color(0xFF5B8A23),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lakshmi',
                                    style: TextStyle(
                                      color: Color(0xFF1E2E24),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Yesterday · Healthy',
                                    style: TextStyle(
                                      color: Color(0xFF758579),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F2DC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF4B7720),
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Alerts for you section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Alerts for you',
                            style: TextStyle(
                              color: Color(0xFF1E2E24),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: widget.onRecords,
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: Color(0xFF5E8E25),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // Alert 1: NEEDS ATTENTION
                          Expanded(
                            child: Container(
                              height: 130,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF345618),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'NEEDS ATTENTION',
                                        style: TextStyle(
                                          color: Color(0xFFA6D76A),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '3 cows',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: widget.onCows,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF466E24),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text(
                                        'Review',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Alert 2: VACCINE DUE
                          Expanded(
                            child: Container(
                              height: 130,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF78A12B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'VACCINE DUE',
                                        style: TextStyle(
                                          color: Color(0xFFD6EEA5),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'FMD, 6',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showMessage(
                                        context,
                                        'FMD Vaccination scheduled for next Tuesday.',
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8CB438),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text(
                                        'Schedule',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Your cows section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your cows',
                            style: TextStyle(
                              color: Color(0xFF1E2E24),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: widget.onCows,
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: Color(0xFF5E8E25),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // Cow 1: Ganga
                          Expanded(
                            child: InkWell(
                              onTap: widget.onCows,
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 16, 14, 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFFE5EAE1),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 62,
                                      height: 62,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD8E7C8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Ganga',
                                      style: TextStyle(
                                        color: Color(0xFF1E2E24),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Holstein',
                                      style: TextStyle(
                                        color: Color(0xFF758579),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.verified_user_outlined,
                                              size: 14,
                                              color: Color(0xFF4C7820),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '95%',
                                              style: TextStyle(
                                                color: Color(0xFF4C7820),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 18,
                                          color: Color(0xFF9AA89D),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Cow 2: Nandini
                          Expanded(
                            child: InkWell(
                              onTap: widget.onCows,
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 16, 14, 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFFE5EAE1),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 62,
                                      height: 62,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF9E4D1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Nandini',
                                      style: TextStyle(
                                        color: Color(0xFF1E2E24),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Jersey',
                                      style: TextStyle(
                                        color: Color(0xFF758579),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              size: 14,
                                              color: Color(0xFFC7691C),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '64%',
                                              style: TextStyle(
                                                color: Color(0xFFC7691C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 18,
                                          color: Color(0xFF9AA89D),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class BoviCareLoginPage extends StatefulWidget {
  const BoviCareLoginPage({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  State<BoviCareLoginPage> createState() => _BoviCareLoginPageState();
}

class _BoviCareLoginPageState extends State<BoviCareLoginPage> {
  final TextEditingController _phoneController =
      TextEditingController(text: '+91 98765 43210');
  final TextEditingController _pinController =
      TextEditingController(text: '1234');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8F4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFF679C28),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'BoviCare',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E2E24),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Patil Dairy, Nashik',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5E8E25),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF5E8E25)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE5EAE1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE5EAE1)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _pinController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Security PIN',
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF5E8E25)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE5EAE1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE5EAE1)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.onLoginSuccess,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF679C28),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Sign In to Farm',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onLoginSuccess,
            child: const Text(
              'Continue as Guest Demo →',
              style: TextStyle(color: Color(0xFF5E8E25), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class BoviCareProfilePage extends StatelessWidget {
  const BoviCareProfilePage({
    super.key,
    required this.onBack,
    required this.onLogout,
  });

  final VoidCallback onBack;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8F4),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF679C28),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Farm Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBF5D5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'RP',
                        style: TextStyle(
                          color: Color(0xFF3E6319),
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Patil Dairy, Nashik',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E2E24),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Owner: Ramesh Patil · Nashik, Maharashtra',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF758579),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE8ECE4)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '14',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E2E24),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Total Cattle',
                            style: TextStyle(fontSize: 11, color: Color(0xFF758579)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '180 L',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4C7820),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Daily Milk',
                            style: TextStyle(fontSize: 11, color: Color(0xFF758579)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '3',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC7691C),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Need Review',
                            style: TextStyle(fontSize: 11, color: Color(0xFF758579)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE8ECE4)),
                  ),
                  leading: const Icon(Icons.language_rounded, color: Color(0xFF5E8E25)),
                  title: const Text('Language: English / मराठी'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showMessage(context, 'Language switcher available in settings.');
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE8ECE4)),
                  ),
                  leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFF5E8E25)),
                  title: const Text('SMS & WhatsApp Alerts'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showMessage(context, 'Alert preferences saved.');
                  },
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  label: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  static const _cream = Color(0xFFF8F7F0);
  static const _forest = Color(0xFF176B45);
  static const _ink = Color(0xFF20352A);
  static const _muted = Color(0xFF77857A);
  static const _paleGreen = Color(0xFFE5F2E4);
  static const _cardBg = Color(0xFFFFFEFA);
  static const _border = Color(0xFFE7EAE1);
  static const _amber = Color(0xFFAD7412);

  @override
  Widget build(BuildContext context) {
    final totalRecords = records.length;
    final followUps = records
        .where((r) => r.result.toLowerCase().contains('follow-up'))
        .length;

    return Container(
      color: _cream,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── A. Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Row(
                children: [
                  Material(
                    color: _paleGreen,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(14),
                      child: const SizedBox(
                        width: 44,
                        height: 46,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: _forest,
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
                            color: _ink,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Review your herd's health history",
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  // ── B. Assessment summary card ──
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _border),
                      boxShadow: [
                        BoxShadow(
                          color: _ink.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top row: icon + title/subtitle
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: _paleGreen,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.assignment_rounded,
                                  color: _forest,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Assessment summary',
                                      style: TextStyle(
                                        color: _ink,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Saved assessments and observations',
                                      style: TextStyle(
                                        color: _muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Thin divider
                        const Divider(
                          height: 1,
                          thickness: 0.8,
                          color: _border,
                        ),

                        // Stat tiles row
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: _summaryStatTile(
                                  value: '$totalRecords',
                                  label: 'Total records',
                                  valueColor: _forest,
                                  bgColor: const Color(0xFFE8F5E9),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _summaryStatTile(
                                  value: '$followUps',
                                  label: 'Need follow-up',
                                  valueColor: _amber,
                                  bgColor: const Color(0xFFFFF8E1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── C. Recent assessments heading ──
                  const Text(
                    'Recent assessments',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Recent assessments card
                  if (records.isEmpty)
                    _emptyState()
                  else
                    ...records.reversed.map(_recordCard),

                  const SizedBox(height: 18),

                  // ── D. Footer note ──
                  const Center(
                    child: Text(
                      'Illustrative layout · Counts will come from saved assessment records.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
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

  /// Pale stat tile used inside the summary card.
  Widget _summaryStatTile({
    required String value,
    required String label,
    required Color valueColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state shown when no records exist.
  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: _ink.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _paleGreen,
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: _forest.withValues(alpha: 0.07),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _forest,
              size: 34,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No records yet',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your saved cow assessments will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Individual record card for the list.
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
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
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
              color: needsFollowUp ? _amber : _forest,
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
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${record.cowId}  •  $dateText',
                  style: const TextStyle(color: _muted, fontSize: 11),
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
                      color:
                          needsFollowUp ? const Color(0xFF98620B) : _forest,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (record.notes.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    record.notes,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _forest, size: 23),
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
