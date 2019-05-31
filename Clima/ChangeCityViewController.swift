//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Ashwani  Agrawal on 25/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import UIKit


// protocol declaration:

protocol cityChangedDelegate {
    func userEnteredCity(city : String)
}


class ChangeCityViewController: UIViewController {
    
    // This is the IBAction that gets called when the user swipes down the screen:
    
    @IBAction func swipedBack(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var delegate: cityChangedDelegate?
    
    // IBOutlets to the text field
    
    @IBOutlet weak var changeCityTextField: UITextField!

    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        let cityEntered = changeCityTextField.text!
        
        delegate?.userEnteredCity(city: cityEntered)
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
