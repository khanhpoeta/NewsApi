//
//  CustomNewsViewController.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomNewsViewController: BaseViewController {
    
    
    let viewModel = CustomNewViewModel()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var segmentSearchArticle: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func binding() {
        configTableView()
        
        self.segmentSearchArticle.rx.value.map({ (index) -> EveryThinkRequest.KeyWordSearch in
            switch index{
            case 3:
                return .animal
            case 1:
                return .apple
            case 2:
                return .earthquake
            default:
                return .bitcoint
            }
        }).bind(to: self.viewModel.input.keyWordDidChanged).disposed(by: disposeBag)

        self.segmentSearchArticle.rx.value.map({ (index) -> Void in
            return ()
        }).bind(to: self.viewModel.input.reachedBottomTrigger).disposed(by: disposeBag)
        
        self.viewModel.error?.observeOn(MainScheduler.instance).subscribe { [weak self](event) in
            self?.showErrorMessageActionSheet(event.element!.localizedDescription, onPressOK: nil)
        }.disposed(by: disposeBag)
        
        self.viewModel.input.reachedBottomTrigger.onNext(())
        
        viewModel.output.articles?.observeOn(MainScheduler.instance).bind(to: self.tableView.rx.items) { table, index, element in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Article")!
            cell.load(entity: element)
            return cell
        }.disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Article.self))
            .bind { [unowned self] indexPath, model in
                self.tableView.deselectRow(at: indexPath, animated: true)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom.asObservable()
            .bind(to: viewModel.input.reachedBottomTrigger)
            .disposed(by: disposeBag)
    }
    
    private func configTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(ArticleTableViewCell.getNib(), forCellReuseIdentifier: "Article")
    }
    
}
