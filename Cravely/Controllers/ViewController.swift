//
//  ViewController.swift
//  Cravely
//
//  Created by ayman moh on 15/07/2026.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        
        updateColors()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.updateColors()
        }
    }
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var cravelyLabel: UILabel!
    
    @IBOutlet var dynamicLabels: [UILabel]!
    @IBOutlet var smallButton: [UIButton]!
    @IBOutlet var staticInformationLabels: [UILabel]!

    @IBOutlet weak var iCraveOneButton: UIButton!
    
    let darkModeGray4 = UIColor(
        red: 0.27,
        green: 0.27,
        blue: 0.29,
        alpha: 1.0
    )
    func updateColors() {
         if traitCollection.userInterfaceStyle == .dark {
             // Header and Background (Dark)
             view.backgroundColor = .black
             cravelyLabel.textColor = .white
             homeLabel.textColor = darkModeGray4
             
             // Buttons (Dark)
             smallButton.forEach {
                 $0.tintColor = .clear
                 $0.configuration?.baseForegroundColor = darkModeGray4
             }
             iCraveOneButton.tintColor = darkModeGray4
             
             // Labels (Dark)
             staticInformationLabels.forEach {
                 $0.textColor = darkModeGray4
             }
             dynamicLabels.forEach{
                 $0.textColor = .white
             }
             
         } else {
             
            // Header and Background (Light)
             view.backgroundColor = .white
             cravelyLabel.textColor = .black
             homeLabel.textColor = darkModeGray4

             // Buttons (Light)
             iCraveOneButton.tintColor = darkModeGray4

             smallButton.forEach {
                 $0.tintColor = .clear
                 $0.configuration?.baseForegroundColor = darkModeGray4
             }
             
             // Labels (Light)
             staticInformationLabels.forEach {
                 $0.textColor = darkModeGray4
             }
             dynamicLabels.forEach{
                 $0.textColor = .black
             }
             


         }
     }

     

}

