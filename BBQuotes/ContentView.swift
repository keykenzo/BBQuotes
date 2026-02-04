//
//  ContentView.swift
//  BBQuotes
//
//  Created by Mario Duarte on 02/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FetchView(show: Constants.bbName)
                .tabItem {
                    Label(Constants.bbName, systemImage: "tortoise")
                }
            
            FetchView(show: Constants.bcsName)
                .tabItem {
                    Label(Constants.bcsName, systemImage: "briefcase")
                }
            
            FetchView(show: Constants.ecName)
                .tabItem {
                    Label(Constants.ecName, systemImage: "car")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
