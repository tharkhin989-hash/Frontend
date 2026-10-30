import 'package:exe/model/get_user_data.dart';
import 'package:exe/screen/user_form.dart';
import 'package:exe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserApi extends StatefulWidget {
  const UserApi({super.key});

  @override
  State<UserApi> createState() => _UserApiState();
}

class _UserApiState extends State<UserApi> {
  late final List<PlutoColumn> columns;
  List<PlutoRow> rows = [];

  bool isLoading = true;
  String? errorMessage;
  final Set<int> _deletedUserIds = {};
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: 'ID',
        field: 'user_id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Email',
        field: 'email',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Role',
        field: 'role',
        type: PlutoColumnType.text(),

      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: 100,
        enableEditingMode: false,
        enableSorting: false,
        enableFilterMenuItem: false,
        renderer: (rendererContext){
          final row = rendererContext.row;

          final userId = int.parse(row.cells['user_id']!.value.toString());

          final userName = row.cells['name']!.value.toString();

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Edit User',
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blue,
                ),
                onPressed: (){
                  editUser(userId);
                },
              ),
            
            
              IconButton(
                tooltip: 'Delete User',
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: (){
                  confirmDeleteUser(userId, userName);
                },
              ),
            ],
          );
        },
      ),
    ];

    loadUsers();
  
  }
  Future<void> editUser(int userId) async {
    try{
      final users= await _apiService.fetchUsers();
      final matchingUsers = users.where(
        (user) => user.userId == userId,
      );
      if (matchingUsers.isEmpty){
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final selectedUser = matchingUsers.first;
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserForm(
            user: selectedUser,
          ),
          ),
      );
      if (!mounted) return;
      await loadUsers();

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open user: $e'),
          backgroundColor: Colors.red,
          ),
      );
    }
  }

  Future<void> loadUsers() async {
    try {
      final List<User> users =
          await ApiService().fetchUsers();

      final loadedRows = users.map((user) {
        return PlutoRow(
          cells: {
            'user_id': PlutoCell(value: user.userId),
            'name': PlutoCell(value: user.name),
            'email': PlutoCell(value: user.email),
            'role': PlutoCell(value: user.role),
            'actions': PlutoCell(value:''),
          },
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        rows = loadedRows;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }
  Future<void> confirmDeleteUser(int userId, String userName) async {
    final confirmed= await showDialog<bool>(
      context: context,
      builder: (dialogContext){
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete "$userName"?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: (){
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              ),
          ],
        );
      } );
  

  if (confirmed == true){
    await deleteUser(userId);
    }
  }
  Future<void> deleteUser(int userId) async {
    if (_deletedUserIds.contains(userId)) return;

    setState(() {
      _deletedUserIds .add(userId);
    
    });
    try {
      await _apiService.deleteUser(userId);
      if (!mounted) return;
      setState((){
        rows.removeWhere(
          (row) => int.parse(row.cells['user_id']!.value.toString()) == userId,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context). showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally{
      if (mounted){
        setState(() {
          _deletedUserIds .remove(userId);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errorMessage!),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: loadUsers,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SizedBox.expand(
                    child: PlutoGrid(
                      columns: columns,
                      rows: rows,
                      configuration:
                          const PlutoGridConfiguration(),
                    ),
                  ),
      ),
    );
  }
}