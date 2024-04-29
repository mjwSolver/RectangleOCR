//
//  ViewController.swift
//  RectangularOCR
//
//  Created by Marcell JW on 23/04/24.
//

import Vision
import UIKit

class ViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Default Text"
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "example1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemRed
        view.addSubview(label)
        view.addSubview(imageView)
        tapGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 20, 
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-40,
                                 height: view.frame.size.width-40)
        
        label.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemGreen
//        self.view.addSubview(button)
//        self.button.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            button.widthAnchor.constraint(equalToConstant: 200), button.heightAnchor.constraint(equalToConstant: 44),
//        ])
    }

    
    
    // MARK: - Add TapGasture In ImageView
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector (imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // function to extract the numbers from the acquired text
    
    private func recognizeTextFromImage(image: UIImage?){
        
        guard let cgImage = image?.cgImage else {
            fatalError("Failed to Convert to CGImage")
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            
            DispatchQueue.main.async {
                self?.label.text = text
            }
            
        }
        
        
        // MARK: Process Requests
        do {
            try handler.perform([request])
        }
        catch {
            label.text = "\(error)"
        }
        
    }
    

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
}


