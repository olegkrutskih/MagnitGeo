//
//  ViewController.swift
//  MagnitGeo
//
//  Created by Круцких Олег on 29.03.16.
//  Copyright © 2016 Круцких Олег. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func findMyLocation(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
            if appDelegate.isWorking {
                (sender as! UIButton).setTitle("Запустить", forState: UIControlState.Normal)
                appDelegate.bkgLocator?.stop()
            }
            else {
                (sender as! UIButton).setTitle("Остановить", forState: UIControlState.Normal)
                appDelegate.bkgLocator?.start()
            }
            appDelegate.isWorking = !appDelegate.isWorking
        }
        else {
            let AlertController = UIAlertController(title: "Получение геопозиции запрещено настройками", message: "Для включения, пожалуйста перейдите в Настройки -> Конфиденциальность -> Службы геолокации -> MagnitGeo и установите флажок напротив пункта 'Всегда'", preferredStyle: UIAlertControllerStyle.Alert)
            
            //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) // vibration
            AlertController.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(AlertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

