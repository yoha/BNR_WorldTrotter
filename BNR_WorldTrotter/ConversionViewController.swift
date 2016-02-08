//
//  ConversionViewController.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var fahrenheitTextField: UITextField!
    
    // MARK: - IBAction Methods
    
    @IBAction func fahrenheitTextFieldEditingChanged(textfield: UITextField) {
        guard let validTextFieldText = textfield.text where !validTextFieldText.isEmpty else {
            celsiusLabel.text = "???"
            return
        }
        self.celsiusLabel.text = validTextFieldText
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.fahrenheitTextField.resignFirstResponder()
    }
}