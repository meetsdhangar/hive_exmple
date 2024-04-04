import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController {
  final _myBox = Hive.box('my_box');

  RxList datalist = [].obs;

  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  void addData(newData) async {
    await _myBox.add(newData);
    getdata();
  }

  void updateData(newData, itemKey) async {
    await _myBox.put(itemKey, newData);
    getdata();
  }

  void deletedData(itemKey) async {
    await _myBox.delete(itemKey);
    getdata();
  }

  void getItemByKey(itemKey) async {
    await _myBox.get(itemKey);
  }

  void getdata() {
    final mydata = _myBox.keys.map((key) {
      final item = _myBox.get(key);
      return {'key': key, 'name': item['name'], 'qty': item['qty']};
    }).toList();

    datalist.value = mydata.reversed.toList();
  }
}
