//
//  MLViewController.swift
//  ARtestApp
//
//  Created by Arnold Rebello on 8/18/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import CoreML
import Vision


class MLViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    @IBOutlet weak var DisplayImages: UIImageView!
    
      let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let userPickedImage = info[.originalImage] as? UIImage {
               DisplayImages.image = userPickedImage
           
           guard let ciimage = CIImage(image: userPickedImage) else {
               fatalError("Could not convert UIImage into CIImage")
           }
           detect(image: ciimage)
           }
           imagePicker.dismiss(animated: true, completion: nil)
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func detect(image: CIImage) {
    
    guard let model = try? VNCoreMLModel(for: FireandFloods_1().model) else {
        fatalError("Loading CoreML Model Failed.")
    }
    let request = VNCoreMLRequest(model: model) { (request, error) in
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Model failed to process image.")
        }
        print(results)
       if let firstResult = results.first{
           if firstResult.identifier.contains("Fire") {
                self.navigationItem.title = "Fire!"
            }else {
                self.navigationItem.title = firstResult.identifier
            }
        }
    }
    let handler = VNImageRequestHandler(ciImage: image)
    do{
    try handler.perform([request])
    }
    catch{
        print(error)
    }
    }
    @IBAction func photos(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)

    }
}
