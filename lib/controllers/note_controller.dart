import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:bano_task3/globles/pallets.dart';
import 'package:bano_task3/models/note_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteController extends GetxController {
  final colors = [color1, color2, color3, color4];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final type = "personal".obs;
  final types = ["personal", "work", "others"];
  final currentNote = Rx<NotesModel?>(null);

  Stream<List<NotesModel>> getNotes() {
    try {
      return FirebaseFirestore.instance.collection("notes").snapshots().map(
        (event) {
          var allNotes = <NotesModel>[];
          allNotes.clear();
          for (var element in event.docs) {
            print(element.data());
            final newNote = NotesModel.fromMap(element.data());
            allNotes.add(newNote);
            print(newNote.toMap());
          }
          return allNotes;
        },
      );
    } catch (e) {
      print(e);
      return Stream.value(<NotesModel>[]);
    }
  }

  Stream<List<NotesModel>> getTrashNotes() {
    try {
      return FirebaseFirestore.instance
          .collection("deletedNotes")
          .snapshots()
          .map(
        (event) {
          var allNotes = <NotesModel>[];
          allNotes.clear();
          for (var element in event.docs) {
            print(element.data());
            final newNote = NotesModel.fromMap(element.data());
            allNotes.add(newNote);
            print(newNote.toMap());
          }
          return allNotes;
        },
      );
    } catch (e) {
      print(e);
      return Stream.value(<NotesModel>[]);
    }
  }

  Future<void> createNote() async {
    try {
      final ref = FirebaseFirestore.instance.collection("notes").doc();
      final date = DateTime.now();
      final formatedDate = DateFormat("dd-MM-yyyy").format(date);
      final note = NotesModel(
        id: ref.id,
        title: titleController.text.trim(),
        noteMessage: bodyController.text.trim(),
        date: formatedDate,
        type: type.value,
      );
      await ref.set(note.toMap());
      Get.back();
    } catch (e) {
      print("Error creating note: $e");
    }
  }

  Future<void> editNote() async {
    try {
      final note = currentNote.value!;
      final ref = FirebaseFirestore.instance.collection("notes").doc(note.id);
      final date = DateTime.now();
      final formatedDate = DateFormat("dd-MM-yyyy").format(date);
      final editedNote = note.copyWith(
        title: titleController.text.trim(),
        noteMessage: bodyController.text.trim(),
        date: formatedDate,
        type: type.value,
      );
      await ref.set(editedNote.toMap());
      Get.back();
    } catch (e) {
      print("Error creating note: $e");
    }
  }

  Future<void> deleteNote({required NotesModel note}) async {
    try {
      await moveToTrash(note: note);
      await FirebaseFirestore.instance
          .collection("notes")
          .doc(note.id)
          .delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> moveToTrash({required NotesModel note}) async {
    try {
      final ref =
          FirebaseFirestore.instance.collection("deletedNotes").doc(note.id);
      final trashNote = note.copyWith(id: ref.id);
      await ref.set(trashNote.toMap());
    } catch (e) {
      print("Error creating note: $e");
    }
  }

  Future<void> removeFromTrash({required NotesModel note}) async {
    try {
      await FirebaseFirestore.instance
          .collection("deletedNotes")
          .doc(note.id)
          .delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> restoreNote() async {
    try {
      final note = currentNote.value!;
      await removeFromTrash(note: note);
      titleController.text = note.title;
      bodyController.text = note.noteMessage;
      type.value = note.type;
      await createNote();
    } catch (e) {
      print("Error restoring note: $e");
    }
  }

  void resetFields() {
    titleController.clear();
    bodyController.clear();
    type.value = "personal";
  }
}
