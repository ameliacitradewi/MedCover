//
//  ContentView.swift
//  MedCover
//
//  Created by Amelia Citra on 22/04/26.
//

import SwiftUI
import CoreML

struct ContentView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case female = "Perempuan"
        case male = "Laki-laki"

        var id: String { rawValue }

        // Mengikuti pola umum label encoding: female=0, male=1.
        var encodedValue: Double {
            switch self {
            case .female: return 0
            case .male: return 1
            }
        }
    }

    enum SmokerStatus: String, CaseIterable, Identifiable {
        case no = "Tidak"
        case yes = "Ya"

        var id: String { rawValue }

        // Mengikuti pola umum label encoding: no=0, yes=1.
        var encodedValue: Double {
            switch self {
            case .no: return 0
            case .yes: return 1
            }
        }
    }

    @State private var age: String = ""
    @State private var bmi: String = ""
    @State private var children: String = ""
    @State private var selectedGender: Gender = .female
    @State private var selectedSmokerStatus: SmokerStatus = .no

    @State private var predictionText: String = "-"
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Data Profil") {
                    TextField("Umur (tahun)", text: $age)
                        .keyboardType(.numberPad)

                    TextField("BMI", text: $bmi)
                        .keyboardType(.decimalPad)

                    TextField("Jumlah anak", text: $children)
                        .keyboardType(.numberPad)

                    Picker("Jenis kelamin", selection: $selectedGender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }

                    Picker("Perokok", selection: $selectedSmokerStatus) {
                        ForEach(SmokerStatus.allCases) { smoker in
                            Text(smoker.rawValue).tag(smoker)
                        }
                    }
                }

                Section {
                    Button("Hitung Prediksi Premi") {
                        runPrediction()
                    }
                }

                Section("Hasil") {
                    Text(predictionText)
                        .font(.headline)
                        .foregroundStyle(.green)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("MedCover")
        }
    }

    private func runPrediction() {
        errorMessage = nil

        guard
            let ageValue = Double(age),
            let bmiValue = Double(bmi),
            let childrenValue = Double(children)
        else {
            predictionText = "-"
            errorMessage = "Mohon isi umur, BMI, dan jumlah anak dengan angka yang valid."
            return
        }

        guard ageValue > 0, bmiValue > 0, childrenValue >= 0 else {
            predictionText = "-"
            errorMessage = "Pastikan umur dan BMI > 0, serta jumlah anak tidak negatif."
            return
        }

        do {
            // Tambahkan di awal runPrediction(), sebelum let model = try loadModel()
            print("=== DEBUG BUNDLE ===")
            if let modelURL = Bundle.main.url(forResource: "insurance_model", withExtension: "mlmodelc") {
                print("mlmodelc path: \(modelURL.path)")
                
                // Cek kapan file ini dibuat/dimodifikasi
                if let attrs = try? FileManager.default.attributesOfItem(atPath: modelURL.path) {
                    print("Created  : \(attrs[.creationDate] ?? "unknown")")
                    print("Modified : \(attrs[.modificationDate] ?? "unknown")")
                }
            } else {
                print("❌ mlmodelc tidak ditemukan di bundle")
            }
            
            let model = try loadModel()
            let input = try buildInputFeatures(
                age: ageValue,
                bmi: bmiValue,
                children: childrenValue,
                gender: selectedGender,
                smokerStatus: selectedSmokerStatus
            )

            // ── DEBUG: print semua nilai input sebelum masuk model ───────────────
            print("=== DEBUG INPUT ===")
            print("age            : \(ageValue)")
            print("age_squared    : \(ageValue * ageValue)")
            print("bmi (raw)      : \(bmiValue)")
            print("bmi (clipped)  : \(min(max(bmiValue, 13.67), 47.31))")
            print("children       : \(childrenValue)")
            print("smoker_encoded : \(selectedSmokerStatus.encodedValue)")
            print("smoker_bmi     : \(selectedSmokerStatus.encodedValue * min(max(bmiValue, 13.67), 47.31))")

            let output = try model.prediction(from: input)

            // ── DEBUG: print raw output sebelum expm1 ────────────────────────────
            print("=== DEBUG OUTPUT ===")
            print("raw annual_premium_log : \(output.featureValue(for: "annual_premium_log")?.doubleValue ?? -999)")

            guard let rawScore = output.featureValue(for: "annual_premium_log")?.doubleValue else {
                predictionText = "-"
                errorMessage = "Output `annual_premium_log` tidak ditemukan."
                return
            }

            print("rawScore       : \(rawScore)")
            print("expm1(rawScore): \(Foundation.expm1(rawScore))")

            let annualPremium = Foundation.expm1(rawScore)
            predictionText = String(format: "USD %.2f", annualPremium)

        } catch {
            predictionText = "-"
            errorMessage = "Gagal menjalankan model: \(error.localizedDescription)"
        }
    }
    
    private func loadModel() throws -> MLModel {
        let config = MLModelConfiguration()
        return try insurance_model(configuration: config).model
    }

    private func buildInputFeatures(
        age: Double,
        bmi: Double,
        children: Double,
        gender: Gender,
        smokerStatus: SmokerStatus
    ) throws -> MLDictionaryFeatureProvider {

        // ✅ Gunakan Double, bukan Float
        let bmiClipped      = min(max(bmi, 13.67), 47.31)
        let smokerEncoded   = smokerStatus.encodedValue        // sudah Double
        let ageSquared      = age * age
        let smokerBmi       = smokerEncoded * bmiClipped

        let features: [String: Any] = [
            "age"           : age,           // Double ✅
            "age_squared"   : ageSquared,    // Double ✅
            "bmi"           : bmiClipped,    // Double ✅
            "children"      : children,      // Double ✅
            "smoker_encoded": smokerEncoded, // Double ✅
            "smoker_bmi"    : smokerBmi,     // Double ✅
        ]

        _ = gender  // tidak dipakai model

        return try MLDictionaryFeatureProvider(dictionary: features)
    }
}

#Preview {
    ContentView()
}
