//
//  ConversionViewController.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var fahrenheitValue: Double? {
        didSet {
            self.updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let validFahrenheitValue = self.fahrenheitValue {
            return self.convertToCelsiusFromFahrenheit(validFahrenheitValue)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var fahrenheitTextField: UITextField!
    
    // MARK: - IBAction Methods
    
    @IBAction func fahrenheitTextFieldEditingChanged(textfield: UITextField) {
        guard let validTextFieldText = textfield.text where !validTextFieldText.isEmpty, let doubleValue = Double(validTextFieldText) else {
            self.fahrenheitValue = nil
            return
        }
        self.fahrenheitValue = doubleValue
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.fahrenheitTextField.resignFirstResponder()
    }
    
    // MARK: - Helper Methods

    private func convertToCelsiusFromFahrenheit(value: Double) -> Double {
        return (value - 32) * (5 / 9)
    }
    
    private func updateCelsiusLabel() {
        if let validCelsiusValue = self.celsiusValue {
            self.celsiusLabel.text = self.numberFormatter.stringFromNumber(validCelsiusValue)
        }
        else {
            self.celsiusLabel.text = "???"
        }
    }
}