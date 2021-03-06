// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// @dart=2.9
extension Extension<T> on int {
  int get duplicateInstanceGetter => 0;
  int get duplicateInstanceGetter => 0;

  void set duplicateInstanceSetter(int value) {}
  void set duplicateInstanceSetter(int value) {}

  void duplicateInstanceMethod() {}
  void duplicateInstanceMethod() {}

  static int duplicateStaticField = 0;
  static int duplicateStaticField = 0;

  static int get duplicateStaticGetter => 0;
  static int get duplicateStaticGetter => 0;

  static void set duplicateStaticSetter(int value) {}
  static void set duplicateStaticSetter(int value) {}

  static void duplicateStaticMethod() {}
  static void duplicateStaticMethod() {}

  int get duplicateInstanceGetterPlusSetter => 0;
  int get duplicateInstanceGetterPlusSetter => 0;
  void set duplicateInstanceGetterPlusSetter(int value) {}

  int get duplicateInstanceSetterPlusGetter => 0;
  void set duplicateInstanceSetterPlusGetter(int value) {}
  void set duplicateInstanceSetterPlusGetter(int value) {}

  int get duplicateInstanceGetterAndSetter => 0;
  int get duplicateInstanceGetterAndSetter => 0;
  void set duplicateInstanceGetterAndSetter(int value) {}
  void set duplicateInstanceGetterAndSetter(int value) {}

  static int get duplicateStaticGetterPlusSetter => 0;
  static int get duplicateStaticGetterPlusSetter => 0;
  static void set duplicateStaticGetterPlusSetter(int value) {}

  static int get duplicateStaticSetterPlusGetter => 0;
  static void set duplicateStaticSetterPlusGetter(int value) {}
  static void set duplicateStaticSetterPlusGetter(int value) {}

  static int get duplicateStaticGetterAndSetter => 0;
  static int get duplicateStaticGetterAndSetter => 0;
  static void set duplicateStaticGetterAndSetter(int value) {}
  static void set duplicateStaticGetterAndSetter(int value) {}

  int get instanceGetterAndStaticSetter => 0;
  static void set instanceGetterAndStaticSetter(int value) {}

  static int get instanceSetterAndStaticGetter => 0;
  void set instanceSetterAndStaticGetter(int value) {}

  int get instanceGetterAndStaticField => 0;
  static int instanceGetterAndStaticField = 0;

  void set instanceSetterAndStaticField(int value) {}
  static final int instanceGetterAndStaticField = 0;
}

main() {}
