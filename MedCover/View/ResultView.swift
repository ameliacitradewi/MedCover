import SwiftUI

struct ResultView: View {
    let ageText: String
    let weight: Int
    let smokerStatus: SmokerStatus
    let childrenCount: Int

    var body: some View {
        VStack(spacing: 18) {
            Text("Result")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 10) {
                Text("Age: \(ageText)")
                Text("Weight: \(weight) kg")
                Text("Smoker: \(smokerStatus.title) (\(smokerStatus.rawValue))")
                Text("Children: \(childrenCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.gray.opacity(0.15))
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Summary")
    }
}

#Preview {
    ResultView(ageText: "28", weight: 64, smokerStatus: .no, childrenCount: 2)
}
