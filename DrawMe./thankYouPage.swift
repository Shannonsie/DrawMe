import SwiftUI

struct thankYouPage: View {
    @State private var homePage = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                VStack{
                    Text("Thank you! Your drawing has been saved.")
                        .font(.custom("Poppins-Regular", size: 24))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("See you on your next session")
                        .font(.custom("Poppins-Regular", size: 20))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .padding(.top, 32)
                
                Spacer()
                
                
                Image("sketch")
                    .resizable()
                    .frame(width: geometry.size.width > 500 ? 490 : 280, height: geometry.size.width > 500 ? 420 : 210)
                
                Spacer()
                
                Button(action: {
                    homePage = true
                    
                }){
                    Text("Back to Home Screen")
                        .font(.custom("Poppins-Regular", size: geometry.size.width > 500 ? 24 : 16))
                        .fontWeight(.semibold)
                        .padding(20)
                        .padding(.horizontal, geometry.size.width > 500 ? 88 : 44)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(geometry.size.width > 500 ? 60 : 30)
                .fullScreenCover(isPresented: $homePage) {
                    HomePage()
                }
                
                Spacer()
            }
            .scaleEffect(geometry.size.width > 500 ? 1.0 : 0.9)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    }
    


#Preview {
    thankYouPage()
}
