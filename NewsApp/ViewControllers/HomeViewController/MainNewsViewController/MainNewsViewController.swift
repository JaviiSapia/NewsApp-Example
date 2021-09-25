//
//  MainNewsViewController.swift
//  NewsApp
//
//  ViewController encargado de renderizar una lista de noticias mas recientes
//
//  Si la variable articles se encuentra con un array vacío, se renderizaran 6 celdas sin información para dar la sensación de carga.
//

import UIKit
import RxSwift

class MainNewsViewController: UIViewController {
    
    // MARK: - Declaración de variables
    static let TAG: String = "MainNewsViewController"
    private var articles: [Article] = []
    weak var delegate: NewsListDelegate?
    
    // MARK: - Configuración de las distintas vistas
    @IBOutlet weak var mainNewsCollectionView: UICollectionView! {
        didSet {
            mainNewsCollectionView.delegate = self
            mainNewsCollectionView.dataSource = self
            mainNewsCollectionView.showsHorizontalScrollIndicator = false
            mainNewsCollectionView.showsVerticalScrollIndicator = false
            mainNewsCollectionView.isPagingEnabled = true
            mainNewsCollectionView.register(UINib(nibName: MainNewsCell.TAG, bundle: Bundle.main), forCellWithReuseIdentifier: MainNewsCell.TAG)
        }
    }
    @IBOutlet weak var mainNewsCVFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            mainNewsCVFlowLayout.scrollDirection = .horizontal
            mainNewsCVFlowLayout.minimumLineSpacing = 0
            mainNewsCVFlowLayout.minimumInteritemSpacing = 0
        }
    }
    
    // MARK: - Inicialización del UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
        Crea una nueva instancia de MainNewsViewController
        - Parameter parent: El ViewController que maneja al contenedor donde se renderizará la nueva instancia del ViewController
        - Parameter container: UIView donde se mostrará la lista
     */
    static func newInstance(parent: UIViewController, container: UIView) -> MainNewsViewController {
        let controller: MainNewsViewController = UIStoryboard(name: "MainNews", bundle: nil).instantiateViewController(withIdentifier: TAG) as! MainNewsViewController
        parent.addChild(controller)
        container.addSubview(controller.view)
        controller.view.frame = container.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: parent)
        return controller
    }
    
    /**
        Carga una lista de Articulos
        - Parameter articles: Array de articulos que se desea mostrar
     */
    func setArticles(articles: [Article]) {
        self.articles = articles
        self.mainNewsCollectionView.reloadData()
    }
        
}

extension MainNewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        if self.articles.count != 0 {
            delegate?.news(selected: self.articles[indexPath.row])
        }
    }
    
}

extension MainNewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainNewsCell: MainNewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainNewsCell.TAG, for: indexPath) as! MainNewsCell
        if !articles.isEmpty {
            mainNewsCell.loadFromArticle(article: articles[indexPath.row])
        }
        return mainNewsCell
    }
    
}

extension MainNewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = collectionView.frame.height
        return CGSize(width: cellSize, height: cellSize)
    }
    
}
