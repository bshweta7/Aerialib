/* Remote Api Services
Description: Handles remote data access, usually via HTTP calls to your backend/PostgreSQL APIs.
What goes here:
  All http.get, http.post, etc.
  Authentication headers using SpService
  Token refresh logic if needed
Your PoseRepository might call remoteApiService.getAllPoses() when syncing or refreshing.
*/

// TODO - Example stub:
//
// class RemoteApiService {
//   final client = http.Client();
//
//   Future<List<Pose>> fetchPoses() async {
//     final token = await SpService().getToken();
//     final res = await client.get(
//       Uri.parse('https://yourapi.com/poses'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     // Parse response
//   }
// }