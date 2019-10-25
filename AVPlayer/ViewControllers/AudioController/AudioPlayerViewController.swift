//
//  AudioPlayerViewController.swift
//  AVPlayer
//
//  Created by Dzmitry Noska on 10/23/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

import UIKit

let  APVC_TITLE: String = "Audio Podcasts"
let TED_TALKS_AUDIO_RESOURCE_URL: String = "https://feeds.feedburner.com/HanselminutesCompleteMP3"
let AUDIO_CELL_IDENTIFIER: String = "Cell"

class AudioPlayerViewController: UITableViewController {

    private var videoItems: [RSSVideoItem]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = APVC_TITLE
        fetchData()
        setUpTableView()
        setUpNavigationItem()
    }
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: TED_TALKS_AUDIO_RESOURCE_URL) { (videoItems) in
            self.videoItems = videoItems
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videoItems = videoItems else {
            return 0
        }
        return videoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AUDIO_CELL_IDENTIFIER, for: indexPath) as! VideoPlayerTableViewCell
        
        if let item = videoItems?[indexPath.item] {
            cell.item = item
        }
        
        cell.layoutSubviews()
        return cell
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            videoItems?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    // Mark: - SetUp's
    
    func setUpTableView() {
        self.tableView.decelerationRate = .normal
        self.tableView.register(VideoPlayerTableViewCell.self, forCellReuseIdentifier: AUDIO_CELL_IDENTIFIER)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }
    
    func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
    }
    
    @objc func refreshData() {
        self.videoItems?.removeAll()
        fetchData()
    }


}
