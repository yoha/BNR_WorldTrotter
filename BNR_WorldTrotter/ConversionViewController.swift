//
//  ConversionViewController.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Stored Properties
    
    let lowercaseLetterCharacters = NSCharacterSet.lowercaseLetterCharacterSet()
    let uppercaseLetterCharacters = NSCharacterSet.uppercaseLetterCharacterSet()

    // property observer
    var fahrenheitValue: Double? {
        didSet {
            self.updateCelsiusLabel()
        }
    }
    
    // computed property
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
        guard let validTextFieldText = textfield.text where !validTextFieldText.isEmpty, let validValue = numberFormatter.numberFromString(validTextFieldText) else {
            self.fahrenheitValue = nil
            return
        }
        self.fahrenheitValue = validValue.doubleValue
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.fahrenheitTextField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentLocale = NSLocale.currentLocale()
        guard let decimalSeparator = currentLocale.objectForKey(NSLocaleDecimalSeparator) as? String else { return false }
        guard let validText = textField.text else { return false }
        guard string.rangeOfCharacterFromSet(self.lowercaseLetterCharacters) == nil else { return false }
        guard string.rangeOfCharacterFromSet(self.uppercaseLetterCharacters) == nil else { return false }
        if validText.rangeOfString(decimalSeparator) != nil {
            guard let validDecimalSeparator = decimalSeparator.characters.first where !string.characters.contains(validDecimalSeparator) else { return false }
        }
        return true
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