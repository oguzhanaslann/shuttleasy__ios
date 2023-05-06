//
//  PrivacyPolicyViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 5.05.2023.
//

import Foundation
import WebKit
import UIKit
import SnapKit

class WebViewController : BaseViewController {
    
    private let webView: WKWebView = WKWebView()
    
    private var htmlString : String
    
    init(htmlString : String){
        self.htmlString  = htmlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder : NSCoder){
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
