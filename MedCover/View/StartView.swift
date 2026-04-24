import SwiftUI

// MARK: - Step Enum

enum FormStep: Hashable {
    case age, height, weight, smoker, children, result
}

// MARK: - StartView

@MainActor
struct StartView: View {
    @StateObject private var viewModel = InsuranceFormViewModel()
    @State private var path: [FormStep] = []

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView {
                path.append(.age)
            }
            .navigationDestination(for: FormStep.self) { step in
                FormStepView(step: step, viewModel: viewModel, path: $path)
            }
        }
    }
}

// MARK: - Welcome View

private struct WelcomeView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to MedCover")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("Mulai isi data untuk estimasi premi Anda.")
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Start", action: onStart)
        }
        .padding(24)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - FormStepView (Single view untuk semua step)

private struct FormStepView: View {
    let step: FormStep
    @ObservedObject var viewModel: InsuranceFormViewModel
    @Binding var path: [FormStep]

    private var canContinue: Bool {
        switch step {
        case .age: return !viewModel.ageText.isEmpty
        default:   return true
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            stepContent

            PrimaryButton(
                title: step == .children ? "See Result" : "Next",
                disabled: !canContinue
            ) {
                navigate()
            }
        }
        .padding()
        .navigationTitle(step.title)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case .age:
            AgeView(ageText: $viewModel.ageText)
        case .height:
            HeightView(selectedHeightCm: $viewModel.heightCm)
        case .weight:
            WeightPickerView(selectedWeight: $viewModel.weight)
        case .smoker:
            SmokerView(selectedStatus: $viewModel.smokerStatus)
        case .children:
            ChildrenView(selectedChildrenCount: $viewModel.childrenCount)
        case .result:
            ResultView(viewModel: viewModel)
        }
    }

    private func navigate() {
        guard let next = step.next else { return }
        path.append(next)
    }
}

// MARK: - FormStep Helpers

extension FormStep {
    var title: String {
        switch self {
        case .age:      return "Age"
        case .height:   return "Height"
        case .weight:   return "Weight"
        case .smoker:   return "Smoker"
        case .children: return "Children"
        case .result:   return "Result"
        }
    }

    var next: FormStep? {
        switch self {
        case .age:      return .height
        case .height:   return .weight
        case .weight:   return .smoker
        case .smoker:   return .children
        case .children: return .result
        case .result:   return nil
        }
    }
}

// MARK: - Reusable Button

private struct PrimaryButton: View {
    let title: String
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(disabled ? Color.gray : Color.blue)
                )
        }
        .disabled(disabled)
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    MainActor.assumeIsolated {
        StartView()
    }
}
