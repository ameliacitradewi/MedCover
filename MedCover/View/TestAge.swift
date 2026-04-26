//
//  TestAge.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI
import Lottie

struct TestAge: View {
    @EnvironmentObject private var formViewModel: TestInsuranceFormViewModel
    @State private var ageInput: String = ""
    @State private var selectedAge: Double = 17
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()

                VStack {
                    VStack(spacing: 0) {
                        LottieView(animation: .named("Age"))
                            .playing(loopMode: .loop)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.height * 0.55, alignment: .bottom)
                            .clipped()
                        
//                        Image("age")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: geo.size.height * 0.55)
//                            .modifier(FloatingModifier())

                        GeometryReader { bottomGeo in
                            VStack(spacing: 20) {

                                Text("How Old Are You?")
                                    .font(.title.bold())

                                VStack(spacing: 12) {
                                    Text("\(Int(selectedAge))")
                                        .font(.system(size: bottomGeo.size.height * 0.18, weight: .bold))
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)

                                    Slider(value: $selectedAge, in: 1...65, step: 1)
                                        .tint(Color(hex: "880606"))
                                        .onChange(of: selectedAge) { _, newValue in
                                            let roundedAge = Int(newValue)
                                            ageInput = String(roundedAge)
                                            formViewModel.age = roundedAge
                                        }
                                }
                                .frame(
                                    width: bottomGeo.size.width * 0.8,
                                    height: bottomGeo.size.height * 0.3
                                )
                                .padding(.horizontal)

                                Text("Don't worry, we're all getting old.")
                                    .font(.caption.italic())

                                NextButton(title: "Next") {
                                    TestHeight()
                                }
                                    .disabled(ageInput.isEmpty)
                            }
                            .frame(maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.white.opacity(0.6))
                        )
                        .ignoresSafeArea()
                    }
                }
            }
            .frame(maxHeight: geo.size.height)
        }
        .onAppear {
            let savedAge = formViewModel.age
            let initialAge = savedAge > 0 ? min(max(savedAge, 1), 65) : 17
            selectedAge = Double(initialAge)
            ageInput = String(initialAge)
            formViewModel.age = initialAge
        }
    }
}

#Preview {
    TestAge()
        .environmentObject(TestInsuranceFormViewModel())
}
