//
//  StartViewController.swift
//  ColorizedApp
//
//  Created by Anton Boev on 11.10.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setNewColor(red: Float, green: Float, blue: Float)
}

class StartViewController: UIViewController {
    
    private var colorOfView: UIColor!
    private var backColor: UIColor!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC = segue.destination as? SettingsViewController else { return }
        backColor = view.backgroundColor
        settingVC.colorOfView = backColor
        settingVC.colorView?.backgroundColor = backColor
        settingVC.delegate = self
    }
}

extension StartViewController: SettingsViewControllerDelegate {
    func setNewColor(red: Float, green: Float, blue: Float) {
        view.backgroundColor = UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: 1
        )
    }
}
