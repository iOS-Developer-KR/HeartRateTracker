//import SwiftUI
//
//struct ContentView: View {
//    @State private var heartRates: [Int] = Array(repeating: 70, count: 10)
//    @State private var timer: Timer? = nil
//
//    var body: some View {
//        VStack {
//            WaveformView(heartRates: heartRates)
//                .stroke(Color.green, lineWidth: 3)
//                .frame(height: 200)
//                .background(Color.black)
//                .padding()
////                .overlay(
////                    RoundedRectangle(cornerRadius: 10)
////                        .stroke(Color.gray.opacity(0.7), lineWidth: 2)
////                )
//
//            Button(action: startUpdating) {
//                Text("Start Updating")
//                    .font(.title)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//        }
//        .onAppear {
//            startUpdating()
//        }
//        .onDisappear {
//            stopUpdating()
//        }
//    }
//
//    func startUpdating() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            withAnimation(.linear(duration: 0.1)) {
//                updateHeartRates()
//            }
//        }
//    }
//
//    func stopUpdating() {
//        timer?.invalidate()
//    }
//
//    func updateHeartRates() {
//        // 심박수 데이터를 병원 모니터와 유사하게 생성
//        let newRate = Int.random(in: 60...100) + (Bool.random() ? Int.random(in: 0...20) : -Int.random(in: 0...20))
//        heartRates.append(newRate)
//        if heartRates.count > 30 {
//            heartRates.removeFirst()
//        }
//    }
//}
//
//struct WaveformView: Shape {
//    var heartRates: [Int]
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        guard heartRates.count > 1 else { return path }
//
//        let widthPerPoint = rect.width / CGFloat(heartRates.count - 1)
//        let heightFactor = rect.height / CGFloat(heartRates.max() ?? 1)
//
//        path.move(to: CGPoint(x: 0, y: rect.height / 2))
//
//        for index in heartRates.indices {
//            let x = CGFloat(index) * widthPerPoint
//            let y = rect.height - (CGFloat(heartRates[index]) * heightFactor)
//            path.addLine(to: CGPoint(x: x, y: y))
//        }
//
//        return path
//    }
//}
//
//#Preview {
//    ContentView()
//}
