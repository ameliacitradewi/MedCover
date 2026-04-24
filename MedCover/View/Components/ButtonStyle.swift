//
//  ButtonStyle.swift
//  MedCover
//
//  Created by Amelia Citra on 23/04/26.
//

import SwiftUI

struct ToggleOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(
                    width: isSelected ? 150 : 120,
                    height: isSelected ? 55 : 35
                )
                .background(
                    RoundedRectangle(cornerRadius: 46, style: .continuous)
                        .fill(
                            isSelected
                            ? LinearGradient(
                                colors: [Color(hex: "BBDCF8"), Color(hex: "4C7AF4")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            : LinearGradient(
                                colors: [Color.black, Color.black],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25, dampingFraction: 0.85), value: isSelected)
    }
}

struct GenderToggleButton: View {
    @Binding var selectedGender: Gender

    var body: some View {
        VStack {
            HStack {
                Text("Choose")
                Text("Detail")
                    .foregroundColor(.green)
            }
            .font(.title.bold())
            
            HStack(spacing: 14) {
                genderButton(for: .female)
                genderButton(for: .male)
            }
        }
        
    }

    @ViewBuilder
    private func genderButton(for gender: Gender) -> some View {
        let isSelected = selectedGender == gender

        ToggleOptionButton(
            title: gender.title,
            isSelected: isSelected
        ) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                selectedGender = gender
            }
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "F2F5FF").ignoresSafeArea()
        GenderTogglePreview()
    }
}

private struct GenderTogglePreview: View {
    @State private var selectedGender: Gender = .male

    var body: some View {
        GenderToggleButton(selectedGender: $selectedGender)
            .padding(.horizontal, 20)
    }
}
