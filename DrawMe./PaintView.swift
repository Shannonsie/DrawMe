import SwiftUI
import PencilKit
import FirebaseStorage
import FirebaseFirestore
import Photos


struct PaintView: View {
//  Binding for Submission
    @Binding var sessionId: String
    @Binding var uploadPopUp: Bool
    @Binding var emotionStrength: CGFloat
    @Binding var emotionValue: CGFloat
    
    @State private var canvasView = PKCanvasView()
    @State private var tool: PKTool = PKInkingTool(.pen, color: .black, width: 5)
    @State private var selectedColor: Color = .black
    @State private var selectedTool: String = "Pen"
    @State private var customColor: UIColor = UIColor.black
    @State private var finalPage = false
    @State private var pressureData: String = ""
    @State private var lineWidth: CGFloat = 1
    @State private var fileContent = ""
    
    @State private var isSaved = false
    @State private var showError = false
    @State private var successFlag = false
    
    @State private var undoStack: [PKDrawing] = []
    @State private var redoStack: [PKStroke] = []
    
    @State private var strokeCount: Int = 0
    @State private var undoStroke: [Int] = []
    @State private var isUndoRedoAction: Bool = false
    @State private var showClearAlert: Bool = false
    
    @State private var isErrorConnection = false // Tracks if the timeout alert should be shown
    @State private var timer: Timer? // Timer for managing timeout
    @State private var isSubmitting = false // Tracks if the operation is in progress


    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button("Undo") {
                        undoLastStroke()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                    .font(.system(size: geometry.size.width > 500 ? 18:14))
                    
                    Button("Redo"){
                        redoLastStroke()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                    .font(.system(size: geometry.size.width > 500 ? 18:14))
                    
                    Button("Clear All") {
                        showClearAlert = true
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .font(.system(size: geometry.size.width > 500 ? 18:14))
                    
                    Spacer()
                    Button("Finish") {
                        print("Button tapped") // Debugging checkpoint
                        isSubmitting = true
                        startTimeout()

                        submitDrawing { success in
                            isSubmitting = false
                            stopTimeout()
                            
                            if success {
                                successFlag = true // Successfully submitted
                                isErrorConnection = false
                                print("Submit drawing succeeded")
                                
                             
                                finalPage = true
                            } else {
                                print("Fail to submit drawing")
                                showError = true // Show error to the user
                            }
                        }
                        
                        

                        // You can use the successFlag later if needed
                        print("Button action finished")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
                    .fullScreenCover(isPresented: $finalPage, content: {
                        FinalPage(sessionId: $sessionId)
                        
                    })
                    
                }
                .padding()
                
                CanvasView(canvas: $canvasView, onDrawingChanged: {
                    printPressureData()
                }, isErrorConnection: isErrorConnection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear{
                  canvasView.drawingPolicy = .pencilOnly
                }
                
                
                
                HStack {
                    ForEach([Color.black, Color.red, Color.blue, Color.green, Color.yellow, Color.purple], id: \.self) { color in
                        Button(action: {
                            selectedColor = color
                            customColor = UIColor(color)
                            updateTool(to: lineWidth)
                        }) {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 0)
                                )
                        }
                    }
                    
                    ColorPicker("Custom Color", selection: $selectedColor, supportsOpacity: true)
                        .onChange(of: selectedColor) { newColor in
                            customColor = UIColor(newColor)
                            updateTool(to: lineWidth)
                        }
                        .labelsHidden()
                        .frame(width: 50, height: 50)
                    
                }
                .padding()
                
                
                
                if (geometry.size.width > 500){
                    HStack {
                        Button("Pencil") {
                            tool = PKInkingTool(.pencil, color: customColor.withAlphaComponent(0.7), width: lineWidth + 5)
                            canvasView.tool = tool
                            selectedTool = "Pencil"
                        }
                        .padding()
                        .background(selectedTool == "Pencil" ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Button("Pen") {
                            tool = PKInkingTool(.pen, color: customColor, width: lineWidth + 5) // Pen tool
                            canvasView.tool = tool
                            selectedTool = "Pen"
                        }
                        .padding()
                        .background(selectedTool == "Pen" ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Button("Marker") {
                            tool = PKInkingTool(.marker, color: customColor, width: lineWidth + 10) // Marker tool
                            canvasView.tool = tool
                            selectedTool = "Marker"
                        }
                        .padding()
                        .background(selectedTool == "Marker" ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Button("Eraser") {
                            tool = PKEraserTool(.vector)
                            canvasView.tool = tool
                            selectedTool = "Eraser"
                        }
                        .padding()
                        .background(selectedTool == "Eraser" ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Slider(value: $lineWidth, in: 1...40, step: 2)
                            .frame(width: geometry.size.width > 500 ? 320 : 100)
                            .padding(.horizontal)
                            .onChange(of: lineWidth){ newWidth in
                                updateTool(to: newWidth)
                            }
                        
                    }.padding()
                } else {
                    VStack {
                        HStack{
                            Button("Pencil") {
                                tool = PKInkingTool(.pencil, color: customColor.withAlphaComponent(0.7), width: lineWidth + 5)
                                canvasView.tool = tool
                                selectedTool = "Pencil"
                            }
                            .padding()
                            .background(selectedTool == "Pencil" ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .font(.system(size: 14))
                            
                            Button("Pen") {
                                tool = PKInkingTool(.pen, color: customColor, width: lineWidth + 5) // Pen tool
                                canvasView.tool = tool
                                selectedTool = "Pen"
                            }
                            .padding()
                            .background(selectedTool == "Pen" ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .font(.system(size: 14))
                            
                            Button("Marker") {
                                tool = PKInkingTool(.marker, color: customColor, width: lineWidth + 10) // Marker tool
                                canvasView.tool = tool
                                selectedTool = "Marker"
                            }
                            .padding()
                            .background(selectedTool == "Marker" ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .font(.system(size: 14))
                            
                            Button("Eraser") {
                                tool = PKEraserTool(.vector)
                                canvasView.tool = tool
                                selectedTool = "Eraser"
                            }
                            .padding()
                            .background(selectedTool == "Eraser" ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .font(.system(size: 14))
                        }
                        .padding()
                        
                        Slider(value: $lineWidth, in: 1...40, step: 2)
                            .frame(width: geometry.size.width > 500 ? 320 : 300)
                            .padding(.horizontal)
                            .onChange(of: lineWidth){ newWidth in
                                updateTool(to: newWidth)
                            }
                        
                    }.padding()
                }
      
                
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Failed to upload the data, please check your internet connection.")
            }
            .alert("This will erase all your drawings. Are you sure you want to continue?", isPresented: $showClearAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear All", role: .destructive) {
                    clearAllStrokes()
                }
            }
            
            if isSubmitting {
                          Color.black.opacity(0.4)
                              .ignoresSafeArea()
                          
                          VStack {
                              ProgressView("Uploading...")
                                  .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                  .padding()
                                  .background(Color.black.opacity(0.8))
                                  .cornerRadius(10)
                                  .foregroundColor(.white)
                          }
                          .frame(maxWidth: .infinity, maxHeight: .infinity)
                          .background(Color.clear)
                      }
        }
    }
        

    private func updateTool(to width: CGFloat) {
        if let inkingTool = tool as? PKInkingTool {
            let updateTool = PKInkingTool(inkingTool.inkType, color: customColor, width: width)
            tool = updateTool
            canvasView.tool = updateTool
        }
    }

    private func undoLastStroke() {
        var currentDrawing = canvasView.drawing
        if !currentDrawing.strokes.isEmpty {
            isUndoRedoAction = true
            let lastStroke = currentDrawing.strokes.removeLast()
            redoStack.append(lastStroke)
            canvasView.drawing = currentDrawing
            
            pressureData += "Undo pressed: Stroke \(strokeCount) removed \n"
            strokeCount -= 1
            isUndoRedoAction = false
        }
    }
    
    private func redoLastStroke(){
        guard !redoStack.isEmpty else { return }
        isUndoRedoAction = true
        let lastRedoStroke = redoStack.removeLast()
        
        var currentDrawing = canvasView.drawing
        currentDrawing.strokes.append(lastRedoStroke)
        canvasView.drawing = currentDrawing
        
        strokeCount += 1
        pressureData += "Redo pressed: Stroke \(strokeCount) restored \n"
        isUndoRedoAction = false
    }
    
    private func clearAllStrokes() {
        undoStack.append(canvasView.drawing)
        canvasView.drawing = PKDrawing()
        pressureData += "\nAll Strokes Cleared\n"
        strokeCount = 0
    }

    private func printPressureData() {
        let drawing = canvasView.drawing
        guard let lastStroke = drawing.strokes.last else { return }
        guard !isUndoRedoAction else { return }
        
        redoStack.removeAll()
        
        strokeCount += 1
        var strokeLog = "Stroke \(strokeCount): \n"
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YY-MM-dd HH:mm:ss.SSS"
        
        for point in lastStroke.path {
            let timestamp = dateFormat.string(from: Date())
            strokeLog += "[\(timestamp) Location: \(point.location), Pressure: \(point.force)]\n"
        }
        
        strokeLog += "\n"
        pressureData += strokeLog
        print(strokeLog)
    }
    
    func startTimeout() {
        // Start a timer that fires after 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            if isSubmitting {
                showError = true
                isSubmitting = false
                isErrorConnection = true
                print("Timeout occurred")
            }
        }
    }

    func stopTimeout() {
        timer?.invalidate()
        timer = nil
    }
    
    private func submitDrawing(completion: @escaping (Bool) -> Void) {
        guard let window = UIApplication.shared.windows.first else {
            DispatchQueue.main.async {
                showError = true
            }
            return
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            let canvasBounds = canvasView.bounds
           let renderer = UIGraphicsImageRenderer(bounds: canvasBounds)
           let image = renderer.image { context in
               canvasView.layer.render(in: context.cgContext)
           }
            
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        isSaved = true
                    default:
                        showError = true
                        return
                    }
                }
            }

            guard let imageData = image.pngData() else {
                DispatchQueue.main.async {
                    showError = true
                }
                return
            }
            
            uploadPhoto(imageData: imageData, completion: completion)
        }
    }
    
    private func showErrorMessage(_ message: String){
        showError = true
    }
    
    private func saveFireStoreUpdateOffline(sessionId: String, imageUrl: String, pressureData: String){
        let updateData = ["sessionId": sessionId, "imageUrl": imageUrl, "pressureData": pressureData]
        UserDefaults.standard.set(updateData, forKey: "pendingFirestoreUpdate")
        print("Saved Firestore update locally for retry")
    }
    
    
    func uploadPhoto(imageData: Data, completion: @escaping (Bool) -> Void) {
        let storageRef = Storage.storage().reference()

        let fileName = "images/\(sessionId)_Value:\(emotionValue)_Strength:\(emotionStrength).png"
        let fileRef = storageRef.child(fileName)

        let filePress = "pressure/\(sessionId)_Value:\(emotionValue)_Strength:\(emotionStrength)_PressureData.txt"
        let filePRef = storageRef.child(filePress)
        
        guard let pressureData = pressureData.data(using: .utf8) else {
            DispatchQueue.main.async {
                showError = true
            }
            return
        }
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        filePRef.putData(pressureData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading pressure data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    showError = true
                }
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fileRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    showError = true
                }
            }
            dispatchGroup.leave()
        }
        
        saveFireStoreUpdateOffline(sessionId: sessionId, imageUrl: fileName, pressureData: filePress)
    
        dispatchGroup.notify(queue: .main) {
            let db = Firestore.firestore()
            db.collection("sessions").whereField("sessionId", isEqualTo: sessionId).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        showError = true
                    }
                    
                    
                    completion(false)
                    return
                }

                if let document = snapshot?.documents.first {
                    document.reference.updateData([
                        "imageUrl": fileName,
                        "pressureUrl": filePress
                    ]) { error in
                        if let error = error {
                            print("Error updating Firestore session: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                showError = true
                            }
                            completion(false)
                            return
                        } else {
                            print("Image URL saved to session successfully.")
                            completion(true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        showError = true
                    }
                    completion(false)
                }
            }
        }
    }
    
}

#Preview{
    PaintView(sessionId: .constant(""), uploadPopUp: .constant(false), emotionStrength: .constant(2.0), emotionValue: .constant(2.0))
}

