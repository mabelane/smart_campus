import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user.dart';
import '../../utils/controllers/admin_controller.dart';
import '../../utils/controllers/user_controller.dart';

class UsersManagementScreen extends StatelessWidget {
  final int? initialTab;
  UserController userController = Get.put(UserController());
  AdminController adminController = Get.find<AdminController>();

  UsersManagementScreen({super.key, this.initialTab}) {
    adminController.setActiveScreen('users');
    userController.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Management'),
          backgroundColor: const Color(0xFF2A2D3E),
          elevation: 0,
          bottom: const TabBar(
            tabs: [Tab(text: 'Users List'), Tab(text: 'Add User')],
            indicatorColor: Colors.blue,
          ),
        ),
        body: Container(
          color: const Color(0xFF212332),
          child: TabBarView(children: [_buildUsersList(), _buildAddUserForm()]),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return Obx(() {
      if (userController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (userController.users.isEmpty) {
        return const Center(
          child: Text(
            'No users found',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2D3E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => userController.filterUsers(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userController.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = userController.filteredUsers[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildUserCard(User user) {
    Color roleColor;
    switch (user.role.toLowerCase()) {
      case 'admin':
        roleColor = Colors.red;
        break;
      case 'lecturer':
        roleColor = Colors.blue;
        break;
      default:
        roleColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF2A2D3E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(user.email, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: roleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user.role,
                    style: TextStyle(color: roleColor, fontSize: 12),
                  ),
                ),
                if (user.department != null && user.department!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      user.department!,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: const Color(0xFF2A2D3E),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditUserDialog(user);
                break;
              case 'delete':
                _showDeleteConfirmation(user);
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }

  Widget _buildAddUserForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New User',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Full Name',
            hint: 'Enter user full name',
            icon: Icons.person,
            onChanged: (value) => userController.newUser.name = value,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: 'Email',
            hint: 'Enter user email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => userController.newUser.email = value,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: 'Password',
            hint: 'Enter user password',
            icon: Icons.lock,
            isPassword: true,
            onChanged: (value) => userController.password.value = value,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: 'Student Number (if applicable)',
            hint: 'Enter student number',
            icon: Icons.numbers,
            onChanged: (value) => userController.newUser.studentNumber = value,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: 'Phone Number',
            hint: 'Enter phone number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            onChanged: (value) => userController.newUser.phone = value,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: 'Department',
            hint: 'Enter department',
            icon: Icons.business,
            onChanged: (value) => userController.newUser.department = value,
          ),
          const SizedBox(height: 15),
          _buildDropdown(
            label: 'Role',
            value: userController.role.value,
            items: const ['Student', 'Lecturer', 'Admin'],
            onChanged: (value) {
              if (value != null) {
                userController.role.value = value;
              }
            },
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed:
                    userController.isLoading.value
                        ? null
                        : () => userController.createUser(),
                child:
                    userController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Add User',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: Icon(icon, color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF2A2D3E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
          obscureText: isPassword,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF2A2D3E),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              items:
                  items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditUserDialog(User user) {
    userController.setupForEdit(user);

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF212332),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: Get.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Full Name',
                  hint: 'Enter user full name',
                  icon: Icons.person,
                  onChanged: (value) => userController.editingUser.name = value,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  label: 'Department',
                  hint: 'Enter department',
                  icon: Icons.business,
                  onChanged:
                      (value) => userController.editingUser.department = value,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onChanged:
                      (value) => userController.editingUser.phone = value,
                ),
                const SizedBox(height: 15),
                _buildDropdown(
                  label: 'Role',
                  value: userController.editingRole.value,
                  items: const ['Student', 'Lecturer', 'Admin'],
                  onChanged: (value) {
                    if (value != null) {
                      userController.editingRole.value = value;
                    }
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        userController.updateUser(user.id);
                        Get.back();
                      },
                      child: const Text('Update User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(User user) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF212332),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 60,
              ),
              const SizedBox(height: 15),
              const Text(
                'Delete User',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Are you sure you want to delete ${user.name}? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      userController.deleteUser(user.id);
                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
