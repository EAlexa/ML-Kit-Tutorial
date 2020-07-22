//
//  TextViewController.swift
//  MLKit Starter Project
//
//  Created by Sai Kambampati on 5/20/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import Firebase

class TextViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultView: UITextView!
    let imagePicker = UIImagePickerController()
    lazy var vision = Vision.vision()
    var textDetector: VisionTextRecognizer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        textDetector = vision.onDeviceTextRecognizer()
        
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                   imageView.image = pickedImage
            let visionImage = VisionImage(image: pickedImage)
            self.resultView.text = ""
            textDetector?.process(visionImage, completion: { (features, error) in
                guard error == nil, let features = features else {
                    self.resultView.text = "Could not recognize text"
                    self.dismiss(animated: true, completion: nil)
                    return
                }

                for block in features.blocks {
                    self.resultView.text = self.resultView.text + "\(block.text)"
                }
            })
               }
               dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
