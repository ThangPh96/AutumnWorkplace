//
//  AutumnViewController.swift
//  AutumnWorkspace
//
//  Created by Bùi Hà on 17/11/17.
//  Copyright © 2017 Thang Phan. All rights reserved.
//

import UIKit

class AutumnViewController: UIViewController {
    
    @IBOutlet weak var autumnTableView: UITableView!

    
    let reuseIdentifier: String = "cell"
    let detailVCIdentifier: String = "detailVc"
    let titleNavigator: String = "Autumn"
    var autumns: [Autumn] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleNavigator
        self.autumnTableView.dataSource = self
        self.autumnTableView.delegate = self
//        self.autumnTableView.separatorStyle = .singleLine
//        self.autumnTableView.separatorColor = UIColor.white
        loadDataFromDocumentDirectory()
    }
    
    func loadDataFromDocumentDirectory() {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(documentsUrl)
            loop:
                for i in directoryContents {
                    //let imageNameWithExtension = i.lastPathComponent
                    let imageName = i.deletingPathExtension().lastPathComponent
                    let imageNames = imageName.components(separatedBy: ".")
                    
                    if imageName != ".DS_Store" {
                        let image: UIImage = UIImage(contentsOfFile: i.path)!
                        let autumn = Autumn(image: image, themeName: imageNames[0], titleText: imageNames[1])
                        self.autumns.append(autumn)
                    }
     
            }
        } catch {
            print(error)
        }
    }
}

extension AutumnViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autumns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AutumnTableViewCell
        
        let autumn = autumns[indexPath.row]
        cell.autumn = autumn
        cell.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cell
    }
}

extension AutumnViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: detailVCIdentifier) as? DetailViewController {
            navigationController?.pushViewController(detailVC, animated: true)
            detailVC.autumn = autumns[indexPath.row]
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.size.height - 64) / 3
    }
}
