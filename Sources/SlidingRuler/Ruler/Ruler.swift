//
//  Ruler.swift
//
//  SlidingRuler
//
//  MIT License
//
//  Copyright (c) 2020 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


import SwiftUI

struct Ruler<V: BinaryFloatingPoint>: View, Equatable {
    @Environment(\.slidingRulerStyle) private var style
    
    let cells: [RulerCell<V>]
    let step: Double
    let markOffset: Double
    let bounds: ClosedRange<V>
    let formatter: NumberFormatter?
    
    var body: some View {
        return HStack(spacing: 0) {
            ForEach(self.cells) { cell in
                self.style.makeCellBody(configuration: self.configuration(forCell: cell))
            }
        }.animation(nil)
    }
    
    private func configuration(forCell cell: RulerCell<V>) -> SlidingRulerStyleConfiguation {
        let range = Double(bounds.lowerBound)...Double(bounds.upperBound)
        return .init(mark: (Double(cell.mark) + markOffset) * step, bounds: range, step: Double(step), formatter: formatter)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.step == rhs.step &&
            lhs.cells.count == rhs.cells.count &&
            (StaticSlideRulerStyleEnvironment.isStatic || lhs.markOffset == rhs.markOffset)
    }
}