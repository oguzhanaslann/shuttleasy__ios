//
//  ResetPasswordViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 28.11.2022.
//

import UIKit
import SnapKit

class ResetPasswordViewController: BaseViewController {

    private let userEmail: String
    
    init(userEmail: String){
        self.userEmail  = userEmail
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text =  "ResetPasswordViewController"

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
