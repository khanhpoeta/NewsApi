//
//  ArticleDetailViewController.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var url:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URLRequest.init(url: url)
        webView.load(request)
    }

}
