import 'package:get/get.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../storage/token_storage.dart';

class UserController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  // Observables
  var isLoading = false.obs;
  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var role = 'Student'.obs;
  var password = ''.obs;
  var editingRole = 'Student'.obs;

  // New user and editing user
  late User newUser;
  late User editingUser;

  @override
  void onInit() {
    super.onInit();
    _resetNewUser();
    fetchUsers();
  }

  void _resetNewUser() {
    newUser = User(
      id: '',
      name: '',
      email: '',
      role: role.value,
      studentNumber: '',
      department: '',
      phone: '',
      profilePicture: '',
    );
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.httpClient.get(
        '/getAllUsers',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> data = response.body;
        users.assignAll(data.map((user) => User.fromJson(user)).toList());
        filteredUsers.assignAll(users);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()) ||
              (user.department != null &&
                  user.department!.toLowerCase().contains(
                    query.toLowerCase(),
                  )) ||
              user.role.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> createUser() async {
    if (newUser.name.isEmpty ||
        newUser.email.isEmpty ||
        password.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final btoken = await TokenStorage.getToken();
      final response = await apiService.registerUser({
        "name": newUser.name,
        "email": newUser.email,
        "password": password.value,
        "studentNumber": newUser.studentNumber,
        "phone": newUser.phone,
        "department": newUser.department,
        "role": role.value,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'User created successfully');
        _resetNewUser();
        password.value = '';
        role.value = 'Student';
        fetchUsers();
      } else {
        Get.snackbar(
          'Error',
          response.body?['message'] ?? 'Failed to create user',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setupForEdit(User user) {
    editingUser = User(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      studentNumber: user.studentNumber,
      department: user.department,
      phone: user.phone,
      profilePicture: user.profilePicture,
    );
    editingRole.value = user.role;
  }

  Future<void> updateUser(String userId) async {
    isLoading.value = true;
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.updateUser(userId, {
        "name": editingUser.name,
        "department": editingUser.department,
        "phone": editingUser.phone,
        "role": editingRole.value,
      });

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User updated successfully');
        fetchUsers();
      } else {
        Get.snackbar(
          'Error',
          response.body?['message'] ?? 'Failed to update user',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    isLoading.value = true;
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.deleteUser(userId);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User deleted successfully');
        fetchUsers();
      } else {
        Get.snackbar(
          'Error',
          response.body?['message'] ?? 'Failed to delete user',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
