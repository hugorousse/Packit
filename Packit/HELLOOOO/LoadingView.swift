import Foundation
import SwiftUI
 
struct LoadingView: View {
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                SplashScreenView()
            } else {
                ContentView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                // Remplacer 2.0 par le nombre de secondes que vous voulez que l'écran de lancement soit visible
                isLoading = false
            }
        }
    }
}
