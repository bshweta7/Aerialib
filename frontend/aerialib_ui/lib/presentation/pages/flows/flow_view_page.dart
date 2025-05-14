import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/utils/conversions.dart';
import 'package:frontend/core/constants/constants.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';

import 'package:frontend/presentation/pages/flows/flow_details_sheet.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';
import 'package:frontend/presentation/widgets/navigation/smart_back_button.dart';


class FlowViewPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowViewPage({super.key, required this.flow});

  @override
  State<FlowViewPage> createState() => _FlowViewPageState();
}

class _FlowViewPageState extends State<FlowViewPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >= Constants.visibleScrollThreshold && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
    } else if (_scrollController.offset < Constants.visibleScrollThreshold && _isVisible) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  void _navigateToPosePage(BuildContext context, MediaIconEntity mediaItem) {
    context.goNamed(
      'pose-view',
      pathParameters: {'poseId': mediaItem.data.id},
      queryParameters: {'from': 'flow-view'},
      // TODO may need update if it also needs to pass flow ID to get back
      // TODO should this actually show a bottom modal pop up instead of the full page?
    );
  }

  @override
  Widget build(BuildContext context) {
    final flow = widget.flow;
    print("[FlowViewPage] Flow ID: ${flow.id}, Name: ${flow.name}");
    print("[FlowViewPage] Thumbnail: ${flow.thumbnailImagePath}");
    print("[FlowViewPage] Pose count: ${flow.poses.length}");

    final poses = (flow.poses ?? []).map((fp) => fp.pose).toList();

    print("[FlowViewPage] Pose names: ${poses.map((p) => p.name).toList()}");
    print("[FlowViewPage] Pose image paths: ${poses.map((p) => p.primaryMediaPath).toList()}");

    final mediaItems = posesToMediaIcons(poses);

    return MainScaffold(
      currentIndex: 1,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: Text(flow.name),
        actions: [
          IconButton(
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

      body: Stack(
        children: [
          if (mediaItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text( // TODO move this to Media List?
                  "No poses in this flow, try adding some by clicking edit!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black38),
                ),
              ),
            )
          else
            MediaList(
              mediaItems: mediaItems,
              onMediaTap: (item) => _navigateToPosePage(context, item),
              scrollController: _scrollController,
            ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FloatingActionButton.extended(
                    heroTag: 'editFAB',
                    tooltip: 'Edit poses in this flow',
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Poses'),
                    onPressed: () {
                      context.pushNamed( // TODO URL doesnt update
                        'flow-edit-poses',
                        pathParameters: {
                          'flowId': flow.id,
                        },
                        extra: flow,
                      );
                    },
                  ),
                ),

                if (_isVisible) const SizedBox(width: 12),

                if (_isVisible)
                  FloatingActionButton(
                    heroTag: 'scrollTopFAB',
                    tooltip: 'Scroll to top',
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
              ],
            ),
          ),


          // if(!_isVisible)
          //   Positioned(
          //     bottom: 20,
          //     left: 20,
          //     child: SizedBox(
          //       width: double.infinity,
          //       child: FloatingActionButton.extended(
          //         heroTag: 'editFAB',
          //         tooltip: 'Add, remove, or reorder poses in this flow',
          //         icon: const Icon(Icons.edit),
          //         label: const Text('Edit Poses'),
          //         onPressed: () {
          //           Navigator.push(context, FlowEditPosesPage.route(flow));
          //         },
          //       ),
          //     ),
          //   ),


        ],
      ),
    // floatingActionButton: Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
    //   child: SizedBox(
    //     width: double.infinity, // Full width of the screen
    //     child: FloatingActionButton.extended(
    //       heroTag: 'editFAB',
    //       tooltip: 'Edit Poses in Flow',
    //       onPressed: () {
    //         Navigator.push(context, FlowEditPosesPage.route(flow));
    //       },
    //       icon: const Icon(Icons.edit),
    //       label: const Text("Edit"),
    //     )
    //   ),
    // ),
    // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}