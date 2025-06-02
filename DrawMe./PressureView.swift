import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pressureView = PressureSensitivity(frame: view.bounds)
        pressureView.backgroundColor = .white
        view.addSubview(pressureView)

    }
}
