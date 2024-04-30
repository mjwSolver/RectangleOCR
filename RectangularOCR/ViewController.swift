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
        label.textAlignment = .center
        label.font.withSize(10)
        label.textColor = .white
        label.text = "Start calculating the area of your rectangle!"
        return label
    }()
    
    private let importImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .medium
        
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        
        config.imagePadding = 5
        config.image = UIImage(systemName: "square.and.arrow.up.on.square")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, 
                                                                                  weight: .medium,
                                                                                  scale: .default)
        
        config.attributedTitle = "Import an Image"
        
        button.configuration = config
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photographer-bg-3x")
        
        return imageView
    }()
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(importImageButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        label.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 300)
        
        
        // MARK: Go to recognize textview after pressing the image button
        self.importImageButton.addTarget(self, action: #selector(imageTapped), for:.touchUpInside)
        
        importImageButton.frame = CGRect(x: 20,
                                        y: view.frame.size.width + view.safeAreaInsets.top,
                                        width: 190,
                                        height: 55)
        
//        importImageButton.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            importImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            importImageButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            importImageButton.widthAnchor.constraint(equalToConstant: 200), 
//            importImageButton.heightAnchor.constraint(equalToConstant: 44),
//        ])
        
    }
    
    
    @objc func tapImageThenGoToRecognizeTextView() {
        
        imageTapped()
        goToRecognizeTextView()
        
    }
    
    // MARK: - Add TapGasture In ImageView
    @objc func goToRecognizeTextView() {
        let vc = RecognizeTextViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        imageView.image = info[.originalImage] as? UIImage
        var gmbr = imageView.image
        dismiss(animated: true, completion: nil)
    }
    
}

#Preview {
    ViewController()
}

