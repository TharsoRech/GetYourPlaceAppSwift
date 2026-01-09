import UIKit

extension String {
    /// Busca uma imagem nos Assets com este nome e converte para Base64
    var asAssetBase64: String {
        guard let image = UIImage(named: self),
              let data = image.jpegData(compressionQuality: 0.7) else {
            return ""
        }
        return data.base64EncodedString()
    }
}
