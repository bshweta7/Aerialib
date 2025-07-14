import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/helpers/conversions.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/helpers/formatters.dart';
import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/info_display/info_row.dart';
import '../../../pose/presentation/pages/pose_view_sheet.dart';
import 'flow_details_sheet.dart';


class FlowViewPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowViewPage({super.key, required this.flow});

  @override
  State<FlowViewPage> createState() => _FlowViewPageState();
}

class _FlowViewPageState extends State<FlowViewPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToPosePage(BuildContext context, MediaIconEntity mediaItem) {
    PoseViewSheet.show(
      context: context,
      pose: mediaItem.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flow = widget.flow;

    log("[FlowViewPage] Flow ID: ${flow.id}, Name: ${flow.name}");
    log("[FlowViewPage] Thumbnail: ${flow.primaryMediaPath}");
    log("[FlowViewPage] Pose count: ${flow.flowPoses.length}");

    final poses = (flow.flowPoses).map((fp) => fp.pose).toList();

    log("[FlowViewPage] Pose names: ${poses.map((p) => p.slug).toList()}");
    log("[FlowViewPage] Pose image paths: ${poses.map((p) => p.primaryMediaPath).toList()}");

    final List<MediaIconEntity> mediaIcons = posesToMediaIcons(poses);

    return MainScaffold(
      currentIndex: 1,
      isScrollable: true,
      isScrollToTopVisible: true,
      scrollController: _scrollController,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: Text(flow.name),
        actions: [
          IconButton( // TODO Switch this to a help button
            icon: const Icon(Icons.info_outline),
            tooltip: 'View flow details',
            onPressed: () {
              FlowDetailsSheet.show(
                context: context,
                flow: flow,
                onEdit: () {
                  context.goNamed(
                    'flow-edit-details',
                    pathParameters: {'flowId': flow.id,},
                    queryParameters: {'from': 'flow-view'},
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FlowsCubit, FlowsState>(
        builder: (context, state) {
          if (state is FlowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FlowError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is GetFlowsSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                children: [
                  // ExpandableCard(
                  //   title: "Flow Details",
                  //   initiallyExpanded: false,
                  //   children: [
                  //     InfoRow("Apparatus:", capitalizeFirstLetter(flow.apparatus)),
                  //     InfoRow("Level:", flow.level != -1 ? "Level ${flow.level}" : "None"),
                  //     const Divider(),
                  //     InfoRow("Description:", flow.description),
                  //     InfoRow("Teaching Cues:", flow.teachingCues),
                  //     InfoRow("Safety Cues:", flow.safetyCues),
                  //     InfoRow("Progressions:", flow.progressions),
                  //     const Divider(),
                  //     InfoRow("Created:", formatDate(flow.createdAt)),
                  //     InfoRow("Updated:", formatDate(flow.updatedAt)),
                  //   ],
                  // ),
                  //
                  // const Divider(),

                  // TODO maybe move this to the bottom of the page, but always visible (so hover above) - need to make sure it moves for scroll to top button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            FlowDetailsSheet.show(
                              context: context,
                              flow: flow,
                              onEdit: () {
                                context.goNamed(
                                  'flow-edit-details',
                                  pathParameters: {'flowId': flow.id},
                                  queryParameters: {'from': 'flow-view'},
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text("Details"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.goNamed(
                              'flow-edit-poses',
                              pathParameters: {'flowId': flow.id},
                              queryParameters: {'from': 'flow-view'},
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Poses"),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 10),


                  if (mediaIcons.isEmpty) ...[
                    const Text(
                      "There are no poses in this flow.\n",
                      style: TextStyle(fontSize: 16, color: Colors.black38),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.goNamed(
                          'flow-edit-poses',
                          pathParameters: {'flowId': flow.id,},
                          queryParameters: {'from': 'flow-view'},
                        );
                      },
                      child: const Text("Add poses")
                    )
                  ]
                  else
                    MediaList(
                      mediaItems: mediaIcons,
                      onMediaTap: (item) => _navigateToPosePage(context, item),
                    ),

                  const SizedBox(height: 80), // leave space for FAB
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
























// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:frontend/shared/helpers/conversions.dart';
// import 'package:frontend/core/constants/constants.dart';
//
// import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
// import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';
//
// import 'package:frontend/features/flow/presentation/pages/flow_details_sheet.dart';
// import 'package:frontend/features/pose/presentation/pages/pose_view_sheet.dart';
//
// import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
// import 'package:frontend/shared/widgets/main_scaffold.dart';
// import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
//
//
// class FlowViewPage extends StatefulWidget {
//   final FlowEntity flow;
//
//   const FlowViewPage({super.key, required this.flow});
//
//   @override
//   State<FlowViewPage> createState() => _FlowViewPageState();
// }
//
// class _FlowViewPageState extends State<FlowViewPage> {
//   final ScrollController _scrollController = ScrollController();
//   bool _isVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (_scrollController.offset >= Constants.visibleScrollThreshold && !_isVisible) {
//       setState(() {
//         _isVisible = true;
//       });
//     } else if (_scrollController.offset < Constants.visibleScrollThreshold && _isVisible) {
//       setState(() {
//         _isVisible = false;
//       });
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MainScaffold(
//       isScrollable: false,
//       currentIndex: 1,
//       appBar: AppBar(
//         leading: const SmartBackButton(),
//         title: Text(flow.name),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.info_outline),
//             tooltip: 'View flow details',
//             onPressed: () {
//               FlowDetailsSheet.show(
//                 context: context,
//                 flow: flow,
//                 onEdit: () {
//                   context.goNamed(
//                     'flow-edit-details',
//                     pathParameters: {'flowId': flow.id,},
//                     queryParameters: {'from': 'flow-view'},
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//
//       body: Stack(
//         children: [
//           if (mediaItems.isEmpty)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.only(top: 20),
//                 child: Text( // TODO move this to Media List?
//                   "No poses in this flow, try adding some by clicking edit!",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black38
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             )
//           else
//             MediaList(
//               mediaItems: mediaItems,
//               onMediaTap: (item) => _navigateToPosePage(context, item),
//               scrollController: _scrollController,
//             ),
//
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: FloatingActionButton.extended(
//                     heroTag: 'editFAB',
//                     tooltip: 'Edit poses in this flow',
//                     icon: const Icon(Icons.edit),
//                     label: const Text('Edit Poses'),
//                     onPressed: () {
//                       context.goNamed(
//                         'flow-edit-poses',
//                         pathParameters: {'flowId': flow.id,},
//                         queryParameters: {'from': 'flow-view'},
//                       );
//                     },
//                   ),
//                 ),
//
//                 if (_isVisible) const SizedBox(width: 12),
//
//                 if (_isVisible)
//                   FloatingActionButton(
//                     heroTag: 'scrollTopFAB',
//                     tooltip: 'Scroll to top',
//                     onPressed: () {
//                       _scrollController.animateTo(
//                         0,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );
//                     },
//                     child: const Icon(Icons.keyboard_arrow_up),
//                   ),
//               ],
//             ),
//           ),
//
//
//           // if(!_isVisible)
//           //   Positioned(
//           //     bottom: 20,
//           //     left: 20,
//           //     child: SizedBox(
//           //       width: double.infinity,
//           //       child: FloatingActionButton.extended(
//           //         heroTag: 'editFAB',
//           //         tooltip: 'Add, remove, or reorder poses in this flow',
//           //         icon: const Icon(Icons.edit),
//           //         label: const Text('Edit Poses'),
//           //         onPressed: () {
//           //           Navigator.push(context, FlowEditPosesPage.route(flow));
//           //         },
//           //       ),
//           //     ),
//           //   ),
//
//
//         ],
//       ),
//     // floatingActionButton: Padding(
//     //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//     //   child: SizedBox(
//     //     width: double.infinity, // Full width of the screen
//     //     child: FloatingActionButton.extended(
//     //       heroTag: 'editFAB',
//     //       tooltip: 'Edit Poses in Flow',
//     //       onPressed: () {
//     //         Navigator.push(context, FlowEditPosesPage.route(flow));
//     //       },
//     //       icon: const Icon(Icons.edit),
//     //       label: const Text("Edit"),
//     //     )
//     //   ),
//     // ),
//     // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//
//     );
//   }
// }