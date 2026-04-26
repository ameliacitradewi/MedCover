//
//  ButtonStyle.swift
//  MedCover
//
//  Created by Amelia Citra on 23/04/26.
//

import SwiftUI
import UIKit

private enum HapticFeedback {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

struct ToggleOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticFeedback.light()
            action()
        } label: {
            Text(title)
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(
                    width: isSelected ? 150 : 120,
                    height: isSelected ? 35 : 20
                )
                .background(
                    RoundedRectangle(cornerRadius: 46, style: .continuous)
                        .fill(
                            isSelected
                            ? LinearGradient(
                                colors: [Color(hex: "C21014"), Color(hex: "880606")],
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


struct NormalButton: View {
    let title: String
    var disabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button {
            HapticFeedback.light()
            action()
        } label: {
            Text(title.uppercased())
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 45)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(disabled ? Color.gray : Color.black)
                )
        }
        .disabled(disabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .simultaneousGesture(
            TapGesture().onEnded {
                if !disabled {
                    HapticFeedback.light()
                }
            }
        )
    }
}

struct NextButton: View {
    
    let title: String
    let destination: () -> AnyView
    var disabled: Bool = false
    var color: Color = .black
    
    init<Destination: View>(
        title: String,
        disabled: Bool = false,
        color: Color = .black,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.title = title
        self.disabled = disabled
        self.color = color
        self.destination = { AnyView(destination()) }
    }
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            Text(title.uppercased())
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 45)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(disabled ? Color.gray : color)
                )
        }
        .disabled(disabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .simultaneousGesture(
            TapGesture().onEnded {
                if !disabled {
                    HapticFeedback.light()
                }
            }
        )
    }
}

//#Preview {
//    NextButton(title: "Test", destination: TestAge())
//}

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
