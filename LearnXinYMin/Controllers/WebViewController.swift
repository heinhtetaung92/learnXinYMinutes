//
//  WebViewController.swift
//  LearnXinYMin
//
//  Created by Hein Htet on 11/4/20.
//  Copyright © 2020 Hein Htet. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var programmingKey: String?
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.allowsLinkPreview = true
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let key = programmingKey else { return }
        
        let url = "https://learnxinyminutes.com/docs/\(key)/"
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}
