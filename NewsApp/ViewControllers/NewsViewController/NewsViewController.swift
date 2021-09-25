//
//  NewsViewController.swift
//  NewsApp
//
//  ViewController encargado de renderizar una lista de noticias
//
//  Se desactiva el UIScrollView Y se aumenta el tamaño del contenedor ya que el mismo se encuentra dentro de un UIScrollView
//
//  Si la variable articles se encuentra con un array vacío, se renderizaran 6 celdas sin información para dar la sensación de carga.
//

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: - Declaración de variables
    static let TAG: String = "NewsViewController"
    private var containerView: UIView!
    private let rowHeight: CGFloat = UIScreen.main.bounds.height * 0.13
    private let ghostCellsCount: Int = 6
    private var articles: [Article] = []
    weak var delegate: NewsListDelegate?
    
    // MARK: - Configuración de las distintas vistas
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet private weak var newsCollectionView: UICollectionView! {
        didSet {
            self.newsCollectionView.delegate = self
            self.newsCollectionView.dataSource = self
            
            //Desactivo el UIScrollView para luego aumentar el tamaño del contenedor
            self.newsCollectionView.isScrollEnabled = false;
            self.newsCollectionView.register(UINib(nibName: NewsCell.TAG, bundle: Bundle.main), forCellWithReuseIdentifier: NewsCell.TAG)
        }
    }
    @IBOutlet private weak var newsColectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            newsColectionViewFlowLayout.scrollDirection = .vertical
            newsColectionViewFlowLayout.minimumLineSpacing = 0
            newsColectionViewFlowLayout.minimumInteritemSpacing = 0
        }
    }
    
    // MARK: - Se infla el UIViewController
    
    /**
        Crea una nueva instancia de NewsViewController
        - Parameter parent: El ViewController que maneja al contenedor donde se renderizará la nueva instancia del ViewController
        - Parameter container: UIView donde se mostrará la lista
     */
    static func newInstance(parent: UIViewController, container: UIView) -> NewsViewController {
        let controller: NewsViewController = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: TAG) as! NewsViewController
        parent.addChild(controller)        
        container.addSubview(controller.view)
        
        //Asigno la referencia del contenedor
        controller.containerView = container
        controller.view.frame = container.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: parent)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
            
    // Aumenta el height del contenedor
    func resize() {
        if (self.articles.isEmpty) {
            containerView.frame.size.height = self.rowHeight * CGFloat(ghostCellsCount + 2)
        } else {
            containerView.frame.size.height = self.rowHeight * CGFloat(self.articles.count + 2)
        }
    }
    
    /**
        Carga una lista de Articulos
        - Parameter articles: Array de articulos que se desea mostrar
     */
    func setArticles(articles: [Article]) {
        self.articles = articles
        self.newsCollectionView.reloadData()
        
        // Cambio el tamaño del contenedor
        self.resize()
        
        // Espero a que termine de renderizar para notificarle al ViewController
        self.newsCollectionView.performBatchUpdates {
        } completion: { state in
            // Notifico al ViewController que los cambios
            // fueron realizados
            self.delegate?.onChangeListener()
        }

    }
    
}

extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.articles.count != 0 {
            delegate?.news(selected: self.articles[indexPath.row])
        }
    }
    
}

extension NewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (articles.isEmpty) {
            return ghostCellsCount
        } else {
            return articles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.TAG, for: indexPath) as! NewsCell
        if !articles.isEmpty {
            cell.loadFromArticle(article: self.articles[indexPath.row])
        }        
        return cell
    }
    
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.rowHeight)
    }
}
