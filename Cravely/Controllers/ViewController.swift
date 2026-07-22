//
//  ViewController.swift
//  Cravely
//
//  Created by ayman moh on 15/07/2026.
//

import UIKit


class ViewController: UIViewController {
   
    
    var outerCircle = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()        
        updateColors()
        updateGreeting ()
        
        let padding: CGFloat = 8

           outerCircle.path = UIBezierPath(
               ovalIn: iCraveOneButton.bounds.insetBy(dx: -padding, dy: -padding)
           ).cgPath

           outerCircle.fillColor = UIColor.clear.cgColor
           outerCircle.strokeColor = UIColor.gray.cgColor
        outerCircle.lineWidth = 0.5
           outerCircle.name = "outerCircle"

           iCraveOneButton.layer.addSublayer(outerCircle)
        
        
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.updateColors()
        }
        
    }
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(HistoryViewController(), animated: true)

    }
    @IBOutlet weak var greetingLabel: UILabel!
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
       
    func updateGreeting (){
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            greetingLabel.text = "Good morning ☀️"

          case 12..<18:
            greetingLabel.text = "Good afternoon 🌤️"

          default:
            greetingLabel.text = "Good evening 🌙"
          }
        }
    
    
    func updateColors() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = isDark ? .black : .white
        cravelyLabel.textColor = isDark ? .white : .black
        homeLabel.textColor = darkModeGray4
        iCraveOneButton.tintColor = darkModeGray4

        smallButton.forEach {
            $0.tintColor = .clear
            $0.configuration?.baseForegroundColor = darkModeGray4
        }
        staticInformationLabels.forEach { $0.textColor = darkModeGray4 }
        dynamicLabels.forEach { $0.textColor = isDark ? .white : .black }
    }
    
             


         
     }

     



