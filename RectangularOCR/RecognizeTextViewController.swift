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
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16.0
        return image
    }()
    
    private let extractedDimensionsTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
//        label.font.withSize(15)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "Extracted Dimensions"
        return label
    }()
    
    private let extractedDimensionsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
//        label.font.withSize(23)
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.text = "? X ?"
        
        return label
    }()
    
    private let calculatedAreaTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font.withSize(15)
        label.text = "Calculated Area"
        return label
    }()
    
    private let calculatedAreaLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        
        let leftMargin = 20.0
        let standardWidth = view.frame.size.width - leftMargin*2
        
        let selectedImageIsValid = selectedImage != nil
        selectedImageView.image = selectedImageIsValid ? selectedImage : UIImage(named: "photographer-bg")
        
        if(selectedImageIsValid) {
            try? recognizeTextFromImage(image: selectedImage)
        }
        
        self.view.addSubview(selectedImageView)
        selectedImageView.frame = CGRect(x: 20,
                                         y: 100,
                                         width: standardWidth,
                                         height: 250)
        
        self.view.addSubview(extractedDimensionsTitleLabel)
        extractedDimensionsTitleLabel.frame = CGRect(x: 20,
                                                     y: 400,
                                                     width: standardWidth,
                                                     height: 50)
        
        extractedDimensionsTitleLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1.0)
        extractedDimensionsTitleLabel.layer.borderWidth = 2
        
        self.view.addSubview(extractedDimensionsLabel)
        extractedDimensionsLabel.frame = CGRect(x: 20,
                                                 y: 428,
                                                 width: standardWidth,
                                                 height: 50)
        
        self.view.addSubview(calculatedAreaTitleLabel)
        calculatedAreaTitleLabel.frame = CGRect(x: 20,
                                             y: 500,
                                             width: standardWidth,
                                             height: 50)
        
        self.view.addSubview(calculatedAreaLabel)
        calculatedAreaLabel.frame = CGRect(x: 20,
                                             y: 528,
                                             width: standardWidth,
                                             height: 50)
        
    }
    
    // MARK: RecognizeTextFromImage
    /// Recognizes the Text from the Image.
    /// If the texts is far apart, it will be merged together
    
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
            }).joined(separator: "; ")
            
            let ArrayOfTexts = text.components(separatedBy: "; ")
            
            DispatchQueue.main.async {
                // MARK: Associate a Label for Recognizing the Text
                self?.extractedDimensionsLabel.text = text
            }
            
        }
        
        // MARK: Process Requests
        do {
            try handler.perform([request])
        }
        catch {
            // MARK: Associate a Label for Recognizing the Text
            extractedDimensionsLabel.text = "\(error)"
        }
        
    }
    

}

#Preview {
    RecognizeTextViewController()
}
