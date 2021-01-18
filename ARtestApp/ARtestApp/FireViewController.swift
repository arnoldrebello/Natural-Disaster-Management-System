//
//  ViewController.swift
//  Scenekit AR
//
//  Created by Arnold Rebello on 8/10/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreML
import Vision

class FireViewController: UIViewController, ARSCNViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let imagePicker = UIImagePickerController()
    let cameraImage = UIImagePickerController()
    let scene = SCNScene(named: "art.scnassets/fire 2 copy 2.scn")!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        // Show statistics such as fps and timing information
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        cameraImage.delegate = self
        cameraImage.sourceType = .camera
        cameraImage.allowsEditing = false
        // Create a new scene
    
       let tap = UITapGestureRecognizer()
       tap.addTarget(self, action: #selector(didTap))
       sceneView.addGestureRecognizer(tap)
        
        // Set the scene to the view
      
    }
    
    @objc func didTap(_ sender:UITapGestureRecognizer) {
         sceneView.scene = scene
        }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = 
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedimage=info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        
            guard let ciimage = CIImage(image: selectedimage) else {
                fatalError("could not convert UIImage to CIImage")
            }
            detect(image: ciimage)
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: FireandFloods_1().model) else {
            fatalError("loading CoreML Model Failed")
        }
        
       let request = VNCoreMLRequest(model: model) { (request, error) in
       guard let results = request.results as? [VNClassificationObservation] else {
           fatalError("Model failed to process image.")
       }
            print(results)
            
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            }
            catch{
                print(error)
            }
        }
    }
    
    @IBAction func directML(_ sender: UIButton) {
//        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func TakeScreenshot(_ sender: UIButton) {
        present(cameraImage, animated: true, completion: nil)
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration.init()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

