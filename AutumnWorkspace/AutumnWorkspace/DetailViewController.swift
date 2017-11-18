//
//  DetailViewController.swift
//  AutumnWorkspace
//
//  Created by LongLH on 11/17/17.
//  Copyright © 2017 Thang Phan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class DetailViewController: UIViewController {

    @IBOutlet weak var slideMenu: UIView!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playTimeButton: UIButton!
    @IBOutlet weak var CustomBackgroundView: UIView!
    
    var player = AVAudioPlayer()
    var autumn: Autumn?
    var slidingMenuIsShowing = false
    
    private let imageName: [UIImage] = [#imageLiteral(resourceName: "1499940291-149991371219856-hinh-1.jpg"), #imageLiteral(resourceName: "autumn-in-my-heart-ost-trai-tim-mua-thu-624.jpg"), #imageLiteral(resourceName: "artworks-000193350014-7baww0-t500x500.jpg"),#imageLiteral(resourceName: "Nhớ mùa thu Hà Nội.jpeg"),#imageLiteral(resourceName: "maxresdefault.jpg")]
    private let musicName = ["Despacito - Luis Fonsi_ Daddy Yankee [128kbps_MP3]","Autumn-In-My-Heart-Main-Title-Flute-Ver-Various-Artists","MuaThuDiQua-Rhymastic-4597152_hq","Nho-Mua-Thu-Ha-Noi-Thu-Phuong","Thu-Cuoi-Yanbi-Mr-T-Hang-BingBoong"]
    private var timeDefault = 30 * 60 {
        didSet {
            if timeDefault == 0 {
                timer = nil
            }
        }
    }
    
    private var isTimeCount = false
    private var timer: Timer?
    
    var slidemenuWidth: CGFloat {
        return view.frame.width * 0.6
    }
    
    var slidemenuHeight: CGFloat {
        return view.frame.height * 0.75
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if autumn != nil {
            backgroundView.image = autumn?.image
        }
        setupBackgroundPlay()
        setupNowPlayingInfoCenter()
        CustomBackgroundView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        showAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5) {
            self.slideMenu.frame.origin.x = 500
            self.CustomBackgroundView.isHidden = true
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func changeMusic(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.slideMenu.frame.origin.x = self.view.frame.width - self.slidemenuWidth
            self.CustomBackgroundView.isHidden = false
        }
    }
    
    @IBAction func playTime(_ sender: Any) {
        if isTimeCount {
            isTimeCount = false
            playTimeButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            timer?.invalidate()
            timer = nil
        } else {
            isTimeCount = true
            playTimeButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            countdown()
        }
    }
    
    private func setupUI() {
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.layer.borderWidth = 5
        circleView.layer.borderColor = UIColor.white.cgColor
        takeCurrentTime()
        slideMenu.layer.borderWidth = 1
        slideMenu.layer.borderColor = UIColor.white.cgColor
        slideMenu.frame = CGRect(x: view.frame.width + slidemenuWidth, y: 0, width: slidemenuWidth, height: slidemenuHeight)
        timeCountLabel.text = "30 : 00"
        playTimeButton.imageView?.image = #imageLiteral(resourceName: "play")
        navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor.white
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
    
    private func setupBackgroundPlay() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    private func setupNowPlayingInfoCenter() {
        MPRemoteCommandCenter.shared().playCommand.addTarget { event in
            self.player.play()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { event in
            self.player.pause()
            return .success
        }
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell") as! CustomTableViewCell
        cell.titleLabel.text = ""
        cell.backgroundImage.image = imageName[indexPath.row]
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = Bundle.main.path(forResource: musicName[indexPath.row], ofType: "mp3")!
        print(path)
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.play()
            
        } catch let error as NSError {
            print(error.description)
        }
        UIView.animate(withDuration: 0.5) {
            self.slideMenu.frame.origin.x = 500
            self.CustomBackgroundView.isHidden = true
        }
    }
}
