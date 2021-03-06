// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// @dart=2.9
import 'dart:async';

class Class {}

dynamic returnDynamic() => new Class();

Class returnClass() async => new Class();

Future<Class> returnFutureClass() async => new Class();

FutureOr<Class> returnFutureOrClass() async => new Class();

Class returnClassFromDynamic() async => returnDynamic();

Future<Class> returnFutureClassDynamic() async => returnDynamic();

FutureOr<Class> returnFutureOrClassDynamic() async => returnDynamic();

Class returnClassFromFutureClass() async => returnFutureClass();

Future<Class> returnFutureClassFromFutureClass() async => returnFutureClass();

FutureOr<Class> returnFutureOrClassFromFutureClass() async =>
    returnFutureClass();

Class returnClassFromFutureOrClass() async => returnFutureOrClass();

Future<Class> returnFutureClassFromFutureOrClass() async =>
    returnFutureOrClass();

FutureOr<Class> returnFutureOrClassFromFutureOrClass() async =>
    returnFutureOrClass();

main() async {
  await returnClass();
  await returnFutureClass();
  await returnFutureOrClass();
  await returnClassFromDynamic();
  await returnFutureClassDynamic();
  await returnFutureOrClassDynamic();
  await returnClassFromFutureClass();
  await returnFutureClassFromFutureClass();
  await returnFutureOrClassFromFutureClass();
  await returnClassFromFutureOrClass();
  await returnFutureClassFromFutureOrClass();
  await returnFutureOrClassFromFutureOrClass();
}
