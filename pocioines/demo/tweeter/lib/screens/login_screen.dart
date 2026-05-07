import 'package:flutter/material.dart';

import '../core/facades/potion_facade.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.facade});

  final PotionFacade facade;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'admin';
    _passwordController.text = '12345678';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isRegisterMode) {
        await widget.facade.register(
          username: username,
          email: email,
          password: password,
        );
      }

      await widget.facade.login(username, password);

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _errorMessage = null;

      if (_isRegisterMode) {
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
      } else {
        _usernameController.text = 'admin';
        _emailController.clear();
        _passwordController.text = '12345678';
      }
    });
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }

    return null;
  }

  String? _usernameValidator(String? value) {
    final requiredError = _requiredValidator(value, 'El usuario');

    if (requiredError != null) {
      return requiredError;
    }

    final username = value!.trim();

    if (username.length < 3) {
      return 'El usuario debe tener al menos 3 caracteres';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (!_isRegisterMode) {
      return null;
    }

    final requiredError = _requiredValidator(value, 'El correo');

    if (requiredError != null) {
      return requiredError;
    }

    final email = value!.trim();

    if (!email.contains('@') || !email.contains('.')) {
      return 'Ingresa un correo válido';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    final requiredError = _requiredValidator(value, 'La contraseña');

    if (requiredError != null) {
      return requiredError;
    }

    if (_isRegisterMode && value!.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegisterMode ? 'Registro' : 'Inicio de sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.science,
                    size: 72,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isRegisterMode
                        ? 'Crear cuenta'
                        : 'Pociones de Minecraft',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    enabled: !_isLoading,
                    validator: _usernameValidator,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_isRegisterMode) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscurePassword,
                    validator: _passwordValidator,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _isRegisterMode
                                  ? 'Registrarme'
                                  : 'Iniciar sesión',
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isLoading ? null : _toggleMode,
                    child: Text(
                      _isRegisterMode
                          ? 'Ya tengo cuenta'
                          : 'Crear cuenta nueva',
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