//
//  DestinationViewController.swift
//  Ind02_Philip_Lijo
//
//  Created by Lijo Philip on 2/15/22.
//

import Foundation
import UIKit

// Second ViewController
class DestinationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //
    @IBAction func hideAnsTapped(_ sender: Any){
        // Dissmissing the second ViewController when button tapped.
        dismiss(animated: true, completion: nil)
    }
    
}
