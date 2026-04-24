//
//  Model.swift
//  MedCover
//
//  Created by Amelia Citra on 24/04/26.
//


enum Gender: String, CaseIterable, Identifiable {
    case female
    case male

    var id: String { rawValue }

    var title: String {
        switch self {
        case .female: return "Female"
        case .male: return "Male"
        }
    }
}

enum SmokerStatus: Int, CaseIterable, Identifiable {
    case no = 0
    case yes = 1

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        }
    }
}
