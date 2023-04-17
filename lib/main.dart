import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hospital/providers/api_calls.dart';
import 'package:hospital/screens/add_patient.dart';
import 'package:hospital/screens/home_page.dart';
import 'package:hospital/screens/log_in.dart';
import 'package:hospital/screens/patient_details_page.dart';
import 'package:hospital/screens/sign_up.dart';

void main() {
  Get.put(ApiCalls());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApiCalls>(
        builder: (controller) => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              getPages: [
                GetPage(
                  transition: Transition.fadeIn,
                  name: '/',
                  page: () => const MyApp(),
                ),
                GetPage(
                  transition: Transition.cupertino,
                  name: SignUpPage.routeName,
                  page: () => SignUpPage(),
                ),
                GetPage(
                  transition: Transition.cupertino,
                  name: LogInPage.routeName,
                  page: () => LogInPage(),
                ),
                GetPage(
                  transition: Transition.cupertino,
                  name: HomePage.routeName,
                  page: () => HomePage(),
                ),
                GetPage(
                  transition: Transition.cupertino,
                  name: PatientDetailsPage.routeName,
                  page: () => PatientDetailsPage(),
                ),
                GetPage(
                  transition: Transition.cupertino,
                  name: AddPatient.routeName,
                  page: () => AddPatient(),
                ),
              ],
              title: 'Hospital Management',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: Obx(() => controller.isLoggedIn.value == true
                  ? HomePage()
                  : FutureBuilder(
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Scaffold(
                                body: Center(
                                  child: Text('Loading'),
                                ),
                              )
                            : LogInPage();
                      },
                      future: controller.tryAutoLogIn(),
                    )),
              builder: EasyLoading.init(),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
