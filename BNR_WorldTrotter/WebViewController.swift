//
//  WebViewController.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/12/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Stored Properties
    
    var webView: WKWebView!
    
    // MARK: - UIViewController Methods
    
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let validUrl = NSURL(string: "https://google.com") else { return }
        self.webView.loadRequest(NSURLRequest(URL: validUrl))
        self.webView.allowsBackForwardNavigationGestures = true
    }

}
