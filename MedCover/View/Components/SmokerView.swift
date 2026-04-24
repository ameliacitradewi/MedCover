//
//  SmokerView.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

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

        ToggleOptionButton(
            title: status.title,
            isSelected: isSelected
        ) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                selectedStatus = status
            }
        }
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
