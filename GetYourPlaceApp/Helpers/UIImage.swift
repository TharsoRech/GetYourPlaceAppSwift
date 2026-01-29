import UIKit

extension UIImage {
    
    func toBase64(compressionQuality: CGFloat = 0.8) -> String? {
         // Converte para JPEG (menor tamanho) ou use .pngData() para sem perdas
         return self.jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
     }

}
