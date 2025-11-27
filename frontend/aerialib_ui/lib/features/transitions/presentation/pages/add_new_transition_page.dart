import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';

import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/input_fields/dropdown_field.dart';
import '../../../../shared/widgets/input_fields/int_input_field.dart';
import '../../../../shared/widgets/input_fields/text_input_field.dart';
import '../../domain/transition_entity.dart';
import '../cubit/transition_cubit.dart';

class AddNewTransitionPage extends StatefulWidget {
  const AddNewTransitionPage({super.key});

  @override
  State<AddNewTransitionPage> createState() => _AddNewTransitionPageState();
}

class _AddNewTransitionPageState extends State<AddNewTransitionPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final levelController = TextEditingController();
  final typeController = TextEditingController();

  final descriptionController = TextEditingController();
  final teachingCuesController = TextEditingController();
  final safetyCuesController = TextEditingController();
  final progressionsController = TextEditingController();
  final modificationsController = TextEditingController();
  final commonErrorsController = TextEditingController();

  String? fromPoseId;
  String? toPoseId;

  String _fromPoseSearchQuery = '';
  String _toPoseSearchQuery = '';

  @override
  void initState() {
    super.initState();
    typeController.text = 'unspecified';
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    levelController.dispose();
    teachingCuesController.dispose();
    safetyCuesController.dispose();
    progressionsController.dispose();
    modificationsController.dispose();
    commonErrorsController.dispose();
    super.dispose();
  }

  Future<void> createNewTransition() async {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state as AuthLoggedIn;
      final now = DateTime.now();

      final levelText = levelController.text.trim();
      final level = int.tryParse(levelText) ?? -1;

      final newTransition = TransitionEntity(
        id: const Uuid().v4(),
        fromPoseId: fromPoseId ?? '',
        toPoseId: toPoseId ?? '',
        name: nameController.text.trim(),
        apparatus: 'lyra',
        level: level,
        transitionType: typeController.text.trim(),
        description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
        teachingCues: teachingCuesController.text.trim().isNotEmpty ? teachingCuesController.text.trim() : null,
        safetyCues: safetyCuesController.text.trim().isNotEmpty ? safetyCuesController.text.trim() : null,
        progressions: progressionsController.text.trim().isNotEmpty ? progressionsController.text.trim() : null,
        modifications: modificationsController.text.trim().isNotEmpty ? modificationsController.text.trim() : null,
        commonErrors: commonErrorsController.text.trim().isNotEmpty ? commonErrorsController.text.trim() : null,
        createdBy: user.user.uid,
        updatedBy: user.user.uid,
        createdAt: now,
        updatedAt: now,
        isSynced: 0,
      );

      await context.read<TransitionCubit>().createNewTransition(
        transition: newTransition,
        token: user.user.token,
      );

      context.goNamed('transition-library');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Add New Transition"),
      ),
      body: BlocConsumer<TransitionCubit, TransitionState>(
        listener: (context, state) {
          if (state is TransitionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("There was an error adding the transition")),
            );
          } else if (state is AddNewTransitionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Transition added successfully")),
            );
            context.goNamed('transition-library');
          }
        },
        builder: (context, state) {
          if (state is TransitionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return BlocBuilder<PosesCubit, PosesState>(
            builder: (context, poseState) {
              if (poseState is! GetPosesSuccess) {
                return const Center(child: CircularProgressIndicator());
              }

              final allPoses = poseState.poses;

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        /// Basic Info
                        ExpandableCard(
                          title: "Basic Info",
                          initiallyExpanded: true,
                          children: [
                            /// From Pose Search
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("From Pose", style: TextStyle(fontWeight: FontWeight.bold)),
                                  PoseTEXTSearchBar(
                                    hintText: 'Search From Pose',
                                    suggestionList: allPoses,
                                    onSearchChanged: (query) => setState(() => _fromPoseSearchQuery = query),
                                    onSuggestionTapped: (pose) => setState(() => fromPoseId = pose.id),
                                  ),
                                  if (fromPoseId != null)
                                    Text(
                                      "Selected: ${allPoses.firstWhere((p) => p.id == fromPoseId).displayName}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),

                            /// To Pose Search
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("To Pose", style: TextStyle(fontWeight: FontWeight.bold)),
                                  PoseFULLSearchBar(
                                    hintText: 'Search To Pose',
                                    suggestionList: allPoses,
                                    onSearchChanged: (query) => setState(() => _toPoseSearchQuery = query),
                                    onSuggestionTapped: (pose) => setState(() => toPoseId = pose.id),
                                  ),
                                  if (toPoseId != null)
                                    Text(
                                      "Selected: ${allPoses.firstWhere((p) => p.id == toPoseId).displayName}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            DropdownField("Type", typeController, Constants.transitionTypeOptions),
                          ],
                        ),

                        /// Additional Info
                        ExpandableCard(
                          title: "Additional Info",
                          initiallyExpanded: true,
                          children: [
                            TextInputField("Transition Name", nameController),
                            IntInputField("Level", levelController),
                            TextInputField("Description", descriptionController, maxLines: 2),
                            const SizedBox(height: 10),
                          ],
                        ),

                        /// Instructor Notes
                        ExpandableCard(
                          title: "Instructor Notes",
                          initiallyExpanded: false,
                          children: [
                            TextInputField("Teaching Cues", teachingCuesController, maxLines: 2),
                            TextInputField("Safety Cues", safetyCuesController, maxLines: 2),
                            TextInputField("Progressions", progressionsController, maxLines: 2),
                            TextInputField("Modifications", modificationsController, maxLines: 2),
                            TextInputField("Common Errors", commonErrorsController, maxLines: 2),
                          ],
                        ),

                        ElevatedButton(
                          onPressed: createNewTransition,
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PoseTEXTSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final List<PoseEntity> suggestionList;
  final Function(PoseEntity)? onSuggestionTapped;
  final String? hintText;
  final String? fromPage;

  const PoseTEXTSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.suggestionList,
    this.onSuggestionTapped,
    this.hintText,
    this.fromPage,
  });

  @override
  State<PoseTEXTSearchBar> createState() => _PoseTEXTSearchBarState();
}

class _PoseTEXTSearchBarState extends State<PoseTEXTSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<PoseEntity> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      } else {
        _updateOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _updateOverlay() {
    _filteredSuggestions = widget.suggestionList
        .where((pose) => pose.displayName.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    _removeOverlay();

    if (_filteredSuggestions.isEmpty) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx,
          top: position.dy + box.size.height,
          width: box.size.width,
          child: Material(
            elevation: 4,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _filteredSuggestions.map((pose) {
                return ListTile(
                  title: Text(pose.displayName),
                  onTap: () {
                    _controller.text = pose.displayName;
                    widget.onSearchChanged(pose.displayName);
                    widget.onSuggestionTapped?.call(pose);
                    _focusNode.unfocus();
                    _removeOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: (value) {
        widget.onSearchChanged(value);
        _updateOverlay();
      },
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Search Poses',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}


class PoseFULLSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final List<PoseEntity> suggestionList;
  final Function(PoseEntity)? onSuggestionTapped;
  final String? hintText;
  final String? fromPage;

  const PoseFULLSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.suggestionList,
    this.onSuggestionTapped,
    this.hintText,
    this.fromPage,
  });

  @override
  State<PoseFULLSearchBar> createState() => _PoseFULLSearchBarState();
}

class _PoseFULLSearchBarState extends State<PoseFULLSearchBar> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: widget.hintText,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (value) {
            widget.onSearchChanged(value);
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final suggestions = widget.suggestionList
            .where((pose) => pose.displayName.toLowerCase().contains(controller.text.toLowerCase()))
            .toList();

        return List<ListTile>.generate(suggestions.length, (int index) {
          final PoseEntity pose = suggestions[index];
          return ListTile(
            title: Text(pose.displayName),
            onTap: () {
              setState(() {
                controller.text = pose.displayName; // ✨ Replace search bar text
                controller.closeView(pose.displayName);
              });

              if (widget.onSuggestionTapped != null) {
                widget.onSuggestionTapped!(pose);
              } else {
                context.goNamed(
                  'pose-view',
                  pathParameters: {'poseId': pose.id},
                  queryParameters: {'from': widget.fromPage},
                );
              }
            },
          );
        });
      },
    );
  }
}
