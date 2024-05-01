//
//  ViewController.swift
//  RectangularOCR
//
//  Created by Marcell JW on 23/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font.withSize(24)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.text = "Start calculating the area of your rectangle!"
        return label
    }()
    
    private let importImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        
        config.baseBackgroundColor = .purple
        config.baseForegroundColor = .white
        
        config.imagePadding = 4
        config.image = UIImage(systemName: "square.and.arrow.up.on.square")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, 
                                                                                  weight: .medium,
                                                                                  scale: .default)
        
        config.attributedTitle = "Import an Image"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .body)
            return outgoing
        }
        
        button.configuration = config
        
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        var backgroundImage = UIImage(named: "photographer-bg-3x")
        
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.image = backgroundImage
        return imageView
    }()
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(backgroundImageView)
        view.addSubview(label)
        view.addSubview(importImageButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 30,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-60,
                             height: 350)
        
        // MARK: Go to recognize textview after pressing the image button
        self.importImageButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        importImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Center horizontally
            importImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Set distance from bottom
            importImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            // Set width
            importImageButton.widthAnchor.constraint(equalToConstant: 190),
            // Set height
            importImageButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        backgroundImageView.frame = CGRect(x: 0, y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height)
        
    }
    
    // MARK: - Add TapGasture In ImageView
    @objc func goToRecognizeTextView() {
        let vc = RecognizeTextViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
        
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) {
        
        let theSelectedImage = info[.originalImage] as? UIImage
        backgroundImageView.image = theSelectedImage
        
        dismiss(animated: true, completion: nil)
        
        let vc = RecognizeTextViewController()
        vc.selectedImage = theSelectedImage
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
}

#Preview {
    ViewController()
}

