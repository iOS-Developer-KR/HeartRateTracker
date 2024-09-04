import SwiftUI

struct Wave: Shape {
    var frequency: CGFloat = 1.5
    var density: CGFloat = 1.0
    var phase: CGFloat
    var normedAmplitude: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let maxAmplitude = rect.height / 2.0
        let mid = rect.width / 2
        
        for x in Swift.stride(from: 0, to: rect.width + self.density, by: self.density) {
            let scaling = -pow(1 / mid * (x - mid), 2) + 1
            let y = scaling * maxAmplitude * normedAmplitude * sin(CGFloat(2 * Double.pi) * self.frequency * (x / rect.width) + self.phase) + rect.height / 2
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct MainView: View {
    @Environment(WatchConnectivity.self) var watchConnectivity
    @State private var shadowValue = 0.6
    
    var body: some View {
        Text("Heart Rate Monitor")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.bottom, 10)
        
        HStack {
            // Waveform View
            WaveformView(heartRates: watchConnectivity.heartRates.map { $0.hr })
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.green, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing),
                    lineWidth: 3
                )
                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading)
                .background(Color.black)
                .cornerRadius(15)
                .shadow(color: .green.opacity(shadowValue), radius: 10, x: 0, y: 10)
                .padding(.leading, 40)
                .overlay(alignment: .leading) {
                    VStack {
                        ForEach(yAxisLabels().reversed(), id: \.self) { label in
                            Spacer()
                            Text(label)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                        }
                    }
                }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 3).repeatForever()) {
                    shadowValue = 0.2
                }
            }
        }
    }
    
    private func yAxisLabels() -> [String] {
        let minValue: CGFloat = 0
        let maxValue: CGFloat = 180
        let numberOfLabels = 5
        let step = (maxValue - minValue) / CGFloat(numberOfLabels - 1)
        return (0..<numberOfLabels).map { "\((CGFloat($0) * step).formatted())" }
    }
}

struct WaveformView: Shape {
    var heartRates: [Int]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard heartRates.count > 1 else {
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            return path
        }
        
        let widthPerPoint = rect.width / CGFloat(max(heartRates.count - 1, 1))
        let maxHeartRate: CGFloat = 200 // 최대 심박수 값 조정
        let heightFactor = rect.height / maxHeartRate
        let baselineY = rect.height
        
        path.move(to: CGPoint(x: 0, y: baselineY))
        
        for index in 1..<heartRates.count {
            let x = CGFloat(index) * widthPerPoint
            let y = baselineY - CGFloat(heartRates[index]) * heightFactor
            
            let previousX = CGFloat(index - 1) * widthPerPoint
            let previousY = baselineY - CGFloat(heartRates[index - 1]) * heightFactor
            
            let controlX1 = previousX + (x - previousX) / 2
            let controlY1 = previousY
            
            let controlX2 = previousX + (x - previousX) / 2
            let controlY2 = y
            
            path.addCurve(to: CGPoint(x: x, y: y),
                          control1: CGPoint(x: controlX1, y: controlY1),
                          control2: CGPoint(x: controlX2, y: controlY2))
        }
        
        return path
    }
}


#Preview {
    MainView()
        .environment(WatchConnectivity())
}
