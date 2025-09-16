import SwiftUI

struct WeatherView: View {
    let weather: WeatherData
    @State private var animationOffset: CGFloat = 0
    @State private var cloudOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: backgroundColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animationOffset)
            
            // Animated background elements
            backgroundElements
            
            // Main content
            VStack(spacing: 20) {
                // Location with icon
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.white.opacity(0.8))
                    Text(weather.cityName)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                
                // Weather icon with animation
                weatherIcon
                    .scaleEffect(pulseScale)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseScale)
                
                // Temperature
                Text(String(format: "%.1f°", weather.temperature))
                    .font(.system(size: 64, weight: .thin, design: .rounded))
                    .foregroundColor(.white)
                
                // Weather description
                Text(weather.description.capitalized)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                
                // Additional weather info
                HStack(spacing: 30) {
                    weatherInfoItem(icon: "humidity.fill", value: "\(weather.humidity ?? 0)%", label: "Humidity")
                    weatherInfoItem(icon: "wind", value: String(format: "%.1f km/h", weather.windSpeed ?? 0), label: "Wind")
                    weatherInfoItem(icon: "thermometer", value: String(format: "%.0f°", weather.feelsLike ?? weather.temperature), label: "Feels like")
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColors: [Color] {
        switch weather.condition {
        case .sunny, .clear:
            return [Color.orange, Color.yellow, Color.pink]
        case .cloudy, .partlyCloudy:
            return [Color.gray, Color.blue.opacity(0.7), Color.white.opacity(0.8)]
        case .rainy:
            return [Color.blue.opacity(0.8), Color.gray, Color.black.opacity(0.6)]
        case .snowy:
            return [Color.white, Color.blue.opacity(0.3), Color.gray.opacity(0.5)]
        case .stormy:
            return [Color.black.opacity(0.7), Color.purple.opacity(0.8), Color.gray]
        default:
            return [Color.blue, Color.cyan, Color.mint]
        }
    }
    
    private var weatherIcon: some View {
        Image(systemName: weatherIconName)
            .font(.system(size: 80))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var weatherIconName: String {
        switch weather.condition {
        case .sunny, .clear:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .rainy:
            return "cloud.rain.fill"
        case .snowy:
            return "cloud.snow.fill"
        case .stormy:
            return "cloud.bolt.rain.fill"
        default:
            return "cloud.fill"
        }
    }
    
    private var backgroundElements: some View {
        GeometryReader { geometry in
            ZStack {
                // Floating particles/elements
                ForEach(0..<20, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 10...30))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height) + animationOffset
                        )
                        .animation(.linear(duration: Double.random(in: 10...20)).repeatForever(autoreverses: false), value: animationOffset)
                }
                
                // Weather-specific elements
                if weather.condition == .rainy {
                    // Rain drops
                    ForEach(0..<15, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 2, height: 20)
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: -20 + animationOffset
                            )
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: animationOffset)
                    }
                }
                
                if weather.condition == .snowy {
                    // Snow flakes
                    ForEach(0..<25, id: \.self) { _ in
                        Image(systemName: "snowflake")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: CGFloat.random(in: 10...20)))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: -30 + animationOffset * 0.8
                            )
                            .animation(.linear(duration: Double.random(in: 3...8)).repeatForever(autoreverses: false), value: animationOffset)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func weatherInfoItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // MARK: - Helper Methods
    
    private func startAnimations() {
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            animationOffset = 1000 // Use a large fixed value instead of screen height
        }
        
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
    }
}

// MARK: - Supporting Types

// Extend your WeatherData model to include these properties
extension WeatherData {
    // Add these properties to your WeatherData struct if they don't exist
    var humidity: Int? { return 65 } // Example values - replace with actual data
    var windSpeed: Double? { return 12.5 }
    var feelsLike: Double? { return temperature + 2 }
    var condition: WeatherCondition {
        // Map your weather description to conditions
        switch description.lowercased() {
        case let desc where desc.contains("sun") || desc.contains("clear"):
            return .sunny
        case let desc where desc.contains("cloud"):
            return desc.contains("partly") ? .partlyCloudy : .cloudy
        case let desc where desc.contains("rain"):
            return .rainy
        case let desc where desc.contains("snow"):
            return .snowy
        case let desc where desc.contains("storm") || desc.contains("thunder"):
            return .stormy
        default:
            return .cloudy
        }
    }
}

enum WeatherCondition {
    case sunny, clear, partlyCloudy, cloudy, rainy, snowy, stormy
}

// MARK: - Preview
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: WeatherData(
            cityName: "Mumbai",
            temperature: 28.5,
            description: "partly cloudy"
        ))
    }
}
