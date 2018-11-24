//
//  SpinnerViewController.swift
//  ONS
//
//  Created by SHIVA KUMAR on 14/11/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

  
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        override func loadView() {
            view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    

}
