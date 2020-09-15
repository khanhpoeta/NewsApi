//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import AlamofireImage

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSourceName: UILabel!
    @IBOutlet weak var imgViewArticle: UIImageView!
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblArticlePublishDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func load(entity: Any?) {
        imgViewArticle.image = nil
        lblSourceName.text = nil
        lblArticleTitle.text = nil
        if let article = entity as? Article{
            if let str = article.urlToImage,  let url = URL.init(string: str){
                imgViewArticle.af.setImage(withURL: url)
            }
            lblSourceName.text = article.source
            lblArticleTitle.text = article.title
            lblArticlePublishDate.text = article.publishedAt?.toString(format: "dd/MM/YYY")
        }
    }
}
