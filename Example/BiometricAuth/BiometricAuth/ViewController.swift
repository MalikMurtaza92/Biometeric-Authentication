//
//  ViewController.swift
//  BiometricAuth
//
//  Created by Murtaza Mehmood on 28/09/2024.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    var context = LAContext()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginuser(_ sender: Any) {
        BiometricsManager.shared.authenticateUser { result in
            switch result {
            case .success:
                print("Success")
            case .failure(let error):
                print(error)
            }
        }
    }
}

