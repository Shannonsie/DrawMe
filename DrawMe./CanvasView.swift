import SwiftUI
import PencilKit


struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    var onDrawingChanged: (() -> Void)? // Callback for drawing changes
    var isErrorConnection: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.delegate = context.coordinator
        canvas.drawingPolicy = .anyInput // Allow both finger and Pencil input
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // No updates needed for now
        if isErrorConnection{
            uiView.isUserInteractionEnabled = false
        } else {
            uiView.isUserInteractionEnabled = true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView

        init(parent: CanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.onDrawingChanged?()
        }
    }
}
