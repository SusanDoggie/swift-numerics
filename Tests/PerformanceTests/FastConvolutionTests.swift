//===--- FastConvolutionTests.swift ----------------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2019 - 2020 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import XCTest
import Performance
import ComplexModule
import RealModule

/// return positive mod
func positive_mod<T: BinaryInteger>(_ x: T, _ m: T) -> T {
    let r = x % m
    return r < 0 ? r + m : r
}

func _cyclic_conv(_ signal: [Double], _ kernel: [Double]) -> [Double] {
    
    var result: [Double] = Array(repeating: 0, count: signal.count)
    
    for i in 0..<signal.count {
        
        var sum = 0.0
        
        for j in 0..<kernel.count {
            let k = positive_mod(i - j, signal.count)
            sum += kernel[j] * signal[k]
        }
        
        result[i] = sum
    }
    
    return result
}

func _cyclic_conv<T>(_ signal: [Complex<T>], _ kernel: [Complex<T>]) -> [Complex<T>] {
    
    var result: [Complex<T>] = Array(repeating: 0, count: signal.count)
    
    for i in 0..<signal.count {
        
        var sum: Complex<T> = 0
        
        for j in 0..<kernel.count {
            let k = positive_mod(i - j, signal.count)
            sum += kernel[j] * signal[k]
        }
        
        result[i] = sum
    }
    
    return result
}

final class FastConvolutionTests: XCTestCase {
    
    let accuracy = 0.00000001
    
    func testTypedFFTConv() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            let signal = (0..<length).map { _ in Double.random(in: -1...1) }
            let kernel = (0..<length).map { _ in Double.random(in: -1...1) }
            
            let output = FastFourier.convolve(signal, withKernel: kernel)
            
            let check = _cyclic_conv(signal, kernel)
            
            for i in 0..<output.count {
                XCTAssertEqual(check[i], output[i], accuracy: accuracy)
            }
        }
    }
    
    func testTypedFFTConvComplex() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            let signal = (0..<length).map { _ in Complex(Double.random(in: -1...1), Double.random(in: -1...1)) }
            let kernel = (0..<length).map { _ in Complex(Double.random(in: -1...1), Double.random(in: -1...1)) }
            
            let output = FastFourier.convolve(signal, withKernel: kernel)
            
            let check = _cyclic_conv(signal, kernel)
            
            for i in 0..<output.count {
                XCTAssertEqual(check[i].real, output[i].real, accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, output[i].imaginary, accuracy: accuracy)
            }
        }
    }
}
