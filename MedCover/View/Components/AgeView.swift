////
////  AgeView.swift
////  MedCover
////
////  Created by Amelia Citra on 24/04/26.
////
//
//import SwiftUI
//
//struct AgeView: View {
//    @Binding var ageText: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Age")
//                .font(.title2.bold())
//
//            TextField("Masukkan umur", text: $ageText)
//                .keyboardType(.numberPad)
//                .textInputAutocapitalization(.never)
//                .autocorrectionDisabled()
//                .padding(.horizontal, 14)
//                .padding(.vertical, 12)
//                .background(
//                    RoundedRectangle(cornerRadius: 12, style: .continuous)
//                        .fill(Color.white.opacity(0.85))
//                )
//                .onChange(of: ageText) {_, newValue in
//                    let filtered = newValue.filter(\.isNumber)
//                    let trimmed = String(filtered.prefix(2))
//                    if trimmed != newValue {
//                        ageText = trimmed
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    AgePreview()
//}
//
//private struct AgePreview: View {
//    @State private var ageText: String = ""
//
//    var body: some View {
//        AgeView(ageText: $ageText)
//        .padding()
//    }
//}
