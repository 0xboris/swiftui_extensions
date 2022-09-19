//
//  File.swift
//  
//
//  Created by Boris Gutic on 19.04.22.
//

import SwiftUI

@available(iOS 14.0, watchOS 7.0, *)
public extension View {
    func validateDecimal(_ value: Binding<String>, assignTo decimalValue: Binding<Double>) -> some View {
        onChange(of: value.wrappedValue) { newValue in
            let decimalSeparator = Character(Locale.current.decimalSeparator ?? ".")
            if newValue.filter({ $0 == decimalSeparator }).count > 1,
               let firstComma = newValue.firstIndex(of: decimalSeparator) {
                value.wrappedValue = newValue.replacingOccurrences(
                    of: String(decimalSeparator),
                    with: "",
                    range: newValue.index(after: firstComma)..<newValue.endIndex
                )
            }
            if let number = NumberFormatter().number(from: value.wrappedValue) {
                decimalValue.wrappedValue = number.doubleValue
            }
        }
    }
    
    func validateDecimal(_ value: Binding<String>) -> some View {
        validateDecimal(value, assignTo: .constant(0))
    }
}
