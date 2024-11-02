final class BtoxState {
  final String nickname;
  final String statusMessage;

  const BtoxState({
    required this.nickname,
    required this.statusMessage,
  });

  const BtoxState.initial()
      : nickname = 'Yanciman',
        statusMessage = 'Producing works of art in Kannywood';

  BtoxState copyWith({
    String? nickname,
    String? statusMessage,
  }) {
    return BtoxState(
      nickname: nickname ?? this.nickname,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
