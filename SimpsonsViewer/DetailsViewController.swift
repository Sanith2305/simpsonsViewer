//
//  DetailsViewController.swift
//  WebServiceParsing
//
//  Created by Sanith Raj on 4/1/19.
//  Copyright © 2019 Sanith Raj. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var topic: Topics!
    
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }


    private func setup() {
        navigationItem.title = topic.title
        descLbl.text = topic.desc
      
        if let urlString = topic.imageURL, let url = URL(string: urlString) {
            itemImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
            navigationItem.leftBarButtonItem = cancelItem
        default:
            break
        }
    }
    
    @objc func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
