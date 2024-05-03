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
//        label.font.withSize(15)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "Calculated Area"
        return label
    }()
    
    private let calculatedAreaLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
//        label.font.withSize(23)
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.text = "? meter"
        return label
    }()
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The NavigationBar at the top won't work unless
        // Unless you've rendered from the ROOT view controller
        self.navigationItem.title = "Calculated Area"
        self.view.backgroundColor = .white
        setUpUI()
        
    }
    
    private func setUpUI(){
        
        let leftMargin = 20.0
        let standardWidth = view.frame.size.width - leftMargin*2
        
        let selectedImageIsValid = selectedImage != nil
        selectedImageView.image = selectedImageIsValid ? selectedImage : UIImage(named: "photographer-bg")
        
        if(selectedImageIsValid) {
            recognizeTextFromImage(image: selectedImage)
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
        
//        extractedDimensionsTitleLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1.0)
//        extractedDimensionsTitleLabel.layer.borderWidth = 2
        
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
        
//        calculatedAreaTitleLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1.0)
//        calculatedAreaTitleLabel.layer.borderWidth = 2
        
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
            }).joined(separator: " X ")
            
            
            
            let separatedTexts = text.components(separatedBy: " X ")
            
            var firstMeasurement = "?"
            var secondMeasurement = "?"

            if separatedTexts.count >= 1 {
                firstMeasurement = separatedTexts[0]
            }
            if separatedTexts.count >= 2 {
                secondMeasurement = separatedTexts[1]
            }
            
            let calculatedArea = self?.generateCalculatedArea(firstMeasurement: firstMeasurement,
                                                              secondMeasurement: secondMeasurement
            )
            
            
            DispatchQueue.main.async {
                // MARK: Associate a Label for Recognizing the Text
                self?.extractedDimensionsLabel.text = text
                self?.calculatedAreaLabel.text = calculatedArea
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

    private func generateCalculatedArea(firstMeasurement: String, secondMeasurement: String) -> String {
        
        var firstValue = "X"
        var secondValue = "X"
        var firstUnit = " ?"
        
        if let firstWhitespaceIndex = firstMeasurement.firstIndex(of: " ") {
            firstValue = String(firstMeasurement.prefix(upTo: firstWhitespaceIndex))
            firstUnit = String(firstMeasurement.suffix(from: firstWhitespaceIndex))
            
            print("Substring:", firstValue)
        }
        
        if let secondWhitespaceIndex = secondMeasurement.firstIndex(of: " ") {
            secondValue = String(secondMeasurement.prefix(upTo: secondWhitespaceIndex))
            print("Substring:", secondValue)
        }
        
        let convertedFirst = Int(firstValue) ?? 1
        let convertedSecond = Int(secondValue) ?? 1
        let calculatedArea = convertedFirst * convertedSecond
        
        
        let firstAndSecondValueAreValid = firstValue != "X" && secondValue != "X"
        let calculatedAreaWithMeasurementUnit = firstAndSecondValueAreValid ? String(calculatedArea) + firstUnit : "? x ?"
        return calculatedAreaWithMeasurementUnit
    }
    
    
    
}

#Preview {
    RecognizeTextViewController()
}
