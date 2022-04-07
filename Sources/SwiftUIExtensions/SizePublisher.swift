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

public struct SizesPublisher: View {
    private let coordinateSpace: CoordinateSpace
    
    public init(coordinateSpace: CoordinateSpace = .global) {
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: SizesPreferenceKey.self,
                    value: [geometry.frame(in: coordinateSpace).size]
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
    
    func publishSizes(to frame: Binding<[CGSize]>) -> some View {
        self
            .background(SizesPublisher(coordinateSpace: .global))
            .onPreferenceChange(SizesPreferenceKey.self, perform: { value in
                frame.wrappedValue = value
            })
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct SizePublisher_Previews: PreviewProvider {
    private struct TestView: View {
        @State private var size1: CGSize = .zero
        @State private var size2: CGSize = .zero
        @State private var size3: CGSize = .zero
        @State private var size4: CGSize = .zero
        @State private var sizes: [CGSize] = []
        
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
                
                VStack(spacing: 8) {
                    Text(sizeString(from: size3))
                        .font(.footnote.bold())
                        .padding(4)
                        .background(Color.yellow.opacity(0.2))
                    
                    HStack(spacing: 0) {
                        Text("Hello, World!")
                            .font(.title)
                            
                        Text("Hello, World!")
                            .font(.caption)
                    }
                    .publishSize(to: $size3)
                }
                VStack(spacing: 8) {
                    Text("frames = \(sizes.map({ $0.debugDescription }).joined(separator: ", "))")
                        .font(.footnote.bold())
                        .padding(4)
                        .background(Color.yellow.opacity(0.2))
                    WeekDayLabels()
                        .publishSizes(to: $sizes)
                }
            }
        }
    }
    
    static var previews: some View {
        TestView()
    }
}

fileprivate struct WeekDayLabels: View {
    private let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(weekDays, id: \.self) { weekday in
                Text(weekday)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
