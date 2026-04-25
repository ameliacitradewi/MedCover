//
//  TestSmoker.swift
//  MedCover
//
//  Created by Amelia Citra on 25/04/26.
//

import SwiftUI

struct TestSmoker: View {
    @State private var smokerStatus: SmokerStatus? = nil
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack (spacing: 0) {
                    Image("smoke")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 0.55)
                    
                    GeometryReader { bottomGeo in
                        VStack(spacing: 20) {
                            
                            Text("Do You Smoke?")
                                .font(.title.bold())
                            
                            HStack {
                                ForEach(SmokerStatus.allCases) { status in
                                    ToggleOptionButton(
                                        title: status.title,
                                        isSelected: smokerStatus == status
                                    ) {
                                        smokerStatus = status
                                    }
                                }
                            }
                            .frame(width: bottomGeo.size.width * 0.8 ,height: bottomGeo.size.height * 0.3)
                            
                            Text("Honesty is healthier than nicotine.")
                                .font(.caption.italic())
                            
                            NextButton(title: "Next", destination: TestChildren(), disabled: smokerStatus == nil)
                        }
                        .frame(maxHeight: .infinity)
                    }
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
    TestSmoker()
}
