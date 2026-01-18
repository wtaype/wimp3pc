import 'package:flutter_test/flutter_test.dart';
import 'package:wimp3/main.dart';

void main() {
  testWidgets('WIMP3 app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WiMP3App());

    // Verify that WIMP3 title is present
    expect(find.text('Conversor de Video a MP3'), findsOneWidget);
    
    // Verify that the "Select Video" button exists
    expect(find.text('Seleccionar Video'), findsOneWidget);
  });
}