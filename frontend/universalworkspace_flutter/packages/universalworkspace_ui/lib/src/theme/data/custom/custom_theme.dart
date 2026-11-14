import 'package:universalworkspace_ui/universalworkspace_ui.dart';

class CustomTheme implements UniversalWorkspaceThemeBuilder {
  const CustomTheme({
    required this.lightThemeJson,
    required this.darkThemeJson,
  });

  final Map<String, dynamic> lightThemeJson;
  final Map<String, dynamic> darkThemeJson;

  @override
  UniversalWorkspaceThemeData light({
    String? fontFamily,
  }) {
    throw UnimplementedError();
  }

  @override
  UniversalWorkspaceThemeData dark({
    String? fontFamily,
  }) {
    throw UnimplementedError();
  }
}
