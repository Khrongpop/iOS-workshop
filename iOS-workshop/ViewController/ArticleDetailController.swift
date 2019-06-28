//
//  ArticleDetailController.swift
//  iOS-workshop
//
//  Created by Muang on 28/6/2562 BE.
//  Copyright © 2562 ict. All rights reserved.
//

import UIKit

class ArticleDetailController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    var article: Article? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let article = article {
            updateView(article: article)
        }
    }
    
    func initArticle(article: Article) {
        self.article = article
    }
    
    func updateView(article: Article) {
        titleLabel.text = article.title
        detailLabel.text = article.detail
        if let image = article.image {
            articleImageView.kf.setImage(with: URL(string: UrlHelper.baseURL + image))
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "update_article" ,
              let vc = segue.destination as? CreateController ,
              let article = self.article  else { return }
        vc.initArticle(article: article, vc: self)
    }
}
