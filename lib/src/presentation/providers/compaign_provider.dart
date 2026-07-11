import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palpa_marketplace/src/core/utils/api_call_status.dart';
import 'package:palpa_marketplace/src/data/models/compaign_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/compaign_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/compaign_repo.dart';

final compaignProvider = StateNotifierProvider<CompaignNotifier, CompaignState>(
  (ref) {
    final repo = ref.read(compaignRepoImplProvider);
    return CompaignNotifier(repo: repo);
  },
);

class CompaignNotifier extends StateNotifier<CompaignState> {
  final CompaignRepo repo;

  CompaignNotifier({required this.repo}) : super(const CompaignState.initial());

  Future<void> getCompaigns() async {
    try {
      state = state.copyWith(apiCallStatus: ApiCallStatus.loading);

      final response = await repo.getCompaigns();

      return response.fold((error) {}, (compaigns) {
        state = state.copyWith(
          apiCallStatus: ApiCallStatus.complete,
          compaignList: compaigns.data,
        );
      });
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }
}

class CompaignState extends Equatable {
  final ApiCallStatus apiCallStatus;
  final String? errorMessage;
  final List<CompaignModel> compaignList;

  const CompaignState({
    required this.apiCallStatus,
    this.errorMessage,
    required this.compaignList,
  });

  const CompaignState.initial()
    : apiCallStatus = ApiCallStatus.initial,
      errorMessage = null,
      compaignList = const [];

  CompaignState copyWith({
    ApiCallStatus? apiCallStatus,
    String? errorMessage,
    List<CompaignModel>? compaignList,
  }) {
    return CompaignState(
      apiCallStatus: apiCallStatus ?? this.apiCallStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      compaignList: compaignList ?? this.compaignList,
    );
  }

  @override
  List<Object?> get props => [apiCallStatus, errorMessage, compaignList];
}
