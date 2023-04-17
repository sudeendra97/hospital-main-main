import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/api_calls.dart';

class PatientDetailsPage extends StatelessWidget {
  PatientDetailsPage({super.key});
  static const routeName = '/PatientDetailsPage';
  final ApiCalls calls = Get.find<ApiCalls>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApiCalls>(
        builder: (controller) => Scaffold(
            appBar: AppBar(
              title: const Text('Patient Details'),
            ),
            body: Obx(
              () => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      designWidget('Patient Name : ',
                          controller.patient.value['Patient_Name']),
                      designWidget('Age : ', controller.patient.value['Age']),
                      designWidget('Complaint : ',
                          controller.patient.value['Complaint']),
                      designWidget(
                          'Gender : ', controller.patient.value['Gender']),
                      designWidget('Instructions : ',
                          controller.patient.value['Instructions']),
                      Row(
                        children: [
                          Container(
                            width: 150,
                            child: const Text(
                              'Instruction File :',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _launchURL(controller
                                    .patient.value['Instruction_File']);
                              },
                              child: const Text(
                                'File',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ))
                        ],
                      )
                      // designWidget('Instruction File : ',
                      //     controller.patient.value['Instruction_File']),
                    ],
                  ),
                ),
              ),
            )));
  }

  _launchURL(String msg) async {
    var url = msg;
    if (msg.startsWith('http') != true && msg.startsWith('https') != true) {
      url = 'https://$msg';
    }
    log(url);
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
        .then((value) {
      log(value.toString());
      if (value == false) {
        Get.snackbar(
          'Alert',
          'Cannot launch Url',
        );
      }
    });
  }

  Widget designWidget(String name, var data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 150,
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
          Text(
            data.toString(),
          ),
        ],
      ),
    );
  }
}
