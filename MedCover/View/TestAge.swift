//
//  TestAge.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

struct TestAge: View {
    @State private var ageInput: String = ""
    @FocusState private var isAgeFocused: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 0) {
                        Image("age")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.height * 0.55)

                        GeometryReader { bottomGeo in
                            VStack(spacing: 20) {

                                Text("How Old Are You?")
                                    .font(.title.bold())

                                ZStack {
                                    if ageInput.isEmpty && !isAgeFocused {
                                        Text("Enter your age")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    TextField("", text: $ageInput)
                                        .focused($isAgeFocused)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .font(
                                            isAgeFocused || !ageInput.isEmpty
                                            ? .system(size: bottomGeo.size.height * 0.18, weight: .bold)
                                            : .headline
                                        )
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .onChange(of: ageInput) { _, newValue in
                                            ageInput = String(newValue.filter { $0.isNumber }.prefix(2))
                                        }
                                }
                                .frame(
                                    width: bottomGeo.size.width * 0.3,
                                    height: bottomGeo.size.height * 0.3
                                )
                                .padding(.horizontal)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                                .foregroundColor(.black)

                                Text("Don't worry, we're all getting old.")
                                    .font(.caption.italic())

                                NextButton(title: "Next", destination: TestHeight())
                                    .disabled(ageInput.isEmpty)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.white.opacity(0.6))
                        )
                        .ignoresSafeArea()
                    }
                }
            }
        }
    }
}

#Preview {
    TestAge()
}
