//
//  SizePublisher.swift
//  
//
//  Created by Boris Gutic on 07.04.22.
//

import SwiftUI

public struct SizePublisher: View {
    private let coordinateSpace: CoordinateSpace
    
    public init(coordinateSpace: CoordinateSpace = .global) {
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: SizePreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).size
                )
        }
    }
}

public extension View {
    func publishSize(to frame: Binding<CGSize>) -> some View {
        self
            .background(SizePublisher(coordinateSpace: .global))
            .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                frame.wrappedValue = value
            })
    }
}

struct SizePublisher_Previews: PreviewProvider {
    private struct TestView: View {
        @State private var size1: CGSize = .zero
        @State private var size2: CGSize = .zero
        
        private func sizeString(from size: CGSize) -> String {
            String(format: "w: %.2f, h: %.2f",
                   size.width,
                   size.height)
        }
        
        var body: some View {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(sizeString(from: size1))
                        .font(.footnote.bold())
                        .padding(4)
                        .background(Color.yellow.opacity(0.2))
                    Text("Hello, World!")
                        .font(.title)
                        .publishSize(to: $size1)
                }
                
                VStack(spacing: 8) {
                    Text(sizeString(from: size2))
                        .font(.footnote.bold())
                        .padding(4)
                        .background(Color.yellow.opacity(0.2))
                    Text("Hello, World!")
                        .font(.caption)
                        .publishSize(to: $size2)
                }
            }
        }
    }
    
    static var previews: some View {
        TestView()
    }
}
