//
//  TestChildren.swift
//  MedCover
//
//  Created by Amelia Citra on 25/04/26.
//

import SwiftUI
import Lottie

struct TestChildren: View {
    @EnvironmentObject private var formViewModel: TestInsuranceFormViewModel
    @State private var hasChildren: Bool? = nil
    @State var selectedChildrenCount: Int = 0
    
    private var headerText: String {
        hasChildren == true ? "How Many Children?" : "Do You Have Children?"
    }
    
    private var bottomText: String {
        selectedChildrenCount > 0 ? "You have \(selectedChildrenCount) children? Looks fun!" : "Little human, big adventures."
    }
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 5)
    
    private var isNextDisabled: Bool {
        if hasChildren == false {
            return false
        }
        if hasChildren == true {
            return selectedChildrenCount <= 0
        }
        return true
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MeshBg().ignoresSafeArea()
                
                VStack (spacing: 0) {
                    LottieView(animation: .named("Children"))
                        .playing(loopMode: .loop)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 0.55, alignment: .center)
                        .clipped()
                    
//                    Image("children")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: geo.size.height * 0.55)
                    
                    GeometryReader { bottomGeo in
                        VStack(spacing: 20) {
                            
                            Text(headerText)
                                .font(.title.bold())
                            
                            VStack {
                                if hasChildren == true {
                                    LazyVGrid(columns: columns, spacing: 14) {
                                        ForEach(1...10, id: \.self) { index in
                                            Button {
                                                selectedChildrenCount = index
                                            } label: {
                                                Image(systemName: index <= selectedChildrenCount ? "person.circle.fill" : "person.circle")
                                                    .font(.system(size: 38, weight: .semibold))
                                                    .foregroundStyle(index <= selectedChildrenCount ? Color(hex: "880606") : .gray)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                } else {
                                    HStack {
                                        ToggleOptionButton(
                                            title: "Yes", isSelected: hasChildren == true
                                        ) {
                                            hasChildren = true
                                            selectedChildrenCount = 0
                                            formViewModel.children = 0
                                        }
                                        
                                        ToggleOptionButton(
                                            title: "No", isSelected: hasChildren == false
                                        ) {
                                            hasChildren = false
                                            selectedChildrenCount = 0
                                            formViewModel.children = 0
                                        }
                                    }
                                }
                            }
                            .frame(width: bottomGeo.size.width * 0.8 ,height: bottomGeo.size.height * 0.3)
                            
                            Text(bottomText)
                                .font(.caption.italic())
                            
                            NextButton(title: "Next", destination: TestResult(), disabled: isNextDisabled)
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    )
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .frame(maxHeight: geo.size.height)
        }
        .onAppear {
            selectedChildrenCount = formViewModel.children
            hasChildren = selectedChildrenCount > 0 ? true : nil
        }
        .onChange(of: selectedChildrenCount) { _, newValue in
            formViewModel.children = newValue
        }
        .onChange(of: hasChildren) { _, newValue in
            if newValue == false {
                selectedChildrenCount = 0
                formViewModel.children = 0
            }
        }
    }
}

#Preview("Default") {
    NavigationStack {
        TestChildren(selectedChildrenCount: 0)
            .environmentObject(TestInsuranceFormViewModel())
    }
}

#Preview("Selected 3 Children") {
    NavigationStack {
        TestChildren(selectedChildrenCount: 3)
            .environmentObject(TestInsuranceFormViewModel())
    }
}
