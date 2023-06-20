import Foundation
import SwiftUI
 
struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image("Packit_logo") // Remplacez "logo" par le nom de votre image dans l'Asset Catalog
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
    }
}
