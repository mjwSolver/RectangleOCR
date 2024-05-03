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
        
//        label.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1.0)
//        label.layer.borderWidth = 2
        return label
    }()
    
    private let importImageButton: UIButton = {
        let button = UIButton()
        
        let contentInsetConstant = 20.0
        
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(
            top: contentInsetConstant,
            leading: contentInsetConstant,
            bottom: contentInsetConstant + 0,
            trailing: contentInsetConstant
        )
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
        var backgroundImage = UIImage(named: "ruler-bg")
        
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
        
        // MARK: Go to recognize textview after pressing the image button
        self.importImageButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        importImageButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Center horizontally
            importImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Set distance from bottom
            importImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84),
            // Set width
            importImageButton.widthAnchor.constraint(equalToConstant: 190),
            // Set height
//            importImageButton.heightAnchor.constraint(equalToConstant: 60),
            
            label.bottomAnchor.constraint(equalTo: importImageButton.topAnchor, constant: -16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.widthAnchor.constraint(equalToConstant: view.frame.size.width-60),
//            label.heightAnchor.constraint(equalToConstant: 70)
            
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let vc = RecognizeTextViewController()
        vc.selectedImage = theSelectedImage
        vc.modalPresentationStyle = .fullScreen
        // Works as intended when fully running, not in preview
        self.navigationController?.pushViewController(vc, animated: true)
//        // This lets you somewhat preview it later
//        present(vc, animated: true)
        
    }
    
}

#Preview {
    ViewController()
}
