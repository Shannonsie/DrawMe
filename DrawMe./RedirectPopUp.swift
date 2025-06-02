import SwiftUI
import UserNotifications

struct RedirectPopUp: View {
    @Binding var showingPopup: Bool
    @Binding var sessionId: String
    @Binding var emotionValue: CGFloat
    @Binding var emotionStrength: CGFloat
    
    @StateObject var dataManager = DataManager()
    @State private var navigateToUploadView = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                ZStack {
                    Color.black.opacity(0)
                        .ignoresSafeArea()
                    
                    VStack {
                        // Header Text Section
                        VStack(spacing: 8) {
                            Text("Let’s express your feelings through creative drawing!")
                                .font(.custom("Poppins-Regular", size: geometry.size.width > 600 ? 30 : 20))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                                .fontWeight(.semibold)
                            
                            Text("We're taking you to our **canvas**, where you can let your imagination run wild.")
                                .font(.custom("Poppins-Regular", size: 16))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Image("writing-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width > 600 ? 320 : 210,
                                       height: geometry.size.width > 600 ? 280 : 140)
                                .padding(.top, 16)
                            
                            
                            
                        }
                        .padding(.top, geometry.size.width > 600 ? 36 : 24)
                        
                        
                        // Buttons Section
                        HStack(spacing: 16) {
                            // Cancel Button
                            Button(action: {
                                showingPopup = false
                                print("showingPopUp false")
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.black)
                                    .font(.custom("Poppins-Regular", size: geometry.size.width > 600 ? 24 : 18))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            
                            // Start Now Button
                            Button(action: {
                                navigateToUploadView = true
                            }) {
                                Text("Start now!")
                                    .foregroundColor(.white)
                                    .font(.custom("Poppins-Regular", size: geometry.size.width > 600 ? 24 : 18))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, geometry.size.width > 600 ? 48 : 24)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(geometry.size.width > 600 ? 40 : 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .frame(maxWidth: geometry.size.width > 600 ? 700 : geometry.size.width - 40) // Adaptive width
                    .frame(height: geometry.size.width > 600 ? 400 : 400)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .contentShape(Rectangle()) // Ensures proper tap handling
            }
            .fullScreenCover(isPresented: $navigateToUploadView) {
                PaintView(sessionId: $sessionId, uploadPopUp: $navigateToUploadView, emotionStrength: $emotionStrength, emotionValue: $emotionValue)
            }
        }
    }
}

#Preview {
    RedirectPopUp(
        showingPopup: .constant(true),
        sessionId: .constant("testXcode"),
        emotionValue: .constant(2.0),
        emotionStrength: .constant(3.0)
    )
}
