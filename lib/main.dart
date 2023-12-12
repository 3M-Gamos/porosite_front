import 'package:flutter/material.dart' hide Material;
// main.dart
import 'porosity_main.dart';
import 'models/material.dart' as my_material; // using an alias for your Material class
import 'package:loading_animation_widget/loading_animation_widget.dart';
void main() {
  runApp(MyApp());
}

String? _validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  final number = double.tryParse(value);
  if (number == null) {
    return 'Please enter a valid number';
  }
  if (number <= 0) {
    return 'Please enter a number greater than zero';
  }
  return null; // means input is valid
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Porosity Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PorosityForm(),
    );
  }
}

class PorosityForm extends StatefulWidget {
  @override
  _PorosityFormState createState() => _PorosityFormState();

}

class _PorosityFormState extends State<PorosityForm> {
  bool _isLoading = false;
  double? _porosityResult;
  List<my_material.Material> materials = [];
  my_material.Material? _selectedMaterial;
  final _formKey = GlobalKey<FormState>();

  // Define controllers for the form fields
  final dryMassController = TextEditingController();
  final wetMassController = TextEditingController();
  final temperatureWaterController = TextEditingController();
  final knownSubstrateMassController = TextEditingController();
  final dryStringMassController = TextEditingController();
  final wetStringMassController = TextEditingController();
  final stringDensityController = TextEditingController();
  final volumeController = TextEditingController();
  final theoreticalMaxDensityController = TextEditingController();
  final materialchooserController =TextEditingController();
  // Add controllers for other fields as needed...
  List<String> _materialOptions = ['Other'];
  List<String> _stringOptions = ['Other'];
  String _selectedString = 'Other';
  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    dryMassController.dispose();
    wetMassController.dispose();
    temperatureWaterController.dispose();
    knownSubstrateMassController.dispose();
    dryStringMassController.dispose();
    wetStringMassController.dispose();
    stringDensityController.dispose();
    volumeController.dispose();
    theoreticalMaxDensityController.dispose();
    // Dispose other controllers...
    super.dispose();
  }
  void initState() {
    super.initState();
    _fetchMaterialOptions();
    _fetchStringOptions();
  }
  Future<void> _fetchMaterialOptions() async {
    // ... Implement API call to fetch material options and update state ...
    try {
      final porosityServices = PorosityService();
      materials = await porosityServices.materialDrop() ;
      // Add a default "Other" option
    } catch (e) {
      // Handle the error, maybe show a snackbar or a dialog
      print('materials : $materials');
      print('Failed to fetch materials: $e');
    }
    try {
      setState(() {
        _materialOptions = materials.map((mat) => mat.nom).toList();
        _materialOptions.insert(0, 'Other');
      });
    }catch (e) {
      print('failed to map : $e');
    }
  }
  Future<void> _fetchStringOptions() async {
    // ... Implement API call to fetch string options and update state ...
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a Snackbar and make the API call
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calculating Porosity...')),
      );

      var requestData = {
        'dry_mass': double.tryParse(dryMassController.text),
        'wet_mass': double.tryParse(wetMassController.text),
        'temperature_water': double.tryParse(temperatureWaterController.text),
        'known_substrate_mass': double.tryParse(knownSubstrateMassController.text), 
        'dry_string_mass': double.tryParse(dryStringMassController.text),
        'wet_string_mass': double.tryParse(wetStringMassController.text),
        'string_density': double.tryParse(stringDensityController.text),
        'volume': double.tryParse(volumeController.text),
        'theoretical_max_density': double.tryParse(theoreticalMaxDensityController.text),

        // Add other fields as needed...
      };

      try {
        final porosityService = PorosityService();
        final porosity = await porosityService.calculatePorosity(requestData);
        // Use the result to update the UI or state as needed...
        setState(() {
      _isLoading = false;
      _porosityResult = porosity;
    });
        print('Porosity: $porosity');
      } catch (e) {
        print('Error calculating porosity: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Porosity Calculator'),
      ),body:  SingleChildScrollView(
      child:Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: dryMassController,
                decoration: InputDecoration(labelText: 'Dry Mass'),
                keyboardType: TextInputType.number,
               validator: _validateNumber,
              ),
              TextFormField(
                controller: wetMassController,
                decoration: InputDecoration(labelText: 'Wet Mass'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: temperatureWaterController,
                decoration: InputDecoration(labelText: 'Temperture water'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: knownSubstrateMassController,
                decoration: InputDecoration(labelText: 'SubstrateMass'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: dryStringMassController,
                decoration: InputDecoration(labelText: 'DryStringMass'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: wetStringMassController,
                decoration: InputDecoration(labelText: 'wetStringMassController'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: stringDensityController,
                decoration: InputDecoration(labelText: 'stringDensityController'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: volumeController,
                decoration: InputDecoration(labelText: 'volume'),
                keyboardType: TextInputType.number,
               validator: _validateNumber,
              ),
              TextFormField(
                controller: theoreticalMaxDensityController,
                decoration: InputDecoration(labelText: 'theoreticalMaxDensity'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
             DropdownButtonFormField<String>(
            value: _selectedMaterial?.nom ?? 'Other',
            items: _materialOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              my_material.Material? material = materials.firstWhere(
                (mat) => mat.nom == newValue,
                orElse: () => my_material.Material(id: 0, nom: 'Other', densiteTheoriqueMin: 0, densiteTheoriqueMax: 0),
              );
              setState(() {
                _selectedMaterial = material.nom == 'Other' ? null : material;
                if (material.nom != 'Other') {
                  theoreticalMaxDensityController.text = material.densiteTheoriqueMax.toString();
                } else {
                  theoreticalMaxDensityController.clear();
                } 
                });
            },
            decoration: InputDecoration(
              labelText: 'Material Density',
            ),      // Manual input for material density if 'Other' i
            ),

                  // Manual input for material density if 'Other' is selected
                  if (_selectedMaterial == 'Other')
                    TextFormField(
                      controller: materialchooserController,
                      decoration: InputDecoration(labelText: 'Enter the choosen material'),
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                      // Add validator if required
                    ),
                    Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Calculate Porosity'),
                ),
                    ),
            if (_porosityResult != null)
                  Text('Porosity: ${_porosityResult?.toStringAsFixed(2)}%'),
                
            ],
          ),
        ),
      ),
      ),
    );
  }
}




