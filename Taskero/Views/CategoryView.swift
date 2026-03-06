//
//  CategoryView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import SwiftUI

struct CategoryView: View {
    let mainColor = Color.brandGreen
    @State private var searchText = ""
    
    var filteredCategories: [CategoryItem] {
        if searchText.isEmpty {
            return MockData.categories
        } else {
            return MockData.categories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Categories")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Categories", text: $searchText)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                // Categories Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(filteredCategories) { category in
                            NavigationLink(destination: CategoryServicesView(category: category)) {
                                CategoryCard(category: category, mainColor: mainColor)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

struct CategoryCard: View {
    let category: CategoryItem
    let mainColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(category.backgroundColor.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                if category.isSystemImage {
                    Image(systemName: category.icon)
                        .font(.system(size: 30))
                        .foregroundColor(category.backgroundColor)
                } else {
                    Image(category.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
            
            Text(category.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    CategoryView()
}
