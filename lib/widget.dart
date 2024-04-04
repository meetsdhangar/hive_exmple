import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/homecontroller.dart';

Widget openDialog(Map<String, dynamic>? item, context) {
  final controller = Get.put(HomeController());
  var namecontroller = TextEditingController();
  var qtycontroller = TextEditingController();

  if (item != null) {
    namecontroller.text = item['name'];
    qtycontroller.text = item['qty'];
  }
  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: "name"),
          controller: namecontroller,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Quantity"),
          controller: qtycontroller,
        )
      ],
    ),
    actions: [
      TextButton(
          onPressed: () {
            item == null
                ? controller.addData(
                    {'name': namecontroller.text, 'qty': qtycontroller.text})
                : controller.updateData(
                    {'name': namecontroller.text, 'qty': qtycontroller.text},
                    item['key']);

            Navigator.pop(context);
            namecontroller.clear();
            qtycontroller.clear();
          },
          child: Text(item == null ? 'Add' : 'Update')),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            namecontroller.clear();
            qtycontroller.clear();
          },
          child: Text('Cancel'))
    ],
  );
}
