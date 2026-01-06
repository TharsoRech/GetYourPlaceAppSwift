import SwiftUICore
import UIKit
extension String {
    func toSwiftUIImage() -> Image? {
        // 1. Decode Base64 string to Data
        guard let data = Data(base64Encoded: self) else { return nil }
        
        // 2. Create UIImage
        guard let uiImage = UIImage(data: data) else { return nil }
        
        // 3. Return SwiftUI Image
        return Image(uiImage: uiImage)
    }
}
