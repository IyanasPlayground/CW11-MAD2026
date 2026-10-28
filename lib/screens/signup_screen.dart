import 'package:flutter/material.dart';
import 'success_screen.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();
  
  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //not sure if i should keep the extra form item i added from lab10
  final TextEditingController _foodController = TextEditingController();
  final _dateController = TextEditingController();
  //slipt the code up


  bool _isLoading = false;
  String? _tipText = '';
  bool _isError = false;
  // State fields — add near your controllers
  DateTime? _birthDate;
  bool _obscurePassword = true;
  bool _submitting = false;

  //moved higher in code
  

  final List<String> _sampleTips = [
    "Ensure your password has 12 or more characters",
    "Ensure your password has a mix of letters and numbers",
    "Use an email address that you often check",
  ];
  int _TipIndex = 0;

  void _getTip() async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _tipText = null;
    });

    setState(() {
      _isLoading = false;
      _tipText = _sampleTips[_TipIndex];
      _TipIndex = (_TipIndex + 1) % _sampleTips.length;
    });
  }

  void _simulateError() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
      _isError = true;
      _tipText = 'Failed to load tip. Please try again!';
    });
  }
    // State field
  Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _submitting = true);  // potion starts brewing

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;  // user may have left the screen

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
              userName: _nameController.text.trim()),
        ),
      );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold( // 👨 Parent
      appBar: AppBar(
        title: const Text('Sign up for our Dorm Halloween Party!'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Fill everything out',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              
              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name. Making an account helps us keep up with you and save your response btw!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _dateController,
                readOnly: true,  // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) => _birthDate == null
                    ? 'Pick your birth date' : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),  // no future birthdays!
                  );
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                      _dateController.text =
                          '${picked.month}/${picked.day}/${picked.year}';
                    });
                  }
                },
              ),

            // 🎛️ State field — true = dots, false = letters
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          
          ),


              // What user will bring
              TextFormField(
                controller: _foodController,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'What will you bring?',
                  prefixIcon: Icon(Icons.fastfood),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter all you plan to bring';
                  }
                  if (!value.contains(',')) {
                    return 'Please seperate all items with a comma';
                  }
                  if (value.length < 6) {
                    return 'Please bring at least two things.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),


              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.pink,
                child: Column(
                  children: [
                    const Text('AI Signup Coach'),
                    const SizedBox(height: 15),

                    if (_isLoading) 
                      const CircularProgressIndicator(),

                    if (!_isLoading && _isError) 
                      Column(
                        children: [
                          Text(
                            _tipText ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                          OutlinedButton(
                            onPressed: _getTip,
                            child: const Text('Try again!'),
                          ),
                        ],
                      ),

                    if (!_isLoading && !_isError && _tipText != null) 
                      Column(
                        children: [
                          Text(_tipText!, textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                        ],
                      ),

                    if (!_isLoading && !_isError && _tipText == null)
                      const Text('Tap to get password advice.'),

                    const SizedBox(height: 9),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _getTip,
                      child: const Text('Get a signup tip'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


            
              // The Sign Up button:
              ElevatedButton(
                onPressed: _submitting ? null : _submit,  // null = disabled
                child: _submitting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Join the Mansion',
                          style: TextStyle(fontSize: 18)),
              )


              // 🚀 Sign Up Button
              //assuming it replaces og button
             //ElevatedButton(
               // onPressed: () {
                 // if (_formKey.currentState!.validate()) {
                   // ScaffoldMessenger.of(context).showSnackBar(
                     // const SnackBar(
                       // content: Text('Signup complete — your form passed! Account made'),
                        //backgroundColor: Colors.green,
                     // ),
                   // );
                 // }
               // },
    //            style: ElevatedButton.styleFrom(
      //            backgroundColor: Colors.pink,
        //          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          //      ),
            //    child: const Text(
              //    'Sign Up',
 //               //  style: TextStyle(fontSize: 18),
   //             ),
          //  ),
           ],
          ),
        ),
      ),
    );
  }
}


