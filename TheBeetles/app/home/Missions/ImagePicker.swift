import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImages: [UIImage]
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
            self.parent.selectedImages = []
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            let group = DispatchGroup()
            var images: [UIImage] = []
            
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let error {
                        print(error.localizedDescription)
                    }
                    if let uiImage = image as? UIImage {
                        images.append(uiImage)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.parent.selectedImages.append(contentsOf: images)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

