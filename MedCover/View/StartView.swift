import SwiftUI
import Lottie

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
            ZStack {
                MeshBg()
                    .ignoresSafeArea()

                WelcomeView {
                    path.append(.age)
                }
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
        VStack {
            VStack {
                LottieView(animation: .named("landingpage.json"))
                    .playing(loopMode: .loop)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
//                    .padding(.horizontal, 12)
//                    .padding(.top, 12)
            }
            
            Spacer(minLength: 0)
            
//            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("Estimate Your Insurance Premium")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Text("Answer a few quick questions to see your estimated insurance premium based on your health profile and lifestyle.\n\nFast, simple, and commitment-free.")
                        .multilineTextAlignment(.center)
                    
                    NormalButton(title: "Start", action: onStart)
                }
                .padding(.horizontal, 24)
                .padding(.top, 6)
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.94))
                )
                .ignoresSafeArea(edges: .bottom)
                .padding(.top, 50)
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
        ZStack {
            MeshBg()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                stepContent
                
                NormalButton(
                    title: step == .children ? "See Result" : "Next",
                    disabled: !canContinue
                ) {
                    navigate()
                }
            }
            .padding()
        }
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



// MARK: - Preview

#Preview {
    MainActor.assumeIsolated {
        StartView()
    }
}
