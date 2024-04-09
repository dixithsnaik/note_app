import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:bano_task3/controllers/note_controller.dart';
import 'package:bano_task3/globles/pallets.dart';
import 'package:bano_task3/screens/add_note_screen.dart';
import 'package:bano_task3/screens/trash_notes.dart';
import 'package:bano_task3/widgets/custom_button.dart';
import 'package:bano_task3/widgets/note_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            CustomButton(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const TrashPage()));
                              },
                              icon: SvgPicture.asset(
                                "assets/icons/delete.svg",
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder(
                      stream: noteController.getNotes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final notes = snapshot.data!;
                        if (notes.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Text(
                              "Keep track of everything with our easy-to-use note app. Write down ideas, create lists, plan projects - the possibilities are endless!",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: timeColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: notes.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              onDelete: () {
                                noteController.deleteNote(note: note);
                                Navigator.of(context).pop();
                              },
                              note: note,
                              index: index,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    noteController.resetFields();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddNoteScreen()));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: flotingActionColor,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 90, 90, 90),
                          blurRadius: 20.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              0.0, 0.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.add,
                        color: whiteColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
