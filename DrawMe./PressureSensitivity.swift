import UIKit

class PressureSensitivity: UIView {
    private var pressureData: [CGFloat] = [] // Store pressure data
    private var touchPoints: [CGPoint] = [] // Store touch locations for visualization
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        logPressure(touch: touch)
        drawCircle(at: touch.location(in: self), with: touch.force)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        logPressure(touch: touch)
        drawCircle(at: touch.location(in: self), with: touch.force)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        logPressure(touch: touch)
        savePressureDataToFile() // Save data when the touch ends
    }
    
    private func logPressure(touch: UITouch) {
        if touch.maximumPossibleForce > 0 {
            let pressure = touch.force
            let normalizedPressure = pressure / touch.maximumPossibleForce
            pressureData.append(normalizedPressure)
            print("Pressure detected: \(normalizedPressure * 100)% (raw: \(pressure))")
        } else {
            print("Device does not support pressure sensitivity.")
        }
    }
    
    private func drawCircle(at point: CGPoint, with pressure: CGFloat) {
        // Normalize pressure if supported, otherwise default to a small size
        let circleSize: CGFloat
        if pressure > 0 {
            circleSize = max(10, (pressure / 6.0) * 50) // Scale pressure to circle size
        } else {
            circleSize = 10.0
        }
        
        let circle = UIView(frame: CGRect(x: point.x - circleSize / 2, y: point.y - circleSize / 2, width: circleSize, height: circleSize))
        circle.layer.cornerRadius = circleSize / 2
        circle.backgroundColor = UIColor.red.withAlphaComponent(0.5) // Semi-transparent red
        addSubview(circle)
        
        // Fade out and remove the circle after a short duration
        UIView.animate(withDuration: 1.0, animations: {
            circle.alpha = 0.0
        }, completion: { _ in
            circle.removeFromSuperview()
        })
    }
    
    private func savePressureDataToFile() {
        let fileName = "pressureData.txt"
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        let pressureString = pressureData.map { "\($0)" }.joined(separator: "\n")
        
        do {
            try pressureString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Pressure data saved: \(fileURL)")
        } catch {
            print("Failed to save pressure data")
        }
    }
}
