//
//  TestHeight.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

struct TestHeight: View {
    @EnvironmentObject private var formViewModel: TestInsuranceFormViewModel
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
                    
                    NextButton(title: "Next") {
                        TestWeight()
                    }
                }
                .frame(maxHeight: geo.size.height)
            }
            .frame(maxHeight: geo.size.height)
        }
        .onAppear {
            selectedHeightCm = formViewModel.heightCm
            genderStatus = formViewModel.gender
        }
        .onChange(of: selectedHeightCm) { _, newValue in
            formViewModel.heightCm = newValue
        }
        .onChange(of: genderStatus) { _, newValue in
            formViewModel.gender = newValue
        }
    }
}

#Preview("Default") {
    NavigationStack {
        TestHeight()
            .environmentObject(TestInsuranceFormViewModel())
    }
}
