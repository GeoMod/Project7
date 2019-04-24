//
//  DetailViewController.swift
//  Project7
//
//  Created by Daniel O'Leary on 3/7/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        Signature Count:
        \(detailItem.signatureCount)
        </body>
        </html>
"""
        webView.loadHTMLString(html, baseURL: nil)
    }

    

}
