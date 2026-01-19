// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameState {

 GameConfig get config; Board get board; Player get currentPlayer; GameStatus get status; PlayerInfo get playerXInfo; PlayerInfo get playerOInfo; Player? get winner; List<int> get winningLine;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.config, config) || other.config == config)&&(identical(other.board, board) || other.board == board)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.status, status) || other.status == status)&&(identical(other.playerXInfo, playerXInfo) || other.playerXInfo == playerXInfo)&&(identical(other.playerOInfo, playerOInfo) || other.playerOInfo == playerOInfo)&&(identical(other.winner, winner) || other.winner == winner)&&const DeepCollectionEquality().equals(other.winningLine, winningLine));
}


@override
int get hashCode => Object.hash(runtimeType,config,board,currentPlayer,status,playerXInfo,playerOInfo,winner,const DeepCollectionEquality().hash(winningLine));

@override
String toString() {
  return 'GameState(config: $config, board: $board, currentPlayer: $currentPlayer, status: $status, playerXInfo: $playerXInfo, playerOInfo: $playerOInfo, winner: $winner, winningLine: $winningLine)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 GameConfig config, Board board, Player currentPlayer, GameStatus status, PlayerInfo playerXInfo, PlayerInfo playerOInfo, Player? winner, List<int> winningLine
});




}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? config = null,Object? board = null,Object? currentPlayer = null,Object? status = null,Object? playerXInfo = null,Object? playerOInfo = null,Object? winner = freezed,Object? winningLine = null,}) {
  return _then(_self.copyWith(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board,currentPlayer: null == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as Player,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,playerXInfo: null == playerXInfo ? _self.playerXInfo : playerXInfo // ignore: cast_nullable_to_non_nullable
as PlayerInfo,playerOInfo: null == playerOInfo ? _self.playerOInfo : playerOInfo // ignore: cast_nullable_to_non_nullable
as PlayerInfo,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as Player?,winningLine: null == winningLine ? _self.winningLine : winningLine // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameConfig config,  Board board,  Player currentPlayer,  GameStatus status,  PlayerInfo playerXInfo,  PlayerInfo playerOInfo,  Player? winner,  List<int> winningLine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.config,_that.board,_that.currentPlayer,_that.status,_that.playerXInfo,_that.playerOInfo,_that.winner,_that.winningLine);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameConfig config,  Board board,  Player currentPlayer,  GameStatus status,  PlayerInfo playerXInfo,  PlayerInfo playerOInfo,  Player? winner,  List<int> winningLine)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.config,_that.board,_that.currentPlayer,_that.status,_that.playerXInfo,_that.playerOInfo,_that.winner,_that.winningLine);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameConfig config,  Board board,  Player currentPlayer,  GameStatus status,  PlayerInfo playerXInfo,  PlayerInfo playerOInfo,  Player? winner,  List<int> winningLine)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.config,_that.board,_that.currentPlayer,_that.status,_that.playerXInfo,_that.playerOInfo,_that.winner,_that.winningLine);case _:
  return null;

}
}

}

/// @nodoc


class _GameState extends GameState {
  const _GameState({required this.config, required this.board, required this.currentPlayer, required this.status, required this.playerXInfo, required this.playerOInfo, this.winner, final  List<int> winningLine = const <int>[]}): _winningLine = winningLine,super._();
  

@override final  GameConfig config;
@override final  Board board;
@override final  Player currentPlayer;
@override final  GameStatus status;
@override final  PlayerInfo playerXInfo;
@override final  PlayerInfo playerOInfo;
@override final  Player? winner;
 final  List<int> _winningLine;
@override@JsonKey() List<int> get winningLine {
  if (_winningLine is EqualUnmodifiableListView) return _winningLine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_winningLine);
}


/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.config, config) || other.config == config)&&(identical(other.board, board) || other.board == board)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.status, status) || other.status == status)&&(identical(other.playerXInfo, playerXInfo) || other.playerXInfo == playerXInfo)&&(identical(other.playerOInfo, playerOInfo) || other.playerOInfo == playerOInfo)&&(identical(other.winner, winner) || other.winner == winner)&&const DeepCollectionEquality().equals(other._winningLine, _winningLine));
}


@override
int get hashCode => Object.hash(runtimeType,config,board,currentPlayer,status,playerXInfo,playerOInfo,winner,const DeepCollectionEquality().hash(_winningLine));

@override
String toString() {
  return 'GameState(config: $config, board: $board, currentPlayer: $currentPlayer, status: $status, playerXInfo: $playerXInfo, playerOInfo: $playerOInfo, winner: $winner, winningLine: $winningLine)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 GameConfig config, Board board, Player currentPlayer, GameStatus status, PlayerInfo playerXInfo, PlayerInfo playerOInfo, Player? winner, List<int> winningLine
});




}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? board = null,Object? currentPlayer = null,Object? status = null,Object? playerXInfo = null,Object? playerOInfo = null,Object? winner = freezed,Object? winningLine = null,}) {
  return _then(_GameState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board,currentPlayer: null == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as Player,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,playerXInfo: null == playerXInfo ? _self.playerXInfo : playerXInfo // ignore: cast_nullable_to_non_nullable
as PlayerInfo,playerOInfo: null == playerOInfo ? _self.playerOInfo : playerOInfo // ignore: cast_nullable_to_non_nullable
as PlayerInfo,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as Player?,winningLine: null == winningLine ? _self._winningLine : winningLine // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
