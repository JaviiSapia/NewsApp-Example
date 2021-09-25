//
//  ArticleViewController.swift
//  NewsApp
//
//  Created by Javier Sapia on 04/09/2021.
//

import UIKit

class ArticleViewController: UIViewController {

    static let TAG: String = "ArticleViewController"
    private var guardianService: GuardianService?
    private var newsViewController: NewsViewController?
    private var article: Article?
    
    @IBOutlet private weak var containerHeight: NSLayoutConstraint!
    @IBOutlet private weak var image: AsyncImage! {
        didSet {
            image.loadFromUrl(url: article!.image!)
        }
    }
    @IBOutlet private weak var header: HeaderView! {
        didSet {
            header.loadFromArticle(article: article!)
        }
    }
    @IBOutlet private weak var text: UILabel! {
        didSet {
            text.isSkeletonable = true
            text.showAnimatedSkeleton()
        }
    }
    @IBOutlet private weak var container: UIView! {
        didSet {
            self.container.layer.cornerRadius = 20
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
        }
    }
    @IBOutlet private weak var relatedNewsContainer: UIView! {
        didSet {
            self.newsViewController = NewsViewController.newInstance(parent: self, container: self.relatedNewsContainer)
            self.newsViewController?.delegate = self
            self.newsViewController?.headerTitle.text = "It may interest you"
        }
    }
    
    // MARK: - Ciclos de vida
    
    static func newInstance(article: Article) -> ArticleViewController {
        let controller: ArticleViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: TAG) as! ArticleViewController
        controller.article = article
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.guardianService = GuardianService(handler: self)
        self.guardianService?.getContent(url: GuardianURL.BuildFromApiUrl(url: article!.content!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.topItem?.backButtonTitle = nil
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationItem.backBarButtonItem?.image = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.updateViews()
    }
    
    // MARK: - Métodos
    
    private func updateViews() {
        var height: CGFloat = 0.0
        for view in self.container.subviews[0].subviews {
            height += view.frame.height
        }
        self.containerHeight.constant = height
    }

}

extension ArticleViewController: NewsListDelegate {
    
    func onChangeListener() {
        // Aumento el tamaño del contenedor
        self.updateViews()
    }
    
    func news(selected article: Article) {
        let articleViewController = ArticleViewController.newInstance(article: article)
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
}

extension ArticleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y > UIScreen.main.bounds.height * 0.4) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension ArticleViewController: GuardianSeriviceDelegate {
    
    func service(response articles: ArraySlice<Article>) {
        self.newsViewController?.setArticles(articles: Array(articles))
    }
    
    func service(response content: String) {
        self.guardianService?.search(url: GuardianURL.Build(section: article!.section!.lowercased()))
        self.text.text = content
        self.text.hideSkeleton()
        self.text.sizeToFit()
        
        // Aumento el tamaño del contenedor
        self.updateViews()
    }
    
    func service(on error: Error) {
        print("🔴", error.localizedDescription)
    }
    
}
