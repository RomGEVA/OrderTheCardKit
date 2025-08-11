//
//  ContentView.swift
//  OrdertheCards
//
//  Created by Denis on 22.05.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
       
            if !hasSeenOnboarding {
                OnboardingView()
            } else {
                MainMenuView()
            }
        
    }
}

#Preview {
    ContentView()
}
