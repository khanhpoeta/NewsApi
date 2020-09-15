//
//  BaseViewController.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    internal lazy var disposeBag = {
        return DisposeBag.init()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        binding()
    }
    
    internal func binding(){
        
    }

}
