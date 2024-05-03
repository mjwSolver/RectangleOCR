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
        label.font = UIFont.systemFont(ofSize: 18, weight: .thin)
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .thin)
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
    
    private let doneButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = "Done"
        
        config.buttonSize = .large
        config.cornerStyle = .medium
        
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        
        button.configuration = config
        
        return button
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
        selectedImageView.image = selectedImageIsValid ? selectedImage : UIImage(named: "ruler-bg")
        
        if(selectedImageIsValid) {
            recognizeTextFromImage(image: selectedImage)
        }
        
        self.view.addSubview(selectedImageView)
        self.view.addSubview(extractedDimensionsTitleLabel)
        self.view.addSubview(extractedDimensionsLabel)
        self.view.addSubview(calculatedAreaTitleLabel)
        self.view.addSubview(calculatedAreaLabel)
        self.view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        extractedDimensionsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        extractedDimensionsLabel.translatesAutoresizingMaskIntoConstraints = false
        calculatedAreaTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        calculatedAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            selectedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            selectedImageView.widthAnchor.constraint(equalToConstant: standardWidth),
            selectedImageView.heightAnchor.constraint(equalToConstant: 250),
            
            extractedDimensionsTitleLabel.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 50),
            extractedDimensionsTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            extractedDimensionsLabel.topAnchor.constraint(equalTo: extractedDimensionsTitleLabel.bottomAnchor, constant: 2),
            extractedDimensionsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            calculatedAreaTitleLabel.topAnchor.constraint(equalTo: extractedDimensionsLabel.bottomAnchor, constant: 30),
            calculatedAreaTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            calculatedAreaLabel.topAnchor.constraint(equalTo: calculatedAreaTitleLabel.bottomAnchor, constant: 2),
            calculatedAreaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: standardWidth-60)
        ])
        
    }
    
    @objc func doneButtonTapped(){
        navigationController?.popViewController(animated: true)
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

    /// What if:
    /// - two different unit of measurements?
    ///     - convert meter to centimeter > Multiply by 100
    /// - handling comma values
    ///     - as text we convert it into commas
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
        
        if firstValue.contains(",") {
            firstValue = firstValue.replacingOccurrences(of: ",", with: ".")
        }
        
        if secondValue.contains(",") {
            secondValue = secondValue.replacingOccurrences(of: ",", with: ".")
        }
        
        let convertedFirst = Float(firstValue) ?? 1.0
        let convertedSecond = Float(secondValue) ?? 1.0
        let calculatedArea = convertedFirst * convertedSecond
        
        let firstAndSecondValueAreValid = firstValue != "X" && secondValue != "X"
        let calculatedAreaWithMeasurementUnit = firstAndSecondValueAreValid ? String(calculatedArea) + firstUnit : "? x ?"
        return calculatedAreaWithMeasurementUnit
    }
    
    
    
}

#Preview {
    RecognizeTextViewController()
}
