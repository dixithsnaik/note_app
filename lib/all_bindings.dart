import 'package:get/get.dart';
import 'package:bano_task3/controllers/note_controller.dart';

class AllBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteController>(() => NoteController());
  }
}
