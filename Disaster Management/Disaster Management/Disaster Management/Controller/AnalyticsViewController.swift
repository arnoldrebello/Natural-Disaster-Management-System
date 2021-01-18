//
//  FifthViewController.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/7/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit
import MapKit
class AnalyticsViewController: UIViewController{
    
    var analyticsManager = AnalyticsManager()
    var coordinates: [fireCoordinates] = []
    var fireFileURL:URL?
    var elementName:String = String()
    var parser: XMLParser?
    var coordinate:[String] = []
    var requiredString: String?
    var i = 0
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var fireMap: MKMapView!
    @IBOutlet weak var citySelector: UIPickerView!
    fileprivate let myLocation:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        fireMap.mapType = MKMapType.hybridFlyover
//        fireMap.delegate = self
        myLocation.requestWhenInUseAuthorization()
        myLocation.desiredAccuracy = kCLLocationAccuracyBest
        myLocation.distanceFilter = kCLDistanceFilterNone
        myLocation.startUpdatingLocation()
        citySelector.dataSource = self
        citySelector.delegate = self
        fireMap.showsUserLocation = true
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func parseXML(url: URL){
        if let path = fireFileURL
        {
            if let parser = XMLParser(contentsOf: path)
            {
                print("it is parsing")
                parser.delegate = self
                parser.parse()
                print(coordinates)
            }
        }
    }
    
   
    
    
    func plotMap(plotArray:[fireCoordinates]){
        
        for i in 0...plotArray.count-1
        { print(i)
            self.i+=1
            let plot = MKPointAnnotation()
            plot.coordinate = CLLocationCoordinate2D(latitude: plotArray[i].latitude, longitude: plotArray[i].longitude )
            fireMap.addAnnotation(plot)

        }
    }
    
}

extension AnalyticsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return analyticsManager.pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: analyticsManager.pickerData[row].region, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return analyticsManager.pickerData[row].region
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRegion = analyticsManager.pickerData[row].region
        print(selectedRegion)
        fireMap.removeAnnotations(fireMap.annotations)
        coordinates = []
        
        guard let url = URL(string: analyticsManager.pickerData[row].fileURL) else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        self.loadingLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            self.loadingLabel.isHidden = true
        }
    }
    
}

extension AnalyticsViewController:  URLSessionDownloadDelegate {
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.fireFileURL = destinationURL
            print(destinationURL)
            coordinates.removeAll()
            parseXML(url: fireFileURL!)
            do {
                try FileManager.default.removeItem(at: destinationURL)
                print("file Deleted")
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
            print("location extracted")
            plotMap(plotArray: coordinates)
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

extension AnalyticsViewController: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        print("parsing started...")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        requiredString = elementName
        if elementName == "Point"
        {
//            print("start element name:", elementName)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if(!data.isEmpty){
            
            if requiredString == "coordinates"
            {
                let parts = data.components(separatedBy: ",")
                let firecoordinate = fireCoordinates(latitude: (parts[1] as NSString).doubleValue , longitude: (parts[0] as NSString).doubleValue)
                self.coordinates.append(firecoordinate)

        }
    }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Point"
        {
//            print("end element name:", elementName)
        }
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("parsing ended")
    }
    
    
}


extension AnalyticsViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
               if !(annotation is MKPointAnnotation) {
                   return nil
               }
               
               let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
               
               if annotationView == nil {
                   annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                   annotationView!.canShowCallout = true
               }
               else {
                   annotationView!.annotation = annotation
               }
               
               let pinImage = UIImage(named: "flame")
               annotationView!.image = pinImage
        
              return annotationView
           }
    
}
