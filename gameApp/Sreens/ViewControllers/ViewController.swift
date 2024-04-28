//
//  ViewController.swift
//  gameApp
//
//  Created by Ece Ok, Vodafone on 25.04.2024.
//

import UIKit
var gameLists : [Game] = []
final class ViewController: UIViewController, UIPageViewControllerDataSource {
    var filteredGames = [Game]()
    var isFiltering : Bool = false

    @IBOutlet weak var searchBar: UISearchBar!
    var pageViewController : UIPageViewController?
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isUserInteractionEnabled = true
        searchBar.delegate = self
        view.addSubview(noDataLabel)
        setupNoDataLabelConstraints()
    }
    
    private func collectionViewSet(){
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        gameCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectiongameCell")
        
    }
    
    private func configureGameCollectionView() {
           gameCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
           gameCollectionView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(gameCollectionView)

           NSLayoutConstraint.activate([
            gameCollectionView.topAnchor.constraint(equalTo: pageViewController!.view.bottomAnchor, constant: 16), // 8 piksel boşluk
               gameCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               gameCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               gameCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
           
        
       }
    
    private var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No Game"
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupNoDataLabelConstraints() {
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func flowLayoutSet() -> UICollectionViewFlowLayout{
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        //let flowHeight = UIScreen.main.bounds.height
        let flowWidth = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: flowWidth, height: 70)
        //flowLayout.minimumLineSpacing = 0
        //flowLayout.minimumInteritemSpacing = 0
        
        return flowLayout
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GameLogic.shared.getGAmes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                let gameList = games.results.compactMap { $0}
                gameLists = gameList
                self.setupPageController()
                self.createPageViewController()
                gameCollectionView.collectionViewLayout = flowLayoutSet()
                self.collectionViewSet()
                DispatchQueue.main.async {
                    self.gameCollectionView.reloadData()
                }
               
               
                print("------- GAMES ------ ", games.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    private func createPageViewController() {
        
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        
        pageController.dataSource = self
        
        if gameLists.count >= 3 {
            
            let firstController = getItemController(0)!
            let startVCS = [firstController]
            
            pageController.setViewControllers( startVCS , direction: UIPageViewController.NavigationDirection.forward, animated: false)
        }
        
        let pageWidth = view.frame.width - 16 // 8 piksel sağdan ve 8 piksel soldan boşluk
               let pageHeight = view.frame.height * 0.3 // %30 oranında yükseklik
               pageController.view.frame = CGRect(x: 8, y: searchBar.frame.maxY + 8, width: pageWidth, height: pageHeight)
        
        pageViewController = pageController
        addChild(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController?.didMove(toParent: self)
    }
    
    private func setupPageController() {
        
        // UIPageControl oluştur
        let pageControl = UIPageControl()
        // pageControl'ün çerçevesini yeniden oluşturarak yüksekliği 20 olarak ayarla
        pageControl.frame = CGRect(x: pageControl.frame.origin.x, y: pageControl.frame.origin.y, width: pageControl.frame.size.width - 50.0, height: 20.0)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        // UIPageControl'un özelliklerini ayarla
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.backgroundColor = UIColor.darkGray
        
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        
        if let index = gameLists.firstIndex(where: { $0.id == itemController.itemIndex }) {
            let nextIndex = index + 1
            if nextIndex < gameLists.count {
                return getItemController(nextIndex)
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        
        if let index = gameLists.firstIndex(where: { $0.id == itemController.itemIndex }) {
            let previousIndex = index - 1
            if previousIndex >= 0 {
                return getItemController(previousIndex)
            }
        }
        return nil
    }

    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
    private func currentControllerIndex() -> Int {
        let pageItemController = self.currentController
        if let controller = pageItemController as? ItemViewController {
            return controller.itemIndex
        }
        return -1
    }
    
    
    private func currentController() -> UIViewController? {
        
        if (self.pageViewController?.viewControllers?.count)! > 0 {
            return (self.pageViewController?.viewControllers?[0])!
        }
        return nil
    }
    
    func getItemController(_ itemIndex: Int) -> ItemViewController? {
        guard itemIndex >= 0 && itemIndex < 3 else {
            return nil
        }
        
        let pageItemController = storyboard?.instantiateViewController(withIdentifier: "ItemController") as! ItemViewController
        pageItemController.itemIndex = gameLists[itemIndex].id
        pageItemController.game = gameLists[itemIndex] // Game nesnesini geçir
        return pageItemController
    }

}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
                noDataLabel.isHidden = filteredGames.count > 0
                return filteredGames.count
            } else {
                noDataLabel.isHidden = gameLists.count > 0
                return gameLists.count
            }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectiongameCell", for: indexPath) as! CollectionViewCell
        if isFiltering {
            cell.configCell(filteredGames[indexPath.row])
        }else
        {
            cell.configCell(gameLists[indexPath.row])
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            let selectedItem = filteredGames[indexPath.item]
            if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                    detailViewController.game = selectedItem
                    navigationController?.pushViewController(detailViewController, animated: true)
                }
        } else {
            let selectedItem = gameLists[indexPath.item]
            if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                    detailViewController.game = selectedItem
                    navigationController?.pushViewController(detailViewController, animated: true)
                }
        }
       
    }

}


extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
                    filteredGames = gameLists.filter { game in
                        return game.name.lowercased().contains(searchText.lowercased())
                    }
                } else {
                    filteredGames = gameLists
                }
                isFiltering = true
                gameCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        searchBar.text = ""
        filteredGames = [Game]()
        gameCollectionView.reloadData()
    }
}
 
    


