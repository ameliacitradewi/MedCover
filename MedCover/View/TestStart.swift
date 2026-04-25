//
//  TestStart.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI
import Lottie

struct TestStart: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    MeshBg().ignoresSafeArea()
                    
                    VStack (spacing: 0) {
                        Image("landingpage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.height * 0.55)
                        
                        VStack (spacing: 20) {
                            Text("Estimate Your Insurance Premium")
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            
                            Text("Answer a few quick questions to see your estimated insurance premium based on your health profile and lifestyle.\n\nFast, simple, and commitment-free.")
                                .multilineTextAlignment(.center)
                            
                            NextButton(title: "Start", destination: TestAge())
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
        } // end navigation stack
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TestStart()
}
