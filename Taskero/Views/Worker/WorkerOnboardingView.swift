//
//  WorkerOnboardingView.swift
//  Taskero
//

import SwiftUI

struct WorkerOnboardingView: View {
    @AppStorage("isWorkerOnboardingCompleted") var isWorkerOnboardingCompleted: Bool = false
    @State private var currentPage = 0
    let mainColor = Color.brandGreen
    
    let onboardingData = [
        OnboardingPageData(
            title: "Be Your Own Boss",
            subtitle: "Accept jobs that fit your schedule. You have full control over when and where you work.",
            imageName: "briefcase.fill" // SF Symbol placeholder
        ),
        OnboardingPageData(
            title: "Track Your Earnings",
            subtitle: "See your payouts clearly. Get paid securely after every completed job.",
            imageName: "chart.pie.fill"
        ),
        OnboardingPageData(
            title: "Build Your Profile",
            subtitle: "Get rated by customers and grow your business with Taskero Pro.",
            imageName: "star.fill"
        )
    ]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation { isWorkerOnboardingCompleted = true }
                }) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
                .opacity(currentPage == onboardingData.count - 1 ? 0 : 1)
            }
            
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingPageWorker(data: onboardingData[index], color: mainColor)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom Paging Dots
            HStack(spacing: 8) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? mainColor : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentPage == index ? 1.2 : 1)
                        .animation(.spring(), value: currentPage)
                }
            }
            .padding(.bottom, 30)
            
            // Primary Action Button
            Button(action: {
                if currentPage < onboardingData.count - 1 {
                    withAnimation { currentPage += 1 }
                } else {
                    withAnimation { isWorkerOnboardingCompleted = true }
                }
            }) {
                Text(currentPage == onboardingData.count - 1 ? "Start Earning" : "Next")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mainColor)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
}

// Model for the page
struct OnboardingPageData {
    let title: String
    let subtitle: String
    let imageName: String
}

// Specific View for each page
struct OnboardingPageWorker: View {
    let data: OnboardingPageData
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Image Placeholder (Using SF Symbols for rapid prototyping)
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: data.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(color)
            }
            
            // Text Content
            VStack(spacing: 16) {
                Text(data.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(data.subtitle)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WorkerOnboardingView()
}
