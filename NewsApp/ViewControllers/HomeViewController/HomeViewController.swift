//
//  HomeViewController.swift
//  NewsApp
//
//  ViewController principal. Muestra una lista horizontal de las noticias mas recientes y una lista vertical de todas las noticias
//  

import UIKit

class HomeViewController: UIViewController {
                
    // MARK: - Declaración de variables
    private var refreshControll: UIRefreshControl?
    private var guardianService: GuardianService?
    private var newsViewController: NewsViewController?
    private var mainNewsViewController: MainNewsViewController?
    private var sectionViewController: SectionsViewController?
    
    // MARK: - Configuración de las distintas vistas
    @IBOutlet private var stackViewHeghtContraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            self.refreshControll = UIRefreshControl()
            self.refreshControll!.addTarget(self, action: #selector(refresh), for: .valueChanged)
            scrollView.addSubview(self.refreshControll!)
        }
    }
    @IBOutlet weak var sectionsContainer: UIView! {
        didSet {
            self.sectionViewController = SectionsViewController.newInstance(parent: self, container: sectionsContainer)
            self.sectionViewController!.delegate = self
        }
    }
    @IBOutlet weak var mainNewsContainer: UIView! {
        didSet {
            self.mainNewsViewController = MainNewsViewController.newInstance(parent: self, container: mainNewsContainer)
            self.mainNewsViewController?.delegate = self
        }
    }
    @IBOutlet weak var newsContainer: UIView! {
        didSet {
            self.newsViewController = NewsViewController.newInstance(parent: self, container: self.newsContainer)
            self.newsViewController?.delegate = self
            self.newsViewController?.headerTitle.text = "Latest"
        }
    }
    
    // MARK: - Métodos
    
    private func resizeView() {
        let views: [UIView] = self.stackView.subviews
        let totalHeight: CGFloat = views.reduce(0) { count, view in
            return count + view.frame.height
        }
        self.stackViewHeghtContraint.constant = totalHeight
        self.scrollView.contentSize.height = totalHeight
    }
    
    // Maneja la petición de refresco de la información
    @objc func refresh(_ sender: Any) {
        self.guardianService?.search(url: GuardianURL.Build(section: self.sectionViewController?.active))
        self.newsViewController?.setArticles(articles: [])
        self.mainNewsViewController?.setArticles(articles: [])
    }
    
    // MARK: - Ciclos de vida del ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Realizo el primer request
        self.guardianService = GuardianService(handler: self)
        self.guardianService?.search(url: GuardianURL.Build())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Escondo el NavigationBar
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.resizeView()
    }
    
}

extension HomeViewController: NewsListDelegate {
    
    // Muestro el articulo seleccionado en un ArticleViewController
    func news(selected article: Article) {
        let articleViewController = ArticleViewController.newInstance(article: article)        
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    // Escucho los cambios del NewsViewController para luego cambiar el tamaño del StackView
    func onChangeListener() {
        self.resizeView()
    }
    
}

extension HomeViewController: SectionsListDelegate {
    
    func section(selectedAt section: String) {
        
        // Defino un array vacío a los ViewControllers para que muestren las celdas de carga
        self.newsViewController?.setArticles(articles: [])
        self.mainNewsViewController?.setArticles(articles: [])
        
        if section.compare("News") == .orderedSame {
            self.guardianService?.search(url: GuardianURL.Build())
            self.newsViewController?.headerTitle.text = "Latest"
        } else {
            self.newsViewController?.headerTitle.text = "Latest on " + section
            self.guardianService?.search(url: GuardianURL.Build(section: section.lowercased()))
        }
    }
    
}

extension HomeViewController: GuardianSeriviceDelegate {
   
    func service(response articles: ArraySlice<Article>) {
        if articles.count != 0 {
            // Desactivo la animación
            self.refreshControll?.endRefreshing()
            
            // Separo el array de articulos en 2:
            // Muestro los primeros 3 elementos del Array como noticias mas destacadas
            self.mainNewsViewController?.setArticles(articles: Array(articles[0...2]))
            
            // Muestro el resto del array en la lista de noticias
            self.newsViewController?.setArticles(articles: Array(articles[3...]))
        } else {
            
            // Defino un array vacío a los ViewControllers para que muestren las celdas de carga
            self.mainNewsViewController?.setArticles(articles: [])
            self.newsViewController?.setArticles(articles: [])
        }
    }
    
    func service(response content: String) {
        
    }
    
    func service(on error: Error) {
        self.refreshControll?.endRefreshing()
        let alert = UIAlertController(title: "Error", message: "Something went wrong" + error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
