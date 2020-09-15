//
//  UIViewController+Extensions.swift
//  NeAlo
//
//  Created by Vo Truong Thi on 8/7/19.
//  Copyright © 2019 Poeta Digital. All rights reserved.
//

import UIKit
import RxSwift
extension UIViewController {
    
    func show(message:String)->Observable<Bool>{
        return Observable.create({ (observer) -> Disposable in
            let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
               observer.onNext(true)
            }
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (alert) in
                observer.onNext(false)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentAlert(alert)
            return Disposables.create()
        })
    }
    
    func presentAlert(_ alert: UIAlertController) {
        if let navigationVC = self.navigationController {
            navigationVC.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertMessage(_ message: String, onPressOK: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
                onPressOK?()
            }
            alert.addAction(okAction)
            self.presentAlert(alert)
        }
    }
    
    func showErrorMessage(_ message: String, onPressOK: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "Cancel", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
                onPressOK?()
            }
            alert.addAction(okAction)
            self.presentAlert(alert)
        }
    }
    
    func showErrorMessageActionSheet(_ message: String, onPressOK: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .actionSheet)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
                onPressOK?()
            }
            alert.addAction(okAction)
            self.presentAlert(alert)
        }
    }
}
