import 'package:get/get.dart';

class OrderController extends GetxController {
  RxString table = ''.obs;
  DateTime? orderTime;
  RxList<dynamic> orderedItems = [].obs;
}