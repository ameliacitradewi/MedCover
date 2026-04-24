//
//  SmokerView.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

enum SmokerStatus: Int, CaseIterable, Identifiable {
    case no = 0
    case yes = 1

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        }
    }
}

struct SmokerView: View {
    @Binding var selectedStatus: SmokerStatus

    var body: some View {
        VStack(spacing: 16) {
            Text("Did You Smoke?")
                .font(.largeTitle.bold())

            HStack(spacing: 14) {
                smokerButton(for: .yes)
                smokerButton(for: .no)
            }
        }
    }

    @ViewBuilder
    private func smokerButton(for status: SmokerStatus) -> some View {
        let isSelected = selectedStatus == status

        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                selectedStatus = status
            }
        } label: {
            Text(status.title)
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
    }
}


#Preview {
    SmokerPreview()
}

private struct SmokerPreview: View {
    @State private var selectedStatus: SmokerStatus = .no

    var body: some View {
        SmokerView(selectedStatus: $selectedStatus)
            .padding()
    }
}
