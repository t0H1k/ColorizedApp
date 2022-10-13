//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Anton Boev on 11.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var colorView: UIView! {
        didSet { colorView.layer.cornerRadius = 15 }
    }
    
    @IBOutlet var doneButton: UIButton! {
        didSet { doneButton.layer.cornerRadius = 15 }
    }
    
    
    @IBOutlet var colorValueLabels: [UILabel]!
    @IBOutlet var colorSliders: [UISlider]!
    @IBOutlet var colorValueTextField: [UITextField]!
    
    
    // MARK: - Public var
    var colorOfView: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in colorValueTextField {
            textField.delegate = self
        }
        
        colorView.layer.cornerRadius = 15
        navigationItem.hidesBackButton = true
        
        colorView.backgroundColor = colorOfView
        
        setColorValue(accordingTo: getRGBColorValues(from: colorOfView))
        setViewColor()
    }
    
    
    // MARK: - IBAction
    @IBAction func doneButtonPressed() {
        if let passingColor = colorView.backgroundColor {
            delegate.setNewColor(by: passingColor)
        }
        dismiss(animated: true)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setViewColor()
        setSliderValues(for: sender.tag, from: sender)
    }
}

    // MARK: - Private func
extension SettingsViewController {
    
    private func setViewColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(colorSliders[0].value),
            green: CGFloat(colorSliders[1].value),
            blue: CGFloat(colorSliders[2].value),
            alpha: 1
        )
    }
    
    private func setColorValue(accordingTo colors: [CGFloat]) {
        for (color, slider) in zip(colors, colorSliders) {
            slider.setValue(Float(color), animated: true)
        }
        
        for (label, slider) in zip(colorValueLabels, colorSliders) {
            label.text = getColorValue(from: slider)
        }
        
        for (textField, slider) in zip(colorValueTextField, colorSliders) {
            textField.text = getColorValue(from: slider)
        }
    }
    
    private func setSliderValues(for tag: Int, from slider: UISlider) {
        colorValueLabels[tag].text = getColorValue(from: slider)
        colorValueTextField[tag].text = getColorValue(from: slider)
        
    }
    
    private func setTextFieldValue(for tag: Int, from textField: UITextField) {
        colorValueLabels[tag].text = textField.text
        if let text = textField.text {
            if let text = Float(text) {
                colorSliders[tag].value = text
            }
        }
    }
    
    private func getRGBColorValues(from color: UIColor) -> [CGFloat] {
        let redComponent = CIColor(color: color).red
        let greenComponent = CIColor(color: color).green
        let blueComponent = CIColor(color: color).blue
        
        return [redComponent, greenComponent, blueComponent]
    }
    
    private func getColorValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard getValidResult(for: isValid(value: textField)) else {
            textField.text = nil
            return }
        setTextFieldValue(for: textField.tag, from: textField)
        setViewColor()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        textField.inputAccessoryView = keyboardToolBar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
            )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolBar.items = [doneButton, flexBarButton]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        replaceCommaToDot(for: string, in: textField)
    }
    
    private func replaceCommaToDot(for string: String, in tf: UITextField) -> Bool {
        if string == "," {
            guard let text = tf.text else { return true }
            tf.text = text + "."
            return false
        }
        return true
    }
    
    
    private func getValidResult(for value: Bool) -> Bool {
        guard value else {
            showAlert(title: "Error", message: "Enter a value from 0.00 to 1.00")
            return false
        }
        return true
    }
    
    private func isValid(value: UITextField) -> Bool {
        guard let validString = value.text else { return false }
        guard let validNumber = Double(validString) else { return false}
        guard validNumber.description.count <= 4 else { return  false }
        guard validNumber >= 0 && validNumber <= 1.0 else { return false }
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
