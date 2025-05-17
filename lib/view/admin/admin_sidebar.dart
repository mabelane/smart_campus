import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'booking_managementt.dart';
import 'course_management.dart';
import 'user_management.dart'; // Import AdminDashboard

class AdminManagementSidebar extends StatefulWidget {
  const AdminManagementSidebar({super.key});

  @override
  State<AdminManagementSidebar> createState() => _AdminManagementSidebarState();
}

class _AdminManagementSidebarState extends State<AdminManagementSidebar> {
  int selectedIndex = 0;

  final List<Widget> _views = [
    AdminDashboard(),
    UsersManagementScreen(),
    CourseManagementScreen(),
    BookingsManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu_book),
                label: Text('Courses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today),
                label: Text('Bookings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                //AppBar(title: Text(_titles[selectedIndex])),
                Expanded(child: _views[selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
