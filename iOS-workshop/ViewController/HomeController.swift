//
//  HomeController.swift
//  iOS-workshop
//
//  Created by Muang on 27/6/2562 BE.
//  Copyright © 2562 ict. All rights reserved.
//

import UIKit
import Kingfisher

class HomeController: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    fileprivate var articles: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.delegate = self
        articleTableView.dataSource = self
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         fetchArticle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "articles_detail" ,
               let vc = segue.destination as? ArticleDetailController ,
               let article = sender as? Article
            else { return }

        vc.initArticle(article: article)
    }
    
    func fetchArticle() {
        ArticleService.getArticles { (articles,error)  in
            guard let articles = articles , error == nil else { return }
            self.articles = articles
            self.articleTableView.reloadData()
        }
    }
    
}
extension HomeController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell {
            let article = articles[indexPath.row]
            cell.titleLabel.text = article.title
            if let image = article.image {
                cell.articleImageView.isHidden = false
                let imageURL = URL(string: UrlHelper.baseURL + image)
                cell.articleImageView.kf.setImage(with: imageURL)
            } else {
                cell.articleImageView.isHidden = true
            }
            return cell
        }
        return ArticleCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        self.performSegue(withIdentifier: "articles_detail", sender: article)
    }
}
