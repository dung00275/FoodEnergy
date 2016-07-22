//
//  ViewController.swift
//  FoodEnergy
//
//  Created by Dung Vu on 7/22/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let food = Foods.GET(foodID: "33691")
        let router = Router.TrackFood(food: food)
        
        ServiceManager.sharedInstance.request(URLRequest: router.request) { (result, response) in
            switch result {
            case .Success(let json):
                print(json)
            case .Fail(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

