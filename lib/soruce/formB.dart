import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormB extends StatefulWidget {
  const FormB({super.key});

  @override
  State<FormB> createState() => _RelatedFieldsState();
}


class _RelatedFieldsState extends State<FormB> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormBuilderState>();
  int _currentStep = 0;

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildProgressIndicator() {
    final List<IconData> stepIcons = [
      Icons.person,
      Icons.contact_mail,
      Icons.cloud_upload,
    ];

    final List<String> stepLabels = ['Pers.', 'Contact', 'Upload'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        return GestureDetector(
          onTap: () => _goToStep(index),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor:
                    index <= _currentStep ? Colors.blue : Colors.grey,
                child: Icon(
                  stepIcons[index],
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(stepLabels[index]),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Cancelar'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProgressIndicator(),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Personal', style: TextStyle(fontSize: 24)),
                      const Text(
                          'Pulsa "Contact" o pulsa el botón de "Continue".'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _goToStep(1),
                        child: const Text('Continue'),
                      ),
                      _buildCancelButton(context),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Contact', style: TextStyle(fontSize: 24)),
                      const Text(
                          'Pulsa "Upload" o pulsa el botón de "Continue".'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _goToStep(2),
                        child: const Text('Continue'),
                      ),
                      _buildCancelButton(context),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Email', style: TextStyle(fontSize: 24)),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'address',
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      FormBuilderTextField(
                        name: 'mobile',
                        decoration: const InputDecoration(
                          labelText: 'Mobile No',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            final formData = _formKey.currentState?.value;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Resumen de Envío'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text('Email: ${formData?['email']}'),
                                      Text('Address: ${formData?['address']}'),
                                      Text('Mobile No: ${formData?['mobile']}'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Continue'),
                      ),
                      _buildCancelButton(context),
                    ],
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
