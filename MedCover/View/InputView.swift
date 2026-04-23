//
//  InputView.swift
//  MedCover
//
//  Created by Amelia Citra on 23/04/26.
//

import SwiftUI

struct InputView: View {
    @State private var selectedGender: Gender = .female

    var body: some View {
        NavigationStack {
            ZStack {

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        GenderToggleButton(selectedGender: $selectedGender)
                            .padding(.top, 12)
                            .padding()

                        HeightView()
                        WeightPickerView()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

#Preview {
    InputView()
}

