import 'package:get/get.dart';

class OrderController extends GetxController {
  DateTime? orderTime;
  RxInt? totalBill;
  RxString table = ''.obs;
  RxString orderId = ''.obs;
  RxList<dynamic> orderedItems = [].obs;
}