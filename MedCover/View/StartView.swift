import SwiftUI

@MainActor
struct StartView: View {
    @StateObject private var viewModel = InsuranceFormViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Welcome to MedCover")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("Mulai isi data untuk estimasi premi Anda.")
                    .foregroundStyle(.secondary)

                NavigationLink {
                    AgeStepView(viewModel: viewModel)
                } label: {
                    Text("Start")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(.blue)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct AgeStepView: View {
    @ObservedObject var viewModel: InsuranceFormViewModel

    private var canContinue: Bool { !viewModel.ageText.isEmpty }

    var body: some View {
        VStack(spacing: 24) {
            AgeView(ageText: $viewModel.ageText)

            NavigationLink {
                HeightStepView(viewModel: viewModel)
            } label: {
                Text("Next")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(canContinue ? .blue : .gray)
                    )
            }
            .disabled(!canContinue)
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle("Age")
    }
}

private struct HeightStepView: View {
    @ObservedObject var viewModel: InsuranceFormViewModel

    var body: some View {
        VStack(spacing: 24) {
            HeightView(selectedHeightCm: $viewModel.heightCm)

            NavigationLink {
                WeightStepView(viewModel: viewModel)
            } label: {
                Text("Next")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle("Height")
    }
}

private struct WeightStepView: View {
    @ObservedObject var viewModel: InsuranceFormViewModel

    var body: some View {
        VStack(spacing: 24) {
            WeightPickerView(selectedWeight: $viewModel.weight)

            NavigationLink {
                SmokerStepView(viewModel: viewModel)
            } label: {
                Text("Next")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle("Weight")
    }
}

private struct SmokerStepView: View {
    @ObservedObject var viewModel: InsuranceFormViewModel

    var body: some View {
        VStack(spacing: 24) {
            SmokerView(selectedStatus: $viewModel.smokerStatus)

            NavigationLink {
                ChildrenStepView(viewModel: viewModel)
            } label: {
                Text("Next")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle("Smoker")
    }
}

private struct ChildrenStepView: View {
    @ObservedObject var viewModel: InsuranceFormViewModel

    var body: some View {
        VStack(spacing: 24) {
            ChildrenView(selectedChildrenCount: $viewModel.childrenCount)

            NavigationLink {
                ResultView(viewModel: viewModel)
            } label: {
                Text("See Result")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle("Children")
    }
}

#Preview {
    MainActor.assumeIsolated {
        StartView()
    }
}
