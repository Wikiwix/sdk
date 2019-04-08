// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#define RUNTIME_VM_CONSTANTS_H_  // To work around include guard.
#include "vm/constants_x64.h"

namespace arch_x64 {

#if defined(_WIN64)
const Register CallingConventions::ArgumentRegisters[] = {
    CallingConventions::kArg1Reg, CallingConventions::kArg2Reg,
    CallingConventions::kArg3Reg, CallingConventions::kArg4Reg};

const XmmRegister CallingConventions::FpuArgumentRegisters[] = {
    XmmRegister::XMM0, XmmRegister::XMM1, XmmRegister::XMM2, XmmRegister::XMM3};
#else
const Register CallingConventions::ArgumentRegisters[] = {
    CallingConventions::kArg1Reg, CallingConventions::kArg2Reg,
    CallingConventions::kArg3Reg, CallingConventions::kArg4Reg,
    CallingConventions::kArg5Reg, CallingConventions::kArg6Reg};

const XmmRegister CallingConventions::FpuArgumentRegisters[] = {
    XmmRegister::XMM0, XmmRegister::XMM1, XmmRegister::XMM2, XmmRegister::XMM3,
    XmmRegister::XMM4, XmmRegister::XMM5, XmmRegister::XMM6, XmmRegister::XMM7};
#endif

}  // namespace arch_x64
