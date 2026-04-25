//
//  TestWeight.swift
//  MedCover
//
//  Created by Amelia Citra on 26/04/26.
//

import SwiftUI

struct TestWeight: View {
    private var weightText = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack (spacing: 0) {
                    Image("weight")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 0.55)
                    
                    VStack (spacing: 20) {
                        Text("Your Current Weight?")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        
                        Text(weightText)
                        
                        NextButton(title: "Next", destination: TestSmoker())
                            .padding(.top)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    )
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}

#Preview {
    TestWeight()
}
