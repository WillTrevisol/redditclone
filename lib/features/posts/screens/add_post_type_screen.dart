import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/utils.dart';
import '../../../models/community.dart';
import '../../../theme/theme.dart';
import '../../community/controller/community_controller.dart';
import '../controller/post_controller.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({super.key, required this.type});

  final String type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  List<Community> communities = [];
  Community? selectedCommunity;
  File? fileImage;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectImage() async {
    final result = await pickImage();

    if (result != null) {
      setState(() {
        fileImage = File(result.paths.first ?? '');
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' && fileImage != null && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
        context: context, 
        title: titleController.text, 
        community: selectedCommunity ?? communities[0], 
        image: fileImage
      );

      return;
    }

    if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
        context: context, 
        title: titleController.text, 
        community: selectedCommunity ?? communities[0], 
        description: descriptionController.text
      );

      return;
    }

    if (widget.type == 'link' && linkController.text.isNotEmpty &&titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
        context: context, 
        title: titleController.text, 
        community: selectedCommunity ?? communities[0], 
        link: linkController.text,
      );

      return;
    }

    showSnackBar(context, 'Please enter all the fields');

  }

  @override
  Widget build(BuildContext context) {
    
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);
    final bool isTypeImage = widget.type == 'image';
    final bool isTypeLink = widget.type == 'link';
    final bool isTypeText = widget.type == 'text';

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: <Widget> [
          TextButton(
            onPressed: () => isLoading ? null : sharePost(),
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading ? const LoadingWidget() : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: titleController,
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: 'Enter title here',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none
                    )
                  ),
                  contentPadding: const EdgeInsets.all(18)
                ),
              ),
              const SizedBox(height: 10),
              if (isTypeImage)
                GestureDetector(
                  onTap: selectImage,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    strokeWidth: 2,
                    color: currentTheme.primaryColorLight,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: fileImage != null ? Image.file(fileImage!) 
                      : const Center(
                        child: Icon(
                          Icons.camera,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
        
              if (isTypeText)
                TextField(
                  controller: descriptionController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Enter description here',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none
                      )
                    ),
                    contentPadding: const EdgeInsets.all(18)
                  ),
                ),
        
              if (isTypeLink)
                TextField(
                  controller: linkController,
                  decoration: InputDecoration(
                    hintText: 'Enter link here',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none
                      )
                    ),
                    contentPadding: const EdgeInsets.all(18)
                  ),
                ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Select Community'),
              ),
        
              ref.watch(userCommunitiesProvider).when(
                data: (data) {
                  communities = data;
        
                  if (data.isEmpty) {
                    return const SizedBox(
        
                    );
                  }
        
                  return DropdownButton(
                    isExpanded: true,
                    value: selectedCommunity ?? data[0],
                    items: data.map(
                      (community) => DropdownMenuItem(
                        value: community,
                        child: Text(community.name),
                      )
                    ).toList(), 
                    onChanged: (value) => setState(() => selectedCommunity = value),
                  );
                },
                error: (error, stackTrace) => ErrorText(message: error.toString()), 
                loading: () => const LoadingWidget(),
              ),
            ],
          ),
        ),
      )
    );
  }
}