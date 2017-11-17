//
//  DetailViewController.swift
//  AutumnWorkspace
//
//  Created by LongLH on 11/17/17.
//  Copyright © 2017 Thang Phan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var slideMenu: UIView!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let musicName = ["A","B","C"]
    private var timeDefault = 30 * 60 {
        didSet {
            if timeDefault == 0 {
                timer = nil
            }
        }
    }
    private var timer: Timer?
    
    var slidemenuWidth: CGFloat {
        return view.frame.width * 0.75
    }
    
    var slidemenuHeight: CGFloat {
        return view.frame.height * 0.75
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdown()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5) {
            self.slideMenu.frame.origin.x = 500
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func changeMusic(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.slideMenu.frame.origin.x = self.view.frame.width - self.slidemenuWidth
        }
    }
    
    private func setupUI() {
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.white.cgColor
        takeCurrentTime()
        slideMenu.layer.borderWidth = 1
        slideMenu.layer.borderColor = UIColor.white.cgColor
        slideMenu.frame = CGRect(x: view.frame.width + slidemenuWidth, y: 0, width: slidemenuWidth, height: slidemenuHeight)
    }
    
    private func countdown() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.timeDefault -= 1
                let hour = Int(self.timeDefault / 60)
                let minute = Int(self.timeDefault % 60)
                if minute < 10 {
                    self.timeCountLabel.text = "\(hour) : 0\(minute)"
                } else {
                    self.timeCountLabel.text = "\(hour) : \(minute)"
                }
            })
        }
    }
    
    private func takeCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        //let month = components.month
        let day = components.day
        timeLabel.text = "\(day!) Nov \(year!)"
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell") as! CustomTableViewCell
        cell.titleLabel.text = musicName[indexPath.row]
        return cell
    }
}
