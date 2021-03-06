//===--- FastFourierTests.swift ----------------------------------*- swift -*-===//
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
import CorePerformance
import ComplexModule
import RealModule

func _FDFT<T>(_ input: [T]) -> [Complex<T>] {
    
    let n = input.count
    
    let source = zip(input, Array(repeating: 0, count: n)).map { Complex($0, $1) }
    
    var result = _FDFT(source)
    
    // we only have half length of frequency domain
    result[0] = Complex(result[0].real, result[n/2].real)
    
    result.removeSubrange(n/2..<n)
    
    return result
}

func _FDFT<T>(_ input: [Complex<T>]) -> [Complex<T>] {
    
    let n = input.count
    
    var result: [Complex<T>] = Array(repeating: .zero, count: n)
    
    for i in 0..<n {
        for j in 0..<n {
            let twiddle = Complex(length: 1, phase: -2 * .pi * T(i * j) / T(n))
            result[i] += input[j] * twiddle
        }
    }
    
    return result
}

func _IDFT<T>(_ input: [Complex<T>]) -> [Complex<T>] {
    
    let n = input.count
    
    var result: [Complex<T>] = Array(repeating: .zero, count: n)
    
    for i in 0..<n {
        for j in 0..<n {
            let twiddle = Complex(length: 1, phase: 2 * .pi * T(i * j) / T(n))
            result[i] += input[j] * twiddle
        }
    }
    
    return result
}

final class FastFourierTests: XCTestCase {
    
    let accuracy = 0.00000001
    
    func testFFTZropForward() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            let in_even: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            let in_odd: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            
            var out_real: [Double] = Array(repeating: 0, count: length / 2)
            var out_imag: [Double] = Array(repeating: 0, count: length / 2)
            
            _fft_zrop(log2n, in_even, in_odd, 1, &out_real, &out_imag, 1, .forward)
            
            let check = _FDFT(zip(in_even, in_odd).flatMap { [$0, $1] })
            
            for i in 0..<length / 2 {
                XCTAssertEqual(check[i].real, out_real[i], accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, out_imag[i], accuracy: accuracy)
            }
        }
    }
    
    func testFFTZripForward() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            var real: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            var imag: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            
            let check = _FDFT(zip(real, imag).flatMap { [$0, $1] })
            
            _fft_zrip(log2n, &real, &imag, 1, .forward)
            
            for i in 0..<length / 2 {
                XCTAssertEqual(check[i].real, real[i], accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, imag[i], accuracy: accuracy)
            }
        }
    }
    
    func testFFTZropInverse() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            var real: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            var imag: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            
            let check_even = real
            let check_odd = imag
            
            _fft_zrip(log2n, &real, &imag, 1, .forward)
            
            var out_real: [Double] = Array(repeating: 0, count: length / 2)
            var out_imag: [Double] = Array(repeating: 0, count: length / 2)
            
            _fft_zrop(log2n, real, imag, 1, &out_real, &out_imag, 1, .inverse)
            
            for i in 0..<length / 2 {
                XCTAssertEqual(check_even[i], out_real[i] / Double(length), accuracy: accuracy)
                XCTAssertEqual(check_odd[i], out_imag[i] / Double(length), accuracy: accuracy)
            }
        }
    }
    
    func testFFTZripInverse() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            var real: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            var imag: [Double] = (0..<length / 2).map { _ in Double.random(in: -1...1) }
            
            let check_even = real
            let check_odd = imag
            
            _fft_zrip(log2n, &real, &imag, 1, .forward)
            _fft_zrip(log2n, &real, &imag, 1, .inverse)
            
            for i in 0..<length / 2 {
                XCTAssertEqual(check_even[i], real[i] / Double(length), accuracy: accuracy)
                XCTAssertEqual(check_odd[i], imag[i] / Double(length), accuracy: accuracy)
            }
        }
    }
    
    func testFFTZopForward() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            let in_real: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            let in_imag: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            
            var out_real: [Double] = Array(repeating: 0, count: length)
            var out_imag: [Double] = Array(repeating: 0, count: length)
            
            _fft_zop(log2n, in_real, in_imag, 1, &out_real, &out_imag, 1, .forward)
            
            let check = _FDFT(zip(in_real, in_imag).map { Complex($0, $1) })
            
            for i in 0..<length {
                XCTAssertEqual(check[i].real, out_real[i], accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, out_imag[i], accuracy: accuracy)
            }
        }
    }
    
    func testFFTZopInverse() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            let in_real: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            let in_imag: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            
            var out_real: [Double] = Array(repeating: 0, count: length)
            var out_imag: [Double] = Array(repeating: 0, count: length)
            
            _fft_zop(log2n, in_real, in_imag, 1, &out_real, &out_imag, 1, .inverse)
            
            let check = _IDFT(zip(in_real, in_imag).map { Complex($0, $1) })
            
            for i in 0..<length {
                XCTAssertEqual(check[i].real, out_real[i], accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, out_imag[i], accuracy: accuracy)
            }
        }
    }
    
    func testFFTZipForward() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            var real: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            var imag: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            
            let check = _FDFT(zip(real, imag).map { Complex($0, $1) })
            
            _fft_zip(log2n, &real, &imag, 1, .forward)
            
            for i in 0..<length {
                XCTAssertEqual(check[i].real, real[i], accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, imag[i], accuracy: accuracy)
            }
        }
    }
    
    func testFFTZipInverse() {
        
        for log2n in 1...8 {
            
            let length = 1 << log2n
            
            var real: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            var imag: [Double] = (0..<length).map { _ in Double.random(in: -1...1) }
            
            let check = _IDFT(zip(real, imag).map { Complex($0, $1) })
            
            _fft_zip(log2n, &real, &imag, 1, .inverse)
            
            for i in 0..<length {
                XCTAssertEqual(check[i].real, real[i], accuracy: accuracy)
                XCTAssertEqual(check[i].imaginary, imag[i], accuracy: accuracy)
            }
        }
    }
    
}
