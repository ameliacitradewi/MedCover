import SwiftUI

@MainActor
struct ResultView: View {
    @ObservedObject var viewModel: InsuranceFormViewModel

    var body: some View {
        VStack(spacing: 18) {
            Text("Result")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 10) {
                Text("Age: \(viewModel.ageText)")
                Text("Height: \(viewModel.heightCm) cm")
                Text("Weight: \(viewModel.weight) kg")
                Text("BMI: \(String(format: "%.2f", viewModel.bmiValue))")
                Text("Smoker: \(viewModel.smokerStatus.title) (\(viewModel.smokerStatus.rawValue))")
                Text("Children: \(viewModel.childrenCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.gray.opacity(0.15))
            )
            
            VStack(spacing: 8) {
                Text("Estimated Annual Premium")
                    .font(.headline)
                Text(viewModel.predictionText)
                    .font(.title2.bold())
                    .foregroundStyle(.green)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Summary")
        .task {
            viewModel.runPrediction()
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let vm = InsuranceFormViewModel()
        vm.ageText = "28"
        vm.heightCm = 170
        vm.weight = 64
        vm.smokerStatus = .no
        vm.childrenCount = 2
        return ResultView(viewModel: vm)
    }
}
