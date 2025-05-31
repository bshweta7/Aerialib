import 'package:go_router/go_router.dart';

import 'package:frontend/features/media/presentation/pages/media_gallery_page.dart';
import 'package:frontend/features/media/presentation/pages/upload_new_media_page.dart';


List<GoRoute> mediaRoutes = [
  // Media Gallery Page
  GoRoute(
    path: '/gallery',
    name: 'media-gallery',
    builder: (context, state) => const MediaGalleryPage(),
  ),

  // Upload New Media Page
  GoRoute(
    path: '/gallery/upload',
    name: 'add-new-media',
    builder: (context, state) => const UploadNewMediaPage(),
  ),
];