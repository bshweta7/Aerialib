import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/cubit/poses/poses_cubit.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/repositories/pose/pose_repository.dart';

class MockPoseRepository extends Mock implements PoseRepository {}

void main() {
  late PosesCubit posesCubit;
  late MockPoseRepository mockPoseRepo;

  setUp(() {
    mockPoseRepo = MockPoseRepository();
    posesCubit = PosesCubit(poseRepo: mockPoseRepo);
  });

  tearDown(() {
    posesCubit.close();
  });

  const testToken = "test-token";

  final testPose = PoseModel(
    id: "pose-id",
    name: "Test Pose",
    description: "desc",
    cues: "breathe",
    apparatus: "mat",
    level: 1,
    primaryImageId: "img123",
    createdBy: "user",
    createdAt: DateTime.parse("2024-01-01T00:00:00Z"),
    updatedAt: DateTime.parse("2024-01-01T00:00:00Z"),
    isSynced: 1,
    primaryImageUrl: '',
  );

  group("createNewPose", () {
    blocTest<PosesCubit, PosesState>(
      'emits [PoseLoading, AddNewPoseSuccess] on success',
      build: () {
        when(() => mockPoseRepo.createPose(
          name: any(named: "name"),
          description: any(named: "description"),
          cues: any(named: "cues"),
          apparatus: any(named: "apparatus"),
          level: any(named: "level"),
          primaryImageId: any(named: "primaryImageId"),
          token: any(named: "token"),
          createdBy: any(named: "createdBy"),
        )).thenAnswer((_) async => testPose);
        return posesCubit;
      },
      act: (cubit) => cubit.createNewPose(
        name: "Test Pose",
        description: "desc",
        cues: "breathe",
        apparatus: "mat",
        level: 1,
        primaryImageId: "img123",
        token: testToken,
        createdBy: "user",
      ),
      expect: () => [PoseLoading(), AddNewPoseSuccess(testPose)],
    );
  });

  group("getAllPoses", () {
    blocTest<PosesCubit, PosesState>(
      'emits [PoseLoading, GetPosesSuccess] on success with local poses',
      build: () {
        when(() => mockPoseRepo.getLocalPoses())
            .thenAnswer((_) async => [testPose]);
        return posesCubit;
      },
      act: (cubit) => cubit.getAllPoses(token: testToken),
      expect: () => [PoseLoading(), GetPosesSuccess([testPose])],
    );

    blocTest<PosesCubit, PosesState>(
      'emits [PoseLoading, GetPosesSuccess] after syncing from remote',
      build: () {
        when(() => mockPoseRepo.getLocalPoses()).thenAnswer((_) async => []);
        when(() => mockPoseRepo.syncRemoteToLocal(testToken)).thenAnswer((_) async {});
        when(() => mockPoseRepo.getLocalPoses()).thenAnswer((_) async => [testPose]);
        return posesCubit;
      },
      act: (cubit) => cubit.getAllPoses(token: testToken),
      expect: () => [PoseLoading(), GetPosesSuccess([testPose])],
    );
  });

  group("updatePoseInfo", () {
    blocTest<PosesCubit, PosesState>(
      'emits [PoseLoading, UpdatePoseSuccess] on success',
      build: () {
        when(() => mockPoseRepo.updatePose(
          updatedPose: any(named: "updatedPose"),
          token: any(named: "token"),
        )).thenAnswer((_) async => testPose);
        return posesCubit;
      },
      act: (cubit) => cubit.updatePoseInfo(
        updatedPose: testPose,
        token: testToken,
      ),
      expect: () => [PoseLoading(), UpdatePoseSuccess(testPose)],
    );
  });

  group("syncPoses", () {
    blocTest<PosesCubit, PosesState>(
      'calls repo.syncLocalToRemote and syncRemoteToLocal but does not emit state',
      build: () {
        when(() => mockPoseRepo.syncLocalToRemote(testToken))
            .thenAnswer((_) async {});
        when(() => mockPoseRepo.syncRemoteToLocal(testToken))
            .thenAnswer((_) async {});
        return posesCubit;
      },
      act: (cubit) => cubit.syncPoses(testToken),
      expect: () => [],
      verify: (_) {
        verify(() => mockPoseRepo.syncLocalToRemote(testToken)).called(1);
        verify(() => mockPoseRepo.syncRemoteToLocal(testToken)).called(1);
      },
    );
  });
}
