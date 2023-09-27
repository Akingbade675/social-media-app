part of 'message_cubit.dart';

sealed class MessageState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class MessageInitial extends MessageState {
  final List<Chat> chats;
  final int unread;

  MessageInitial({this.unread = 0, this.chats = const []});

  MessageInitial copyWith({List<Chat>? chats, int? unread}) {
    return MessageInitial(
      chats: chats ?? this.chats,
      unread: unread ?? this.unread,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chats': chats.map((chat) => chat.toJson()).toList(),
      'unread': unread,
    };
  }

  factory MessageInitial.fromJson(Map<String, dynamic> map) {
    return MessageInitial(
      chats: List<Chat>.from(map['chats']?.map((x) => Chat.fromJson(x))),
      unread: map['unread'],
    );
  }

  @override
  List<Object?> get props => [chats, unread];
}

final class MessageLoading extends MessageState {}

final class MessageSent extends MessageState {}

final class MessageFailure extends MessageState {
  final String error;

  MessageFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
