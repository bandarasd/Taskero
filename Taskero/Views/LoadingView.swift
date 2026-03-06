//
//  LoadingView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-09.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(red: 0.0, green: 0.8, blue: 0.4)
                .ignoresSafeArea()
            
            Image("AppLogoWhite")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
        }
    }
}

#Preview {
    LoadingView()
}
