import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CampusLoopApp());
}

// ============================================================
// APP
// ============================================================

class CampusLoopApp extends StatelessWidget {
  const CampusLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusLoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B1B47),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F8),
      ),
      home: const CampusLoopHome(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

const Color primaryMaroon = Color(0xFF9B1B47);
const Color darkMaroon = Color(0xFF741334);
const Color lightPink = Color(0xFFF9E8EF);
const Color backgroundColor = Color(0xFFF7F8F8);
const Color textDark = Color(0xFF26343B);
const Color textGrey = Color(0xFF7C898E);

// ============================================================
// REMINDER MODEL
// ============================================================

class Reminder {
  final String title;
  final String date;

  Reminder({
    required this.title,
    required this.date,
  });
}

// ============================================================
// EVENT MODEL
// ============================================================

class CampusEvent {
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final IconData icon;

  CampusEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.icon,
  });
}

// ============================================================
// MAIN HOME
// ============================================================

class CampusLoopHome extends StatefulWidget {
  const CampusLoopHome({super.key});

  @override
  State<CampusLoopHome> createState() => _CampusLoopHomeState();
}

class _CampusLoopHomeState extends State<CampusLoopHome> {
  int selectedIndex = 0;

  final List<Reminder> reminders = [];
  final List<CampusEvent> registeredEvents = [];

  final List<CampusEvent> events = [
    CampusEvent(
      title: 'Innovation Sprint',
      date: '10 October 2026',
      time: '10:00 AM - 1:00 PM',
      location: 'Innovation Lab',
      description:
      'Join students and innovators for a creative campus innovation challenge.',
      icon: Icons.lightbulb_outline,
    ),
    CampusEvent(
      title: 'Food Festival',
      date: '14 October 2026',
      time: '12:00 PM - 4:00 PM',
      location: 'Student Plaza',
      description:
      'Explore different cuisines and enjoy a fun campus food experience with students.',
      icon: Icons.restaurant,
    ),
    CampusEvent(
      title: 'Career Connect 2026',
      date: '20 October 2026',
      time: '9:30 AM - 3:00 PM',
      location: 'Main Auditorium',
      description:
      'Connect with recruiters, explore career opportunities and learn about internships.',
      icon: Icons.groups,
    ),
    CampusEvent(
      title: 'Programming Workshop',
      date: '24 October 2026',
      time: '10:00 AM - 12:00 PM',
      location: 'Computer Lab',
      description:
      'Hands-on programming workshop designed to improve practical development skills.',
      icon: Icons.code,
    ),
  ];

  final List<CampusService> services = [
    CampusService(
      title: 'Digital Library',
      subtitle: 'Books, journals & study spaces',
      image: 'assets/images/digital library.jpg',
    ),
    CampusService(
      title: 'Career Centre',
      subtitle: 'Jobs, internships & placements',
      image: 'assets/images/career center.jpg',
    ),
    CampusService(
      title: 'Campus Clinic',
      subtitle: 'Health support & assistance',
      image: 'assets/images/campus clinic.jpg',
    ),
    CampusService(
      title: 'IT Help Desk',
      subtitle: 'Technical support for students',
      image: 'assets/images/help-desk.png',
    ),
  ];

  void navigateTo(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // ==========================================================
  // ADD REMINDER - VALIDATED FORM
  // ==========================================================

  void showAddReminderDialog() {
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: primaryMaroon,
              ),
              SizedBox(width: 10),
              Text(
                'Add Reminder',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 430,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -----------------------------
                  // REMINDER TITLE
                  // -----------------------------

                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Reminder Title',
                      hintText: 'Enter reminder title',
                      prefixIcon: const Icon(
                        Icons.edit,
                        color: primaryMaroon,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: primaryMaroon,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a reminder title';
                      }

                      if (value.trim().length < 3) {
                        return 'Title must contain at least 3 characters';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // -----------------------------
                  // DATE
                  // -----------------------------

                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select reminder date',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: primaryMaroon,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: primaryMaroon,
                          width: 2,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: dialogContext,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );

                      if (selectedDate != null) {
                        dateController.text =
                        '${selectedDate.day.toString().padLeft(2, '0')}/'
                            '${selectedDate.month.toString().padLeft(2, '0')}/'
                            '${selectedDate.year}';
                      }
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a date';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textGrey,
                ),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newReminder = Reminder(
                    title: titleController.text.trim(),
                    date: dateController.text.trim(),
                  );

                  setState(() {
                    reminders.add(newReminder);
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Reminder successfully created!',
                          ),
                        ],
                      ),
                      backgroundColor: primaryMaroon,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Create Reminder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // EVENT REGISTRATION
  // ==========================================================

  void registerForEvent(CampusEvent event) {
    final alreadyRegistered =
    registeredEvents.any((registered) => registered.title == event.title);

    if (alreadyRegistered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are already registered for ${event.title}.'),
          backgroundColor: Colors.orange.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      registeredEvents.add(event);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.title} registered successfully!'),
        backgroundColor: primaryMaroon,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // DRAWER
  // ==========================================================

  void showCampusDrawer() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Campus Menu',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (
          context,
          animation,
          secondaryAnimation,
          ) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            child: SizedBox(
              width: 335,
              height: double.infinity,
              child: _buildDrawer(),
            ),
          ),
        );
      },
      transitionBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              22,
              45,
              22,
              28,
            ),
            decoration: const BoxDecoration(
              color: primaryMaroon,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'assets/images/klu_logo.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CampusLoop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'KL University Student Portal',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          _drawerItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              navigateTo(0);
            },
          ),

          _drawerItem(
            icon: Icons.calendar_month_outlined,
            title: 'Activities',
            onTap: () {
              Navigator.pop(context);
              navigateTo(1);
            },
          ),

          _drawerItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              navigateTo(2);
            },
          ),

          const Divider(),

          _drawerItem(
            icon: Icons.event_available,
            title: 'My Registered Events',
            onTap: () {
              Navigator.pop(context);
              showRegisteredEventsPage();
            },
          ),

          _drawerItem(
            icon: Icons.notifications_none,
            title: 'Reminders',
            onTap: () {
              Navigator.pop(context);
              showRemindersPage();
            },
          ),

          _drawerItem(
            icon: Icons.info_outline,
            title: 'About CampusLoop',
            onTap: () {
              Navigator.pop(context);
              showAboutDialog();
            },
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textDark,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          color: textDark,
        ),
      ),
      onTap: onTap,
    );
  }

  // ==========================================================
  // REMINDERS PAGE
  // ==========================================================

  void showRemindersPage() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 650,
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: primaryMaroon,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'My Reminders',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (reminders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'No reminders yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Create a reminder using the button below.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: reminders.length,
                          itemBuilder: (context, index) {
                            final reminder = reminders[index];

                            return Card(
                              elevation: 0,
                              color: lightPink,
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: primaryMaroon,
                                  child: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  reminder.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  reminder.date,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: primaryMaroon,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      reminders.removeAt(index);
                                    });

                                    setDialogState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          showAddReminderDialog();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add Reminder',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryMaroon,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // OPEN WEBSITE LINKS
  // ==========================================================

  Future<void> openWebsite(String url) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the website.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the website.')),
      );
    }
  }

  // ==========================================================
  // MY REGISTERED EVENTS
  // ==========================================================

  void showRegisteredEventsPage() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('My Registered Events'),
              content: SizedBox(
                width: 500,
                child: registeredEvents.isEmpty
                    ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 55,
                      color: textGrey,
                    ),
                    SizedBox(height: 12),
                    Text('No registered events yet.'),
                    SizedBox(height: 5),
                    Text(
                      'Register for an event in Activities.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                    : SizedBox(
                  height: 350,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: registeredEvents.length,
                    itemBuilder: (context, index) {
                      final event = registeredEvents[index];
                      return Card(
                        color: lightPink,
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.event_available,
                            color: primaryMaroon,
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${event.date}\n${event.time}\n${event.location}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Cancel registration',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: primaryMaroon,
                            ),
                            onPressed: () {
                              setState(() {
                                registeredEvents.removeAt(index);
                              });
                              setDialogState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: primaryMaroon),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // ABOUT
  // ==========================================================

  void showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'About CampusLoop',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryMaroon,
            ),
          ),
          content: const Text(
            'CampusLoop is a student portal designed to provide quick access to campus information, activities, events, services and reminders.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: primaryMaroon,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          _buildHomePage(),
          _buildActivitiesPage(),
          _buildProfilePage(),
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: showAddReminderDialog,
        backgroundColor: primaryMaroon,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.notifications_active,
        ),
        label: const Text(
          'Add Reminder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==========================================================
  // APP BAR
  // ==========================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryMaroon,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          size: 28,
        ),
        onPressed: showCampusDrawer,
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/images/klu_logo.jpg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'CampusLoop',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            size: 28,
          ),
          onPressed: showRemindersPage,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      backgroundColor: Colors.white,
      indicatorColor: lightPink,
      onDestinationSelected: navigateTo,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
            color: primaryMaroon,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(
            Icons.calendar_month,
            color: primaryMaroon,
          ),
          label: 'Activities',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(
            Icons.person,
            color: primaryMaroon,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  // ==========================================================
  // HOME PAGE
  // ==========================================================

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          _buildHeroSection(),

          const SizedBox(height: 30),

          _sectionTitle(
            title: 'Today at KL University',
            subtitle: 'Your campus snapshot',
          ),

          const SizedBox(height: 18),

          _buildStats(),

          const SizedBox(height: 35),

          _sectionTitle(
            title: 'Quick Campus Services',
            subtitle: 'Everything you need in one place',
          ),

          const SizedBox(height: 18),

          _buildServices(),

          const SizedBox(height: 35),

          _buildAnnouncement(),

          const SizedBox(height: 35),

          _sectionTitle(
            title: 'Upcoming Events',
            subtitle: 'Discover what is happening on campus',
            showViewAll: true,
          ),

          const SizedBox(height: 18),

          _buildUpcomingEvents(),

          const SizedBox(height: 30),

          _buildUniversityCard(),
        ],
      ),
    );
  }

  // ==========================================================
  // HERO
  // ==========================================================

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/klu_campus.jpg',
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      primaryMaroon.withOpacity(0.90),
                      primaryMaroon.withOpacity(0.48),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 32,
              top: 45,
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/klu_logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Positioned(
              left: 32,
              top: 165,
              child: Text(
                'Good morning,',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            const Positioned(
              left: 32,
              top: 195,
              child: Text(
                'Akshitha!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Positioned(
              left: 32,
              top: 245,
              child: Text(
                'B.Tech Computer Science • Semester 6',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),

            Positioned(
              right: 30,
              top: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'Knowledge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Leadership',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'University',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle({
    required String title,
    required String subtitle,
    bool showViewAll = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 55,
            decoration: BoxDecoration(
              color: primaryMaroon,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),
          if (showViewAll)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'View All →',
                style: TextStyle(
                  color: primaryMaroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // STAT CARDS
  // ==========================================================

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.menu_book,
                  number: '3',
                  title: 'Classes',
                  subtitle: 'Today',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _statCard(
                  icon: Icons.event,
                  number: '4',
                  title: 'Events',
                  subtitle: 'Registered',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _statCard(
                  icon: Icons.notifications_active,
                  number: reminders.length.toString(),
                  title: 'Tasks',
                  subtitle: 'Reminders',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String number,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: title == 'Tasks' ? showRemindersPage : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: primaryMaroon,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              number,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SERVICES
  // ==========================================================

  Widget _buildServices() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          int columns = 4;

          if (width < 900) {
            columns = 2;
          }

          if (width < 550) {
            columns = 1;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3.1,
            ),
            itemBuilder: (context, index) {
              return _serviceCard(services[index]);
            },
          );
        },
      ),
    );
  }

  Widget _serviceCard(CampusService service) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${service.title} selected',
            ),
            backgroundColor: primaryMaroon,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                service.image,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    service.subtitle,
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: textGrey,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ANNOUNCEMENT
  // ==========================================================

  Widget _buildAnnouncement() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: primaryMaroon,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: primaryMaroon.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UNIVERSITY ANNOUNCEMENT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Stay updated with upcoming academic and campus activities.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // UPCOMING EVENTS
  // ==========================================================

  Widget _buildUpcomingEvents() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        itemCount: events.length > 3 ? 3 : events.length,
        itemBuilder: (context, index) {
          return _eventPreviewCard(events[index]);
        },
      ),
    );
  }

  Widget _eventPreviewCard(CampusEvent event) {
    return Container(
      width: 330,
      margin: const EdgeInsets.only(
        right: 18,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: lightPink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              event.icon,
              color: primaryMaroon,
              size: 48,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            event.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),

          const SizedBox(height: 10),

          _eventInfoRow(
            Icons.calendar_today,
            event.date,
          ),

          const SizedBox(height: 5),

          _eventInfoRow(
            Icons.access_time,
            event.time,
          ),

          const SizedBox(height: 5),

          _eventInfoRow(
            Icons.location_on,
            event.location,
          ),
        ],
      ),
    );
  }

  Widget _eventInfoRow(
      IconData icon,
      String text,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: primaryMaroon,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // UNIVERSITY CARD
  // ==========================================================

  Widget _buildUniversityCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: const BoxDecoration(
                    color: lightPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    color: primaryMaroon,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KL University Campus',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Knowledge • Leadership • University',
                        style: TextStyle(
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: textGrey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                openWebsite('https://www.kluniversity.in/');
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Visit University Website'),
              style: TextButton.styleFrom(
                foregroundColor: primaryMaroon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ACTIVITIES PAGE
  // ==========================================================

  Widget _buildActivitiesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        22,
        30,
        22,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            title: 'Campus Activities',
            subtitle: 'Discover and register for campus events',
          ),

          const SizedBox(height: 25),

          ...events.map(
                (event) => _activityCard(event),
          ),
        ],
      ),
    );
  }

  Widget _activityCard(CampusEvent event) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: lightPink,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              event.icon,
              color: primaryMaroon,
              size: 40,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 15,
                  runSpacing: 7,
                  children: [
                    _smallInfo(
                      Icons.calendar_today,
                      event.date,
                    ),
                    _smallInfo(
                      Icons.access_time,
                      event.time,
                    ),
                    _smallInfo(
                      Icons.location_on,
                      event.location,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  event.description,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: () {
                    registerForEvent(event);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryMaroon,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget _smallInfo(
      IconData icon,
      String text,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: primaryMaroon,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: textGrey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PROFILE PAGE
  // ==========================================================

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        22,
        25,
        22,
        100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile picture
              Container(
                width: 125,
                height: 125,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightPink,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryMaroon.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Image.asset(
                  'assets/images/klu_logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Akshitha',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Computer Science & Engineering',
                style: TextStyle(
                  fontSize: 17,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(
                color: Color(0xFFE8CDD7),
              ),

              const SizedBox(height: 15),

              _profileItem(
                icon: Icons.school,
                title: 'University',
                value: 'KL University',
              ),

              _profileItem(
                icon: Icons.computer,
                title: 'Programme',
                value: 'B.Tech Computer Science',
              ),

              _profileItem(
                icon: Icons.layers,
                title: 'Semester',
                value: 'Semester 6',
              ),

              _profileItem(
                icon: Icons.badge,
                title: 'Student ID',
                value: 'KL-CSE-2026',
              ),

              _profileItem(
                icon: Icons.email,
                title: 'Email',
                value: 'akshitha@student.klu.ac.in',
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profile editing is available in the student portal.',
                        ),
                        backgroundColor: primaryMaroon,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Update Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryMaroon,
                    side: const BorderSide(
                      color: primaryMaroon,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: lightPink,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primaryMaroon,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

// ============================================================
// CAMPUS SERVICE MODEL
// ============================================================

class CampusService {
  final String title;
  final String subtitle;
  final String image;

  CampusService({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
