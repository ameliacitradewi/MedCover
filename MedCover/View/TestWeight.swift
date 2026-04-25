//
//  TestWeight.swift
//  MedCover
//
//  Created by Amelia Citra on 26/04/26.
//

import SwiftUI

struct TestWeight: View {
    @State private var selectedWeight: Int = 60
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack (spacing: 0) {
                    Image("weight")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 0.55)
                    
                    VStack (spacing: 0) {
                        Text("Your Current Weight?")
                            .font(.title.bold())
                            .padding(.top)
                        
                        WeightPickerView(selectedWeight: $selectedWeight)
                        
                        NextButton(title: "Next", destination: TestSmoker())
                    }
                    .padding()
                    .frame(maxHeight: geo.size.height)
                    .background(
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    )
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .frame(maxHeight: geo.size.height)
        }
    }
}

#Preview {
    TestWeight()
}
