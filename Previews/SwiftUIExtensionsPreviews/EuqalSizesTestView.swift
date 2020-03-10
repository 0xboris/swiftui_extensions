//
//  EuqalSizesTestView.swift
//  SwiftUIExtensionsPreviews
//
//  Created by Boris Gutic on 10.03.20.
//  Copyright © 2020 Boris Gutic. All rights reserved.
//

import SwiftUI

struct EuqalSizesTestView: View {
    var body: some View {
        HStack {
            Group {
                Text("This")
                Text("is").font(.system(size: 50))
                Text("just")
                Text("some Text")
            }
            .sizedEqually()
            .foregroundColor(.black)
            .background(Color.yellow)
        }
        .equalSizes(by: .max)
    }
}

struct EuqalSizesTestView_Previews: PreviewProvider {
    static var previews: some View {
        EuqalSizesTestView()
            .frame(width: 400, height: 300)
            .background(Color.white)
    }
}
