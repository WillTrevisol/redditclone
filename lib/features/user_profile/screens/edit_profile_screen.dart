import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/theme.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {

  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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
        profileFile = File(result.paths.first ?? '');
      });
    }
  }

  void saveProfile() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
      context: context, 
      profilePicture: profileFile,
      bannerFile: bannerFile,
      name: nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {

    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    
    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (data) => Scaffold(
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: false,
          actions: <Widget> [
            TextButton(
              onPressed: isLoading ? null : () => saveProfile(),
              child: const Text('Save'),
            ),
          ],
        ),
        body: isLoading ? const LoadingWidget() : Padding(
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
                        color: currentTheme.primaryColorLight,
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
                        child: profileFile != null 
                        ? CircleAvatar(
                            backgroundImage: FileImage(profileFile!),
                            radius: 32,
                          )
                        : CircleAvatar(
                          backgroundImage: NetworkImage(data.profilePicture),
                          radius: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'u/Name',
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
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => ErrorText(message: error.toString()), 
      loading: () => const LoadingWidget(),
    );
  }
}