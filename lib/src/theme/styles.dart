// CustomTextField

part of employ.ui;

class STYLES {
  static TextStyle inputLabel = FONT.REGULAR.merge(
    TextStyle(
      color: COLOR.black_five,
      fontSize: 11.0,
    ),
  );
  static TextStyle inputText = FONT.REGULAR.merge(
    TextStyle(
      color: COLOR.black_five,
      fontSize: 14.0,
    ),
  );
  static InputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: COLOR.black_five,
    ),
  );

  static LinearGradient hGradient(
          {String theme = 'default', List<Color>? colors}) =>
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.1, 1.0],
        colors: colors ?? COLOR.gradient[theme]!,
      );

  static LinearGradient bhGradient(
          {String theme = 'default', List<Color>? colors}) =>
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.0, 1.0],
        colors: colors ?? COLOR.gradient[theme]!,
      );

  static LinearGradient dGradient(
          {String theme = 'default', List<Color>? colors}) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0],
        colors: colors ?? COLOR.gradient[theme]!,
      );

  static LinearGradient dlGradient(
          {String theme = 'default', List<Color>? colors}) =>
      LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.0, 1.0],
        colors: colors ?? COLOR.gradient[theme]!,
      );

  static LinearGradient vGradient(
          {String theme = 'default', List<Color>? colors}) =>
      LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1.0],
        colors: colors ?? COLOR.gradient[theme]!.reversed.toList(),
      );
}
