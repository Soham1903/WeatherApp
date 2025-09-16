//
//  ContentView.swift
//  WeatherApp
//
//  Created by Soham on 16/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Weather Search 🌦️")
                    .font(.system(size: 40, weight: .heavy, design: .rounded)) // custom font style
                    .foregroundColor(.white) // custom color

                SearchBar(
                    text: $viewModel.city,
                    onSearch: {
                        viewModel.fetchWeather()
                    }
                )
                if let weather = viewModel.weather {
                    WeatherView(weather: weather)
                } else if viewModel.isLoading {
                    ProgressView("Fetching weather...")
                } else {
                    Text("Enter a city to get weather").font(.largeTitle).foregroundColor(.white)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
            }
            .padding()
            .frame(width: 700, height: 400)
        }
        
    }
}

