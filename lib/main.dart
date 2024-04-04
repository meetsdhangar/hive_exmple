import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_exmple/controllers/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('my_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HiveScreen(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var namecontroller = TextEditingController();
  var qtycontroller = TextEditingController();
  final _mybox = Hive.box('my_box');

  List<Map<String, dynamic>> datalist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void addData(newdata) async {
    await _mybox.add(newdata);
    getdata();
  }

  void updateData(newdata, itemkey) async {
    await _mybox.put(itemkey, newdata);
    getdata();
  }

  void deletedData(itemkey) async {
    await _mybox.delete(itemkey);
    getdata();
  }

  void getItemByKey(itemkey) async {
    await _mybox.get(itemkey);
  }

  void getdata() {
    final mydata = _mybox.keys.map((key) {
      final item = _mybox.get(key);
      return {'key': key, 'name': item['name'], 'qty': item['qty']};
    }).toList();

    setState(() {
      datalist = mydata.reversed.toList();
    });
  }

  mydialogbox(Map<String, dynamic>? item, context) {
    if (item != null) {
      namecontroller.text = item['name'];
      qtycontroller.text = item['qty'];
    }
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item == null ? 'Add' : 'Update'),
          TextFormField(
            controller: namecontroller,
            decoration: InputDecoration(hintText: 'name'),
          ),
          TextFormField(
            controller: qtycontroller,
            decoration: InputDecoration(hintText: 'Quantity'),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              item == null
                  ? addData(
                      {'name': namecontroller.text, 'qty': qtycontroller.text})
                  : updateData(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => mydialogbox(null, context));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: datalist.length,
          itemBuilder: (context, index) {
            final mydata = datalist[index];
            return ListTile(
              title: Text(mydata['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => mydialogbox(mydata, context));
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        deletedData(mydata['key']);
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            );
          }),
    );
  }
}
