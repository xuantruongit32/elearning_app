import 'package:equatable/equatable.dart';

abstract class FontEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateFontScale extends FontEvent {
  final double scale;

  UpdateFontScale(this.scale);

  @override
  List<Object?> get props => [scale];
}

class UpdateFontFamily extends FontEvent {
  final String family;

  UpdateFontFamily(this.family);

  @override
  List<Object?> get props => [family];
}
