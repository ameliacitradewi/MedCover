//
//  ChildrenView.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//

import SwiftUI

struct ChildrenView: View {
    @Binding var selectedChildrenCount: Int
    @State private var hasChildren: Bool? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 5)

    var body: some View {
        VStack(spacing: 14) {
            Text("Children")
                .font(.title2.bold())

            Text("Do you have children?")
                .font(.headline)

            HStack(spacing: 14) {
                Button {
                    hasChildren = true
                } label: {
                    Text("Yes")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(width: 100, height: 42)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(hasChildren == true ? .blue : .black)
                        )
                }
                .buttonStyle(.plain)

                Button {
                    hasChildren = false
                    selectedChildrenCount = 0
                } label: {
                    Text("No")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(width: 100, height: 42)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(hasChildren == false ? .blue : .black)
                        )
                }
                .buttonStyle(.plain)
            }

            Text("Selected: \(selectedChildrenCount)")
                .font(.headline)
                .foregroundColor(.secondary)

            if hasChildren == true {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(1...10, id: \.self) { index in
                    Button {
                        selectedChildrenCount = index
                    } label: {
                        Image(systemName: index <= selectedChildrenCount ? "person.circle.fill" : "person.circle")
                            .font(.system(size: 38, weight: .semibold))
                            .foregroundStyle(index <= selectedChildrenCount ? .blue : .gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            }
        }
        .padding()
        .onAppear {
            hasChildren = selectedChildrenCount > 0
        }
    }
}

#Preview {
    ChildrenPreview()
}

private struct ChildrenPreview: View {
    @State private var selectedChildrenCount: Int = 0

    var body: some View {
        ChildrenView(selectedChildrenCount: $selectedChildrenCount)
    }
}
