//
//  TestHeight.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

struct TestHeight: View {
    @State private var heightInput = 160
    @State private var genderStatus: Gender? = nil
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack { // wrapper untuk semua
                    
                    VStack { // for toggle button
                        Text("Gender and Height")
                            .font(.title.bold())
                    
                        HStack {
                            ForEach(Gender.allCases) { status in
                                ToggleOptionButton(
                                    title: status.title,
                                    isSelected: genderStatus == status
                                ) {
                                    genderStatus = status
                                }
                            }
                        }
                    }
                    .frame(height: geo.size.height * 0.2)
                    
                    VStack { // for toggle button
                        Text("Height")
                    }
                    .frame(height: geo.size.height * 0.6)
                    
                    VStack { // for toggle button
                        NextButton(title: "Next", destination: TestWeight())
                    }
                    .frame(height: geo.size.height * 0.2)
                    
                }
                
            }
        }
    }
}


#Preview {
    TestHeight()
}
