//
//  OnboardingView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-09.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authService: AuthenticationService
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @State private var currentPage = 0
    @State private var showAuthView = false
    
    let pages = [
        OnboardingPage(image: "Onboarding1", title: "Your Home Services, Simplified", description: "Effortlessly book trusted professionals for all your needs."),
        OnboardingPage(image: "Onboarding2", title: "Track Your Service Every Step of the Way", description: "Stay updated in real time, from booking to completion.")
    ]
    
    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    mainColor, // Main Brand Color
                    Color(red: 0.0, green: 0.30, blue: 0.15)   // Maintain Dark Green bottom for contrast
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Image Area (Behind the card)
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack {
                        Spacer()
                        Image(pages[index].image)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, pages[index].image == "Onboarding1" ? 25 : 10)
                            .offset(y: -240)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
            // Bottom Card
            VStack {
                Spacer()
                ZStack {
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                        .ignoresSafeArea(edges: .bottom)
                    
                    VStack(spacing: 20) {
                        Spacer().frame(height: 30)
                        
                        Text(pages[currentPage].title)
                            .font(.title) // Increased font size slightly
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true) // Allow wrapping
                        
                        Text(pages[currentPage].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Page Indicator (Moved below text as requested)
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? mainColor : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        // Bottom Action Area
                        VStack {
                            if currentPage == pages.count - 1 {
                                // Last Page: Full Width Button
                                Button(action: {
                                    isOnboardingCompleted = true
                                    showAuthView = true
                                }) {
                                    Text("Let's Get Started")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(mainColor)
                                        .cornerRadius(30)
                                }
                                .padding(.horizontal, 40)
                            } else {
                                // Other Pages: Skip and Next Arrow
                                HStack {
                                    Button("Skip") {
                                        isOnboardingCompleted = true
                                        showAuthView = true
                                    }
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            currentPage += 1
                                        }
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(mainColor)
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(.horizontal, 40)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.bottom, 20) // Extra padding for safe area
                }
                .frame(height: 320) // Fixed height for bottom card to ensure consistent "cover" amount
            }
            .ignoresSafeArea(.keyboard) 
        }
        .fullScreenCover(isPresented: $showAuthView) {
            AuthView()
                .environmentObject(authService)
        }
    }
    
    func completeOnboarding() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

#Preview {
    OnboardingView()
}
