import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/theme.dart';
import '../controller/community_controller.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {

  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {

  File? bannerFile;
  File? avatarFile;

  void selectBannerImage() async {
    final result = await pickImage();

    if (result != null) {
      setState(() {
        bannerFile = File(result.paths.first ?? '');
      });
    }
  }

  void selectAvatarImage() async {
    final result = await pickImage();

    if (result != null) {
      setState(() {
        avatarFile = File(result.paths.first ?? '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
      data: (data) => Scaffold(
        backgroundColor: Pallete.darkModeAppTheme.appBarTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Community'),
          centerTitle: false,
          actions: <Widget> [
            TextButton(
              onPressed: () {}, 
              child: const Text('Save'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget> [
              SizedBox(
                height: 200,
                child: Stack(
                  children: <Widget> [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        strokeWidth: 2,
                        color: Pallete.darkModeAppTheme.primaryColorLight,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: bannerFile != null ? Image.file(bannerFile!) : data.banner.isEmpty || data.banner == Constants.bannerDefault 
                          ? const Center(
                            child: Icon(
                              Icons.camera,
                              size: 40,
                            ),
                          )
                          : Image.network(data.banner),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: selectAvatarImage,
                        child: avatarFile != null 
                        ? CircleAvatar(
                            backgroundImage: FileImage(avatarFile!),
                            radius: 32,
                          )
                        : CircleAvatar(
                          backgroundImage: NetworkImage(data.avatar),
                          radius: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => ErrorText(message: error.toString()), 
      loading: () => const LoadingWidget(),
    );
    
    
  }
}