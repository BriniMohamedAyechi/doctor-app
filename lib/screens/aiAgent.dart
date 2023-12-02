import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiAgent extends StatefulWidget {
  @override
  _AiAgentState createState() => _AiAgentState();
}

class _AiAgentState extends State<AiAgent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController trestbpsController = TextEditingController();
  TextEditingController restecgController = TextEditingController();
  TextEditingController cholController = TextEditingController();
  TextEditingController fbsController = TextEditingController();
  TextEditingController thalachController = TextEditingController();
  TextEditingController exangController = TextEditingController();
  TextEditingController oldpeakController = TextEditingController();
  TextEditingController slopeController = TextEditingController();
  TextEditingController caController = TextEditingController();
  TextEditingController thalController = TextEditingController();
  String result = '';

  InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.deepPurple),
    ),
    fillColor: Colors.white,
    filled: true,
    enabled: true,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
  );
  Future<void> predictResults() async {
    // Convert the values to an array
    List<String> inputValues = [
      ageController.text,
      sexController.text,
      cpController.text,
      trestbpsController.text,
      restecgController.text,
      cholController.text,
      fbsController.text,
      thalachController.text,
      exangController.text,
      oldpeakController.text,
      slopeController.text,
      caController.text,
      thalController.text,
    ];

    // Create a Map with the 'user_input' key
    Map<String, String> data = {'user_input': inputValues.join(',')};

    // Send a POST request with form data
    Uri url = Uri.parse("http://localhost:5000");
    var response = await http.post(url, body: data);

    // Update the result based on the response
    setState(() {
      result = response.body;
    });

    // Determine which icon to show based on the result
    IconData icon =
        result.contains('Warning! You have chances of getting a heart disease!')
            ? Icons.heart_broken
            : Icons.favorite;

    // Show an AlertDialog with the result and icon
    String extractedResult = result.toString().split(':')[1].split('"')[1];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediction Result'),
          content: Row(
            children: [
              Text(extractedResult),
              SizedBox(width: 8),
              Icon(icon,
                  color: result.contains(
                          'Warning! You have chances of getting a heart disease!')
                      ? Colors.red
                      : Colors.green),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Color(0xFF0074d9),
          pinned: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('HeartRisk Analyzer'),
            background: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'images/white.png', // Replace with the actual path to your image
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 50, right: 50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    controller: ageController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Age',
                      icon:
                          Icon(Icons.event, size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: sexController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Gender',
                      icon: Icon(Icons.person,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: cpController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Chest Pain Type',
                      icon: Icon(Icons.warning,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: trestbpsController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Resting Blood Sugar',
                      icon: Icon(Icons.favorite,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: restecgController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Resting Electrocardiographic Results',
                      icon: Icon(Icons.graphic_eq,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: cholController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Serum Cholestoral in mg/dl',
                      icon: Icon(Icons.local_hospital,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: fbsController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Fasting Blood Sugar',
                      icon: Icon(Icons.local_dining,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: thalachController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Maximum Heart Rate Achieved',
                      icon: Icon(Icons.favorite,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: exangController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Exercise Induced Angina',
                      icon: Icon(Icons.warning,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: oldpeakController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Oldpeak',
                      icon: Icon(Icons.favorite,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: slopeController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Heart Rate Slope',
                      icon: Icon(Icons.trending_up,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: caController,
                    decoration: inputDecoration.copyWith(
                      labelText:
                          'Number of Major Vessels Colored by Flourosopy',
                      icon: Icon(Icons.healing,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: thalController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Thalium Stress Result',
                      icon: Icon(Icons.timeline,
                          size: 20, color: Color(0xFF0074d9)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: MaterialButton(
                      color: Color(0xFF0074d9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      minWidth: 250,
                      elevation: 5.0,
                      height: 50,
                      child: Text(
                        "Predict Results",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      onPressed: () async {
                        predictResults();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
