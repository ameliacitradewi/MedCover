//
//  TestHeight.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

struct TestHeight: View {
    @State private var selectedHeightCm: Int = 160
    @State private var genderStatus: Gender = .female
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack { // wrapper untuk semua
                    VStack {
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
                        .frame(height: 60)
                    }
                    
                    HeightView(
                        selectedHeightCm: $selectedHeightCm,
                        selectedGender: $genderStatus
                    )
                    
                    NextButton(title: "Next", destination: TestWeight())
                }
                .frame(maxHeight: geo.size.height)
            }
            .frame(maxHeight: geo.size.height)
        }
    }
}

#Preview("Default") {
    NavigationStack {
        TestHeight()
    }
}
