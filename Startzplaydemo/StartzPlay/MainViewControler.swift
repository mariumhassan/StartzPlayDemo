//
//  ViewController.swift
//  StartzPlay
//
//  Created by Marim Hassan on 13/07/2021.
//

import UIKit
import SDWebImage

class MainViewControler: UIViewController, ViewModelProtocol {

    var viewModel:ViewModel?
    
    @IBOutlet var playView: UIView!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var readMoreBtn: UIButton!
    @IBOutlet var overView: UILabel!
    @IBOutlet var genere: UILabel!
    @IBOutlet var seasonCount: UILabel!
    @IBOutlet var movieYear: UILabel!
    @IBOutlet var movieName: UILabel!
    @IBOutlet var backDropImg: UIImageView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var dislikebtn: UIButton!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var watchlistBtn: UIButton!
    
    var tvShowId = 62852  // temporary tv id to fetch data
    var lastSelectedCell = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        viewModel?.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        self.watchlistBtn.layer.cornerRadius = self.watchlistBtn.layer.frame.width / 2
        self.watchlistBtn.clipsToBounds = true
        self.likeBtn.layer.cornerRadius = self.likeBtn.layer.frame.width / 2
        self.likeBtn.clipsToBounds = true
        self.dislikebtn.layer.cornerRadius = self.dislikebtn.layer.frame.width / 2
        self.dislikebtn.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTableView()
        viewModel?.getTvShowdata(showId: tvShowId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToPlayer(sender:)))
        playView.addGestureRecognizer(tapGesture)
          
    }

    
    
    @IBAction func readMoreTap(_ sender: UIButton) {
       
        self.readMoreBtn.isSelected = !self.readMoreBtn.isSelected
        if self.readMoreBtn.isSelected{
            overView.lineBreakMode = .byWordWrapping
            overView.numberOfLines = 0
            
        }else{
            overView.lineBreakMode = .byTruncatingTail
            overView.numberOfLines = 2
        }
            
       
        
    }
    
    
    @objc func goToPlayer(sender: UITapGestureRecognizer)
    {
        // Added video player on tap of play button
        performSegue(withIdentifier: "videoPlayer", sender: self)
    }
    
    func tvDetailsgetFetched()
    {
        self.movieName.text = viewModel?.tvShowdetails.name
        self.movieYear.text = viewModel?.tvShowdetails.first_air_date
        self.genere.text = viewModel?.tvShowdetails.genres?[0].name ?? ""
        let url = URL(string:(actionUrl.baseUrlImg.rawValue + (viewModel?.tvShowdetails.backdrop_path ?? "") ))
        self.backDropImg.sd_setImage(with: url)
        self.seasonCount.text = String(viewModel?.tvShowdetails.number_of_seasons ?? 0) + " Seasons"
        self.overView.text = viewModel?.tvShowdetails.overview
        lastSelectedCell = -1
        self.collectionView.reloadData()
    }
    func seasonDetailsGetFetched()
    {
        self.myTableView.reloadData()
    }
    
    func setUpTableView()
    {
        myTableView.delegate = self
        myTableView.dataSource = self
        self.myTableView.register(UINib(nibName: "EpisodeTblCell", bundle: nil), forCellReuseIdentifier:  "EpisodeTblCell")
    }
    
}

extension MainViewControler : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel?.tvShowdetails.number_of_seasons ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
       {
        cell.seasonlabel.text = "Season \(indexPath.row + 1)"
        return cell
       }
       
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastSelectedCell >= 0
        {
            let indexpath = IndexPath(row: lastSelectedCell, section: 0)
            (self.collectionView.cellForItem(at: indexpath) as? CollectionViewCell)?.seasonlabel.font = UIFont(name: "Regular", size: 17)
        }
        lastSelectedCell = indexPath.row
        (self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell)?.seasonlabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 200))
        self.viewModel?.getSeasondata(showId: tvShowId,seasonNum: indexPath.row + 1)
    }
    
    
}

extension MainViewControler: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.seasonDetails.episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.myTableView.dequeueReusableCell(withIdentifier: "EpisodeTblCell") as? EpisodeTblCell
        {
            //cell.episodeName.text = self.viewModel?.seasonDetails.episodes?[indexPath.row].name ?? ""
            // using subviews because taking outlets was giving an absurd error "this class is not key value coding-compliant for the key episodeName" which i was unable to figure out why is occuring
            if cell.contentView.subviews[0].subviews.count > 2
            {
                (cell.contentView.subviews[0].subviews[2] as? UILabel)?.text = "E\(indexPath.row + 1) - " +  (self.viewModel?.seasonDetails.episodes?[indexPath.row].name ?? "")
                (cell.contentView.subviews[0].subviews[3] as? UIButton)?.setBackgroundImage(UIImage(named: "downloadimg"), for: .normal)
                (cell.contentView.subviews[0].subviews[1] as? UIImageView)?.sd_setShowActivityIndicatorView(true)
                (cell.contentView.subviews[0].subviews[1] as? UIImageView)?.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
                (cell.contentView.subviews[0].subviews[1] as? UIImageView)?.sd_setImage(with: URL(string:self.viewModel?.seasonDetails.episodes?[indexPath.row].still_path ?? ""), placeholderImage: UIImage(named: "placeHolderImage"))
            }
        
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

