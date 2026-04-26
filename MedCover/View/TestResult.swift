//
//  TestResult.swift
//  MedCover
//
//  Created by Amelia Citra on 25/04/26.
//

import SwiftUI

struct TestResult: View {
    @EnvironmentObject private var formViewModel: TestInsuranceFormViewModel
    @StateObject private var viewModel = ResultViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack (spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Result Input")
                            .font(.title.bold())

                        if let data = viewModel.dataInput {
                            Text("Age: \(data.age)")
                            Text("Gender: \(data.gender.title)")
                            Text("Height: \(data.heightCm) cm")
                            Text("Weight: \(data.weightKg) kg")
                            Text("Smoker: \(data.smokerStatus.title)")
                            Text("Children: \(data.children)")
                        } else {
                            Text("Data belum lengkap, cek input smoker.")
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(24)
                }
                .background(
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxHeight: geo.size.height)
        }
        .onAppear {
            viewModel.buildDataInput(from: formViewModel)
        }
    }
}

#Preview {
    TestResult()
        .environmentObject(TestInsuranceFormViewModel())
}
