import 'package:get/get.dart';

class OrderController extends GetxController {
  DateTime? orderTime;
  RxString table = ''.obs;
  RxString orderId = ''.obs;
  RxList<dynamic> orderedItems = [].obs;
}