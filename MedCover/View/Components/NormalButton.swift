//
//  NormalButton.swift
//  MedCover
//

import SwiftUI

struct NormalButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.black)
                )
        }
    }
}

#Preview {
    NormalButton(title: "Next") {}
        .padding()
}
