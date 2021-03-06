//===--- _fft_zop_imp_2.swift ----------------------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2019 - 2020 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

@inlinable
@inline(__always)
func _fft_zop_imp_2<T: FloatingPoint>(_ in_real: UnsafePointer<T>, _ in_imag: UnsafePointer<T>, _ in_stride: Int, _ out_real: UnsafeMutablePointer<T>, _ out_imag: UnsafeMutablePointer<T>, _ out_stride: Int) {
    
    var in_real = in_real
    var in_imag = in_imag
    var out_real = out_real
    var out_imag = out_imag
    
    let a = in_real.pointee
    let b = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let c = in_real.pointee
    let d = in_imag.pointee
    
    out_real.pointee = a + c
    out_imag.pointee = b + d
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = a - c
    out_imag.pointee = b - d
    
}
