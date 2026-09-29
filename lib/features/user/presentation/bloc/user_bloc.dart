import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/user_failure.dart';
import '../../domain/usecase/get_user_use_case.dart';
import 'user_event.dart';
import 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;

  UserBloc(this.getUserUseCase) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await getUserUseCase(event.userId);
      emit(UserLoaded(user));
    } on UserFailure catch (e) {
      emit(
        UserError(switch (e.type) {
          UserFailureType.notFound => 'User not found.',
          UserFailureType.unavailable =>
            'Unable to load user. Please try again.',
        }),
      );
    } catch (e) {
      emit(UserError('Failed to load user. Please try again.'));
    }
  }
}
