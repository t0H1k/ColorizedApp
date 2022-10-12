//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Anton Boev on 11.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    // MARK: - Public var
    var colorOfView: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
    
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        colorView.layer.cornerRadius = 15
        navigationItem.hidesBackButton = true
        
        colorView.backgroundColor = colorOfView
        
        var redColor: CGFloat = 0,
            greenColor: CGFloat = 0,
            blueColor: CGFloat = 0,
            alpha: CGFloat = 0
        colorOfView.getRed(
            &redColor,
            green: &greenColor,
            blue: &blueColor,
            alpha: &alpha
        )
        
        redSlider.value = Float(redColor)
        greenSlider.value = Float(greenColor)
        blueSlider.value = Float(blueColor)
        
        setColor()
        setValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IBAction
    @IBAction func doneButtonPressed() {
        delegate.setNewColor(
            red: redSlider.value,
            green: greenSlider.value,
            blue: blueSlider.value)
        dismiss(animated: true)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        switch sender {
        case redSlider:
            redLabel.text = string(from: sender)
            redTextField.text = string(from: sender)
        case greenSlider:
            greenLabel.text = string(from: sender)
            greenTextField.text = string(from: sender)
        default:
            blueLabel.text = string(from: sender)
            blueTextField.text = string(from: sender)
        }
    }
    
    // MARK: - Private func
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue() {
        redLabel.text = string(from: redSlider)
        greenLabel.text = string(from: greenSlider)
        blueLabel.text = string(from: blueSlider)
        
        redTextField.text = string(from: redSlider)
        greenTextField.text = string(from: greenSlider)
        blueTextField.text = string(from: blueSlider)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

// MARK: - Extension
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue) else { return }
        
        if textField == redTextField {
            redSlider.value = numberValue
            redLabel.text = String(format: "$.2f", numberValue)
        } else if textField == greenTextField {
            greenSlider.value = numberValue
            greenLabel.text = String(format: "$.2f", numberValue)
        } else {
            blueSlider.value = numberValue
            blueLabel.text = String(format: "$.2f", numberValue)
        }
    }
}
