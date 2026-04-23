//
//  Background.swift
//  MedCover
//
//  Created by Amelia Citra on 23/04/26.
//

import SwiftUI

struct Background: View {
  
  @State private var isActive = false
  
  var body: some View {
    TimelineView(.animation) { context in
      let s = context.date.timeIntervalSince1970
      let v = Float(sin(s)) / 4
      
      MeshGradient(
        width: 3,
        height: 3,
        points: [
          [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
          [0.0, 0.5], [0.5 + v, 0.5 - v], [1.0, 0.3 - v],
          [0.0, 1.0], [0.7 - v, 1.0], [1.0, 1.0],
        ],
        colors: [
          .softLavender, .paleSkyBlue,   isActive ? .blushPink : .mintGreen,
          .dustyRose,                             .peachCream,    .babyBlue,
          isActive ? .peachCream : .lilacMist,    .seafoamPastel, .blushPink
        ]
      )
    }
    .ignoresSafeArea()
    .onAppear {
      withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
        isActive = true
      }
    }
  }
}

extension Color {
  static let softLavender = Color(red: 220/255, green: 208/255, blue: 255/255)   // Soft lavender
  static let paleSkyBlue = Color(red: 176/255, green: 218/255, blue: 255/255)    // Pale sky blue
  static let mintGreen = Color(red: 198/255, green: 255/255, blue: 226/255)      // Mint green
  static let dustyRose = Color(red: 255/255, green: 198/255, blue: 218/255)      // Dusty rose
  static let peachCream = Color(red: 255/255, green: 224/255, blue: 196/255)     // Peach cream
  static let babyBlue = Color(red: 198/255, green: 222/255, blue: 255/255)       // Baby blue
  static let lilacMist = Color(red: 232/255, green: 208/255, blue: 238/255)      // Lilac mist
  static let seafoamPastel = Color(red: 202/255, green: 255/255, blue: 242/255)  // Seafoam pastel
  static let blushPink = Color(red: 255/255, green: 218/255, blue: 233/255)      // Blush pink
}

#Preview {
  Background()
}
