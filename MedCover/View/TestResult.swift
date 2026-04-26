//
//  TestResult.swift
//  MedCover
//
//  Created by Amelia Citra on 25/04/26.
//

import SwiftUI
import Lottie

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
                    LottieView(animation: .named("Premium"))
                        .playing(loopMode: .loop)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 0.3, alignment: .bottom)
                        .clipped()
                        .padding(.top)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Summary of Your Data")
                            .font(.title3.bold())
                            .padding(.bottom)

                        if let data = viewModel.dataInput {
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ],
                                spacing: 0
                            ) {
                                Text("Age: \(data.age)")
                                Text("Gender: \(data.gender.title)")
                                
                                Text("Height: \(data.heightCm) cm")
                                Text("Weight: \(data.weightKg) kg")
                                
                                Text(String(format: "BMI: %.2f", data.bmi))
                                Text("Smoker: \(data.smokerStatus.title)")
                                
                                Text("Children: \(data.children)")
                            }
                            
                            Divider()
                                .padding(.vertical, 4)

                            Text("Estimated Annual Premium")
                                .font(.title3.bold())
                            
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
                        .padding(.top)

                    }
                    .frame(maxWidth: geo.size.width * 0.8, alignment: .center)
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
        .onAppear { viewModel.prepareAndPredict(from: formViewModel)}
        .navigationDestination(isPresented: $navigateToStart) { TestStart() }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TestResult()
        .environmentObject(TestInsuranceFormViewModel())
}
