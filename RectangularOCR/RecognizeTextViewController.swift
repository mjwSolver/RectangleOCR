//
//  RecognizeTextViewController.swift
//  RectangularOCR
//
//  Created by Marcell JW on 29/04/24.
//

import Vision
import UIKit

class RecognizeTextViewController: UIViewController {
    
    var selectedImage: UIImage?
    
    private let selectedImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photographer-bg")
        
        return image
    }()
    
    private let extractedDimensionsTitleLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(15)
        label.text = "Extracted Dimensions"
        return label
    }()
    
    private let extractedDimensionsLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(23)
        label.text = "? X ?"
        return label
    }()
    
    private let calculatedAreaTitleLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(15)
        label.text = "Calculated Area"
        return label
    }()
    
    private let calculatedAreaLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(23)
        label.text = "? meter"
        return label
    }()
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpUI()
        
        
    }
    
    private func setUpUI(){
        
        self.view.addSubview(selectedImageView)
        selectedImageView.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
        
        self.view.addSubview(extractedDimensionsTitleLabel)
        extractedDimensionsTitleLabel.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
        
        self.view.addSubview(extractedDimensionsLabel)
        extractedDimensionsLabel.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
        
        self.view.addSubview(calculatedAreaTitleLabel)
        calculatedAreaTitleLabel.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
        
        self.view.addSubview(calculatedAreaLabel)
        calculatedAreaLabel.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)

        
        
    }
    
    // MARK: RecognizeTextFromImage
    
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
                // MARK: Associate a Label for Recognizing the Text
//                self?.label.text = text
            }
            
        }
        
        
        // MARK: Process Requests
        do {
            try handler.perform([request])
        }
        catch {
            // MARK: Associate a Label for Recognizing the Text
//            label.text = "\(error)"
        }
        
    }
    

}

#Preview {
    RecognizeTextViewController()
}
