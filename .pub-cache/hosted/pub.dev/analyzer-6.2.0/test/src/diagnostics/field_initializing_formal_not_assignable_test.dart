// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../generated/test_support.dart';
import '../dart/resolution/context_collection_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(FieldInitializingFormalNotAssignableTest);
  });
}

@reflectiveTest
class FieldInitializingFormalNotAssignableTest
    extends PubPackageResolutionTest {
  test_class_dynamic() async {
    await assertErrorsInCode('''
class A {
  int x;
  A(dynamic this.x) {}
}
''', [
      error(CompileTimeErrorCode.FIELD_INITIALIZING_FORMAL_NOT_ASSIGNABLE, 23,
          14),
    ]);
  }

  test_class_unrelated() async {
    await assertErrorsInCode('''
class A {
  int x;
  A(String this.x) {}
}
''', [
      error(CompileTimeErrorCode.FIELD_INITIALIZING_FORMAL_NOT_ASSIGNABLE, 23,
          13),
    ]);
  }

  test_enum_dynamic() async {
    await assertErrorsInCode('''
enum E {
  v(0);
  final int x;
  const E(dynamic this.x);
}
''', [
      error(CompileTimeErrorCode.FIELD_INITIALIZING_FORMAL_NOT_ASSIGNABLE, 42,
          14),
    ]);
  }

  test_enum_unrelated() async {
    await assertErrorsInCode('''
enum E {
  v('');
  final int x;
  const E(String this.x);
}
''', [
      error(
        CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION,
        11,
        5,
        contextMessages: [
          ExpectedContextMessage(testFile.path, 13, 2,
              text:
                  "The exception is 'A value of type 'String' can't be assigned to a parameter of type 'int' in a const constructor.' and occurs here."),
        ],
      ),
      error(CompileTimeErrorCode.FIELD_INITIALIZING_FORMAL_NOT_ASSIGNABLE, 43,
          13),
    ]);
  }
}
