import 'package:btox/btox_state.dart';
import 'package:btox/btox_actions.dart';
import 'package:redux/redux.dart';

final btoxReducer = combineReducers<BtoxState>([
  TypedReducer<BtoxState, BtoxUpdateNicknameAction>(_updateNickname).call,
  TypedReducer<BtoxState, BtoxUpdateStatusMessageAction>(_updateStatusMessage)
      .call,
]);

BtoxState _updateNickname(BtoxState state, BtoxUpdateNicknameAction action) {
  return state.copyWith(nickname: action.nickname);
}

BtoxState _updateStatusMessage(
    BtoxState state, BtoxUpdateStatusMessageAction action) {
  return state.copyWith(statusMessage: action.statusMessage);
}
