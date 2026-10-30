import 'package:exe/model/creat_user_model.dart';
import 'package:exe/model/get_user_data.dart';
import 'package:exe/model/update_user_model.dart';
import 'package:exe/screen/user_api.dart';
import 'package:exe/service/api_service.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final User? user;
  const UserForm({
    super.key, this.user,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  String _role = 'Author';
  bool _obscurePassword = true;
  bool _isSaving = false;
  bool get _isEditing => widget.user != null;

String _normalizeRole(String? role){
  switch (role?.trim().toLowerCase()){
    case 'admin':
      return 'Admin';
    case 'editor':
      return 'Editor';
    case 'author':
      return 'Author';
    default:
     return 'Author';
  }
}
  @override
  void initState(){
    super.initState();

    final user = widget.user;
    if (user != null){
      _nameController.text = user.name;
      _emailController.text = user.email;
      _role = _normalizeRole(user.role);
    }
  }
  
   @override
   void dispose(){
     _nameController.dispose();
     _emailController.dispose();
     _passwordController.dispose();
     super.dispose();
   }

   Future<void> _submitForm() async {
     if (_isSaving) return;
     if (!_formKey.currentState!.validate()){
      return;
     }
     setState((){
       _isSaving = true;
     });

     try{
      if (_isEditing){
        await _apiService.updateUser(
          userId: widget.user!.userId, 
          user: UpdateUser(
            name: _nameController.text.trim(),
           email: _emailController.text.trim(),
           role: _role,
           password: _passwordController.text.isEmpty
             ? null
             : _passwordController.text,
          ),
        );
      }else{
             
      final newUser = CreateUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _role,
      );
      await _apiService.createUser(newUser);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            _isEditing
                ? 'User updated successfully'
                : 'User created successfully',
            ),
          backgroundColor: Colors.green,
        ),
      );}
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserApi()),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      setState(() {
       _role = 'author';
       _obscurePassword = true;
      });
     } catch (e) {
       if (!mounted) return;

       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_isEditing ? 'Update' : 'Create'} failed: $e',
            ),
          backgroundColor:  Colors.red,
        
        ),
       );
     } finally {
      if (mounted){
        setState((){
          _isSaving= false;
        });
      }
     }
   }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          _isEditing ? 'Edit User' : 'Create User',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty){
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if (value == null || value.trim().isEmpty){
                        return 'Email is required';
                      }
                      final email = value.trim();
                      if (!RegExp(
                         r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

               
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: _isEditing
                       ? 'New Password (Optional)'
                       : 'Password',
                  helperText: _isEditing
                      ? 'Leave blank to keep the current password' 
                      : 'At least 8 characters',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                         
                    ),
                    onPressed: (){
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value){
                  if (_isEditing &&
                     (value == null || value.isEmpty)){
                    return null;
                  }
                  if (value== null || value.isEmpty){
                    return 'Password is required';
                  }
                  if (value.length < 8){
                    return 'Use at least 8 characters';
                  }
                  return null;
                },

              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  prefixIcon: Icon(Icons.admin_panel_settings),
                  border: OutlineInputBorder(),
                ),
                items: const[
                  DropdownMenuItem(value: 'Admin',child: Text('Admin')),
                  DropdownMenuItem(value: 'Editor',child: Text('Editor')),
                  DropdownMenuItem(value: 'Author',child: Text('Author')),
                ],
                onChanged: _isSaving
                  ? null
                  : (value){
                    if (value != null){
                      setState(() {
                        _role = value;
                      });
                    }
                  },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  :  Text(
                        _isEditing
                        ? 'Update User'
                        : 'Save User',
                     style:const TextStyle(
                      fontSize: 16,
                     ),
                  ),
                ),
              ),
                ],
          ),
        ),
      ),
        ),
      ),
    );
    
  }
}