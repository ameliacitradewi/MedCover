import SwiftUI

struct StartView: View {
    @State private var ageText: String = ""
    @State private var heightCm: Int = 160
    @State private var weight: Int = 60
    @State private var smokerStatus: SmokerStatus = .no
    @State private var childrenCount: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Welcome to MedCover")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("Mulai isi data untuk estimasi premi Anda.")
                    .foregroundStyle(.secondary)

                NavigationLink {
                    AgeStepView(
                        ageText: $ageText,
                        heightCm: $heightCm,
                        weight: $weight,
                        smokerStatus: $smokerStatus,
                        childrenCount: $childrenCount
                    )
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
    @Binding var ageText: String
    @Binding var heightCm: Int
    @Binding var weight: Int
    @Binding var smokerStatus: SmokerStatus
    @Binding var childrenCount: Int

    private var canContinue: Bool { !ageText.isEmpty }

    var body: some View {
        VStack(spacing: 24) {
            AgeView(ageText: $ageText)

            NavigationLink {
                HeightStepView(
                    ageText: $ageText,
                    heightCm: $heightCm,
                    weight: $weight,
                    smokerStatus: $smokerStatus,
                    childrenCount: $childrenCount
                )
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
    @Binding var ageText: String
    @Binding var heightCm: Int
    @Binding var weight: Int
    @Binding var smokerStatus: SmokerStatus
    @Binding var childrenCount: Int

    var body: some View {
        VStack(spacing: 24) {
            HeightView(selectedHeightCm: $heightCm)

            NavigationLink {
                WeightStepView(
                    ageText: $ageText,
                    heightCm: $heightCm,
                    weight: $weight,
                    smokerStatus: $smokerStatus,
                    childrenCount: $childrenCount
                )
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
    @Binding var ageText: String
    @Binding var heightCm: Int
    @Binding var weight: Int
    @Binding var smokerStatus: SmokerStatus
    @Binding var childrenCount: Int

    var body: some View {
        VStack(spacing: 24) {
            WeightPickerView(selectedWeight: $weight)

            NavigationLink {
                SmokerStepView(
                    ageText: $ageText,
                    heightCm: $heightCm,
                    weight: $weight,
                    smokerStatus: $smokerStatus,
                    childrenCount: $childrenCount
                )
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
    @Binding var ageText: String
    @Binding var heightCm: Int
    @Binding var weight: Int
    @Binding var smokerStatus: SmokerStatus
    @Binding var childrenCount: Int

    var body: some View {
        VStack(spacing: 24) {
            SmokerView(selectedStatus: $smokerStatus)

            NavigationLink {
                ChildrenStepView(
                    ageText: $ageText,
                    heightCm: $heightCm,
                    weight: $weight,
                    smokerStatus: $smokerStatus,
                    childrenCount: $childrenCount
                )
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
    @Binding var ageText: String
    @Binding var heightCm: Int
    @Binding var weight: Int
    @Binding var smokerStatus: SmokerStatus
    @Binding var childrenCount: Int

    var body: some View {
        VStack(spacing: 24) {
            ChildrenView(selectedChildrenCount: $childrenCount)

            NavigationLink {
                ResultView(
                    ageText: ageText,
                    heightCm: heightCm,
                    weight: weight,
                    smokerStatus: smokerStatus,
                    childrenCount: childrenCount
                )
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
    StartView()
}
