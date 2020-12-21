//
//  SettingsViewController.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/17/20.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSegmented: UISegmentedControl!
    
    @IBAction func onSelectStrategy(_ sender: UISegmentedControl) {
        switch self.settingsSegmented.selectedSegmentIndex {
        case 0:
            Game.shared.questionSelectStrategy = .ordered
        case 1:
            Game.shared.questionSelectStrategy = .random
        default:
            Game.shared.questionSelectStrategy = .ordered
        }
    }

    override func viewDidLoad() {
        switch Game.shared.questionSelectStrategy{
            case .ordered:
                settingsSegmented.selectedSegmentIndex = 0
            case .random:
                settingsSegmented.selectedSegmentIndex = 1
        }
        super.viewDidLoad()
    }
    
}
