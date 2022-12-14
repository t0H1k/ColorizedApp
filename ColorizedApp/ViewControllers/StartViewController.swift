//
//  StartViewController.swift
//  ColorizedApp
//
//  Created by Anton Boev on 11.10.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setNewColor(by color: UIColor)
}

class StartViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC = segue.destination as? SettingsViewController else { return }
        settingVC.delegate = self
        settingVC.colorOfView = view.backgroundColor
    }
}

// MARK: - ColorDelegate
extension StartViewController: SettingsViewControllerDelegate {
    func setNewColor(by color: UIColor) {
        view.backgroundColor = color
    }
}
