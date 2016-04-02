//
//  BkgLocator.swift
//  MagnitGeo
//
//  Created by Круцких Олег on 30.03.16.
//  Copyright © 2016 Круцких Олег. All rights reserved.
//

import UIKit
import CoreLocation

class BkgLocator: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var coordUpdating = false
    var cnt = 0
    var timer: NSTimer?
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func start(){
        timer = NSTimer.scheduledTimerWithTimeInterval(5 , target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    func stop(){
        timer?.invalidate()
        timer = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) ->
            Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                if self.coordUpdating {
                    let pm = placemarks![0] as CLPlacemark
                    print("Location updated \(self.cnt)!")
                    self.cnt += 1
                    self.displayLocationInfo(pm)
                    self.coordUpdating = false
                }
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        if let loc = placemark.location?.coordinate {
            sendCoord("http://www.arduino-test.h1n.ru/magnit.php/?long=\(loc.longitude)&lat=\(loc.latitude)")
            print(loc)
        }
        
    }
    
    func update() {
        self.coordUpdating = true
        locationManager.startUpdatingLocation()
    }
    
    func sendCoord(urlStr:String)
    {
        
        let session = NSURLSession.sharedSession()
        let url : NSURL = NSURL(string: urlStr)!
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            print("Coord sended.")
            if((error) != nil) {
                print(error!.localizedDescription)
                return
            }
            
        })
        task.resume()
        
    }
}
