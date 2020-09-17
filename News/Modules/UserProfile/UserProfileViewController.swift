//
//  UserProfileViewController.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileViewController: BaseViewController {
    
    private let viewModel = UserProfileViewModel()
    
    @IBOutlet weak var txfUserFirstName:UITextField!
    @IBOutlet weak var txfUserLastName:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func binding() {
        
        txfUserFirstName.rx.text.skip(1)
            .bind(to: self.viewModel.input.firstNameChanged)
            .disposed(by: disposeBag)
        
        txfUserLastName.rx.text.skip(1)
            .bind(to: self.viewModel.input.lasNameChanged)
            .disposed(by: disposeBag)
        
        viewModel.output.currentUser?.subscribe({ [weak self](event) in
            if let user = event.element as? User{
                debugPrint(user.firstName)
                debugPrint(user.lastName)
                self?.txfUserFirstName.text = user.firstName
                self?.txfUserLastName.text = user.lastName
            }
        }).disposed(by: disposeBag)
    }
    
}
