//
//  OriginsPublisher.swift
//  
//
//  Created by Boris Gutic on 12.04.22.
//

import SwiftUI

public struct OriginPublisher: View {
    private let coordinateSpace: CoordinateSpace
    
    public init(coordinateSpace: CoordinateSpace = .global) {
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: OriginPreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
        }
    }
}

public struct OriginsPublisher: View {
    private let coordinateSpace: CoordinateSpace
    
    public init(coordinateSpace: CoordinateSpace = .global) {
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: OriginsPreferenceKey.self,
                    value: [geometry.frame(in: coordinateSpace).origin]
                )
        }
    }
}

public extension View {
    func publishOrigin(to frame: Binding<CGPoint>, coordinateSpace: CoordinateSpace = .global) -> some View {
        self
            .background(OriginPublisher(coordinateSpace: coordinateSpace))
            .onPreferenceChange(OriginPreferenceKey.self, perform: { value in
                frame.wrappedValue = value
            })
    }
    
    func publishOrigins(to frame: Binding<[CGPoint]>, coordinateSpace: CoordinateSpace = .global) -> some View {
        self
            .background(OriginsPublisher(coordinateSpace: coordinateSpace))
            .onPreferenceChange(OriginsPreferenceKey.self, perform: { value in
                frame.wrappedValue = value
            })
    }
}
