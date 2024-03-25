import 'package:flutter_test/flutter_test.dart';
import 'package:verzo/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AddPurchaseViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
