//
//  ViewController.swift
//  MagnitGeo
//
//  Created by Круцких Олег on 29.03.16.
//  Copyright © 2016 Круцких Олег. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var cnt = 0
    var timer = NSTimer()
    var inProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "update", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func findMyLocation(sender: AnyObject) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
            if inProgress {
                (sender as! UIButton).setTitle("Запустить", forState: UIControlState.Normal)
            }
            else {
                (sender as! UIButton).setTitle("Остановить", forState: UIControlState.Normal)
            }
            inProgress = !inProgress
        }
        else {
            let AlertController = UIAlertController(title: "Получение геопозиции запрещено настройками", message: "Для включения, пожалуйста перейдите в Настройки->Конфиденциальность->Службы геолокации->MagnitGeo и установите флажок напротив пункта 'Всегда'", preferredStyle: UIAlertControllerStyle.Alert)
            
            //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) // vibration
            AlertController.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(AlertController, animated: true, completion: nil)
        }
    }
    
    func update() {
        if inProgress {
            locationManager.startUpdatingLocation()
        }
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) ->
            Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                print("Location updated \(self.cnt)!")
                self.cnt += 1
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
       
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            sendCoord("http://www.arduino-test.h1n.ru/magnit.php/?long=\(placemark.location?.coordinate.longitude)&lat=\(placemark.location?.coordinate.latitude)")
            print(placemark.location?.coordinate)

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

