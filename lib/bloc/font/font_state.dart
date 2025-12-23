import 'package:equatable/equatable.dart';

class FontState extends Equatable {
  final double fontScale;
  final String fontFamily;

  const FontState({required this.fontFamily, required this.fontScale});

  @override
  List<Object?> get props => [fontScale, fontFamily];
  FontState copyWith({double? fontScale, String? fontFamily}) {
    return FontState(
      fontFamily: fontFamily ?? this.fontFamily,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}
