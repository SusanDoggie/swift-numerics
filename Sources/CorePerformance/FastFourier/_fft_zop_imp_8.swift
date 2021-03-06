//===--- _fft_zop_imp_8.swift ----------------------------------------*- swift -*-===//
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
func _fft_zop_imp_8<T: BinaryFloatingPoint>(_ in_real: UnsafePointer<T>, _ in_imag: UnsafePointer<T>, _ in_stride: Int, _ out_real: UnsafeMutablePointer<T>, _ out_imag: UnsafeMutablePointer<T>, _ out_stride: Int) {
    
    var in_real = in_real
    var in_imag = in_imag
    var out_real = out_real
    var out_imag = out_imag
    
    let a1 = in_real.pointee
    let a2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let e1 = in_real.pointee
    let e2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let c1 = in_real.pointee
    let c2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let g1 = in_real.pointee
    let g2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let b1 = in_real.pointee
    let b2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let f1 = in_real.pointee
    let f2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let d1 = in_real.pointee
    let d2 = in_imag.pointee
    in_real += in_stride
    in_imag += in_stride
    
    let h1 = in_real.pointee
    let h2 = in_imag.pointee
    
    let a3 = a1 + b1
    let a4 = a2 + b2
    let b3 = a1 - b1
    let b4 = a2 - b2
    let c3 = c1 + d1
    let c4 = c2 + d2
    let d3 = c1 - d1
    let d4 = c2 - d2
    let e3 = e1 + f1
    let e4 = e2 + f2
    let f3 = e1 - f1
    let f4 = e2 - f2
    let g3 = g1 + h1
    let g4 = g2 + h2
    let h3 = g1 - h1
    let h4 = g2 - h2
    
    let a5 = a3 + c3
    let a6 = a4 + c4
    let b5 = b3 + d4
    let b6 = b4 - d3
    let c5 = a3 - c3
    let c6 = a4 - c4
    let d5 = b3 - d4
    let d6 = b4 + d3
    let e5 = e3 + g3
    let e6 = e4 + g4
    let f5 = f3 + h4
    let f6 = f4 - h3
    let g5 = e3 - g3
    let g6 = e4 - g4
    let h5 = f3 - h4
    let h6 = f4 + h3
    
    let M_SQRT1_2 = 0.7071067811865475244008443621048490392848359376884740 as T
    
    let i = M_SQRT1_2 * (f5 + f6)
    let j = M_SQRT1_2 * (f6 - f5)
    let k = M_SQRT1_2 * (h5 - h6)
    let l = M_SQRT1_2 * (h6 + h5)
    
    out_real.pointee = a5 + e5
    out_imag.pointee = a6 + e6
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = b5 + i
    out_imag.pointee = b6 + j
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = c5 + g6
    out_imag.pointee = c6 - g5
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = d5 - k
    out_imag.pointee = d6 - l
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = a5 - e5
    out_imag.pointee = a6 - e6
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = b5 - i
    out_imag.pointee = b6 - j
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = c5 - g6
    out_imag.pointee = c6 + g5
    out_real += out_stride
    out_imag += out_stride
    
    out_real.pointee = d5 + k
    out_imag.pointee = d6 + l
}

@inlinable
@inline(__always)
func _fft_zop_reordered_imp_8<T: BinaryFloatingPoint>(_ real: UnsafeMutablePointer<T>, _ imag: UnsafeMutablePointer<T>, _ stride: Int) {
    
    var in_real = real
    var in_imag = imag
    var out_real = real
    var out_imag = imag
    
    let a1 = in_real.pointee
    let a2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let b1 = in_real.pointee
    let b2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let c1 = in_real.pointee
    let c2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let d1 = in_real.pointee
    let d2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let e1 = in_real.pointee
    let e2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let f1 = in_real.pointee
    let f2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let g1 = in_real.pointee
    let g2 = in_imag.pointee
    in_real += stride
    in_imag += stride
    
    let h1 = in_real.pointee
    let h2 = in_imag.pointee
    
    let a3 = a1 + b1
    let a4 = a2 + b2
    let b3 = a1 - b1
    let b4 = a2 - b2
    let c3 = c1 + d1
    let c4 = c2 + d2
    let d3 = c1 - d1
    let d4 = c2 - d2
    let e3 = e1 + f1
    let e4 = e2 + f2
    let f3 = e1 - f1
    let f4 = e2 - f2
    let g3 = g1 + h1
    let g4 = g2 + h2
    let h3 = g1 - h1
    let h4 = g2 - h2
    
    let a5 = a3 + c3
    let a6 = a4 + c4
    let b5 = b3 + d4
    let b6 = b4 - d3
    let c5 = a3 - c3
    let c6 = a4 - c4
    let d5 = b3 - d4
    let d6 = b4 + d3
    let e5 = e3 + g3
    let e6 = e4 + g4
    let f5 = f3 + h4
    let f6 = f4 - h3
    let g5 = e3 - g3
    let g6 = e4 - g4
    let h5 = f3 - h4
    let h6 = f4 + h3
    
    let M_SQRT1_2 = 0.7071067811865475244008443621048490392848359376884740 as T
    
    let i = M_SQRT1_2 * (f5 + f6)
    let j = M_SQRT1_2 * (f6 - f5)
    let k = M_SQRT1_2 * (h5 - h6)
    let l = M_SQRT1_2 * (h6 + h5)
    
    out_real.pointee = a5 + e5
    out_imag.pointee = a6 + e6
    out_real += stride
    out_imag += stride
    
    out_real.pointee = b5 + i
    out_imag.pointee = b6 + j
    out_real += stride
    out_imag += stride
    
    out_real.pointee = c5 + g6
    out_imag.pointee = c6 - g5
    out_real += stride
    out_imag += stride
    
    out_real.pointee = d5 - k
    out_imag.pointee = d6 - l
    out_real += stride
    out_imag += stride
    
    out_real.pointee = a5 - e5
    out_imag.pointee = a6 - e6
    out_real += stride
    out_imag += stride
    
    out_real.pointee = b5 - i
    out_imag.pointee = b6 - j
    out_real += stride
    out_imag += stride
    
    out_real.pointee = c5 - g6
    out_imag.pointee = c6 + g5
    out_real += stride
    out_imag += stride
    
    out_real.pointee = d5 + k
    out_imag.pointee = d6 + l
}
