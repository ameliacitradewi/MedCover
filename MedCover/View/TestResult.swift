//
//  TestResult.swift
//  MedCover
//
//  Created by Amelia Citra on 25/04/26.
//

import SwiftUI

struct TestResult: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack (spacing: 0) {
                    Text("result")
                }
                .background(
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxHeight: geo.size.height)
        }
    }
}

#Preview {
    TestResult()
}
