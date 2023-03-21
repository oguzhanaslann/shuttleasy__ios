//
//  PickSessionsViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 21.03.2023.
//

import UIKit

struct PickSessionsArgs {
    let companyId : Int
    let destinationPoint: CGPoint
    let pickupPoint: CGPoint
}

class PickSessionsViewController: BaseViewController {
    
    let args : PickSessionsArgs

    init(args : PickSessionsArgs){
        self.args = args
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
