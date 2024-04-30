//
//  RecognizeTextViewController.swift
//  RectangularOCR
//
//  Created by Marcell JW on 29/04/24.
//

import Vision
import UIKit

class RecognizeTextViewController: UIViewController {

    private let selectedImage: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    private let extractedDimensionsTitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let extractedDimensionsLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let calculatedAreaTitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let calculatedAreaLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setUpUI()
        
        
    }

    
    private func setUpUI(){
        self.view.addSubview(selectedImage)
        
        self.view.addSubview(extractedDimensionsTitleLabel)
        self.view.addSubview(extractedDimensionsLabel)
        
        self.view.addSubview(calculatedAreaTitleLabel)
        self.view.addSubview(calculatedAreaLabel)
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
