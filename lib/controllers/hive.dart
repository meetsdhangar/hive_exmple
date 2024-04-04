import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_exmple/controllers/homecontroller.dart';
import 'package:hive_exmple/widget.dart';

class HiveScreen extends StatelessWidget {
  const HiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => openDialog(null, context),
            );
          },
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: controller.datalist.length,
          itemBuilder: (context, index) {
            var mylist = controller.datalist[index];
            return ListTile(
              title: Text(mylist['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => openDialog(mylist, context),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.green,
                      )),
                  IconButton(
                      onPressed: () {
                        controller.deletedData(mylist['key']);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
