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
    @State private var navigateToStart = false

    private var premiumText: String {
        guard let premium = viewModel.annualPremium else { return "-" }
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: premium)) ?? String(format: "%.0f", premium)
    }

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
                            Text(String(format: "BMI: %.2f", data.bmi))
                            Text("Smoker: \(data.smokerStatus.title)")
                            Text("Children: \(data.children)")
                            
                            Divider()
                                .padding(.vertical, 4)

                            Text("Estimated Annual Premium")
                                .font(.headline)
                            Text(premiumText)
                                .font(.title2.bold())
                        } else {
                            Text("Data belum lengkap, cek input smoker.")
                                .foregroundStyle(.red)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        
                        Button {
                            formViewModel.reset()
                            viewModel.clearDataInput()
                            navigateToStart = true
                        } label: {
                            Text("DONE")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.black)
                                )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)

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
            viewModel.prepareAndPredict(from: formViewModel)
        }
        .navigationDestination(isPresented: $navigateToStart) {
            TestStart()
        }
    }
}

#Preview {
    TestResult()
        .environmentObject(TestInsuranceFormViewModel())
}
