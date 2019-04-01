//
//  ViewController.swift
//  WebServiceParsing
//
//  Created by Sanith Raj on 4/1/19.
//  Copyright © 2019 Sanith Raj. All rights reserved.
//

import UIKit

enum ServiceResponseKeys: String {
    case relatedTopics = "RelatedTopics"
}

class ViewController: UIViewController {

    let presenter: ViewControllerPresenter = ViewControllerPresenter()
    var listItem: UIBarButtonItem!
    var isList: Bool = true
    var collectionLayout: ItemCollectionLayout!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setup()
    }

    // MARK- custom methods
    func setup() {
        if let layout = collectionView?.collectionViewLayout as? ItemCollectionLayout {
            collectionLayout = layout
            collectionLayout.numberOfColumns = isList ? 1 : 2
            collectionLayout.delegate = self
        }
        
        listItem = UIBarButtonItem(image: UIImage(named: isList ? "list" : "grid"), style: .done, target: self, action: #selector(listItemTapped(_:)))
        searchBar.sizeToFit()
        
        navigationItem.title = "Simpsons Viewer"
        navigationItem.rightBarButtonItem = listItem
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "itemCell")
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCell")
        collectionView.register(UINib(nibName: "ItemCollectionVerticalCell", bundle: nil), forCellWithReuseIdentifier: "itemVerticalCell")
        
        var query = "simpsons characters"
        #if WireViewer
            query = "the wire characters"
        #else
            query = "simpsons characters"
        #endif
        
        presenter.getItems(query: query) { (topics) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func listItemTapped(_ sender: Any) {
        isList = !isList
        listItem.image = UIImage(named: isList ? "list" : "grid")
        collectionLayout.numberOfColumns = isList ? 1 : 2
        collectionLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        presenter.search(query: "") { (result) in
            self.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(query: searchText) { (result) in
            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, ItemCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.relatedTopics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = isList ? "itemCell" : "itemVerticalCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ItemCollectionViewCell
        let topic = presenter.relatedTopics[indexPath.item]
        cell?.updateItemInfo(topic: topic)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = presenter.relatedTopics[indexPath.item]
        let detailVC = DetailsViewController(nibName: "DetailsViewController", bundle: Bundle(for: DetailsViewController.self))
        detailVC.topic = topic
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            navigationController?.pushViewController(detailVC, animated: true)
        case .pad:
            let navVC = UINavigationController(rootViewController: detailVC)
            navVC.modalPresentationStyle = .formSheet
            present(navVC, animated: true, completion: nil)
        default:
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return isList ? 100 : 100
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForTitleAtIndexPath indexPath: IndexPath) -> CGFloat {
       
        return isList ? 30 : 50
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForDescAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return isList ? 100 : 150
    }
}
