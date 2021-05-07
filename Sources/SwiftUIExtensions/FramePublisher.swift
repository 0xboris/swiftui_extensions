//
//  FramePublisher.swift
//  
//
//  Created by Boris Gutic on 06.05.21.
//

import SwiftUI

public struct FramePublisher: View {
    private let coordinateSpace: CoordinateSpace
    
    public init(coordinateSpace: CoordinateSpace = .global) {
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: FramePreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace)
                )
        }
    }
}

public extension View {
    func publishFrame(
        to frame: Binding<CGRect>,
        coordinateSpace: CoordinateSpace = .global
    ) -> some View {
        self
            .background(FramePublisher(coordinateSpace: coordinateSpace))
            .onPreferenceChange(FramePreferenceKey.self, perform: { value in
                frame.wrappedValue = value
            })
    }
}

struct FramePublisher_Previews: PreviewProvider {
    private struct TestView: View {
        @State private var frame: CGRect = .zero
        
        private var frameString: String {
            String(format: "x: %.2f, y: %.2f  |  w: %.2f, h: %.2f",
                   frame.origin.x,
                   frame.origin.y,
                   frame.size.width,
                   frame.size.height)
        }
        
        var body: some View {
            VStack(spacing: 20) {
                Text(frameString)
                    .font(.footnote.bold())
                    .padding(4)
                    .background(Color.yellow.opacity(0.2))
                
                Text("Hello, World!")
                    .font(.title)
                    .publishFrame(to: $frame)
            }
        }
    }
    
    static var previews: some View {
        TestView()
    }
}
