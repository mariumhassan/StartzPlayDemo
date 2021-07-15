//
//  ViewController.swift
//  StartzPlay
//
//  Created by Marim Hassan on 13/07/2021.
//

protocol ViewModelProtocol {
    func tvDetailsgetFetched()
    func seasonDetailsGetFetched()
}


import Foundation

class ViewModel {
   
    var tvShowdetails = TvShowDetails()
    var seasonDetails = SeasonDetails()
    var episodeDetails = Episode()
    
    var delegate : ViewModelProtocol?
    var service = Servicehandler()
    
    func getTvShowdata(showId:Int)
    {
       
        service.execute(action:"tv/\(showId)",modelType:TvShowDetails.self,completionHandler: { response in
            
            self.tvShowdetails = response
            self.delegate?.tvDetailsgetFetched()
            self.getSeasondata(showId:showId,seasonNum:1)
        })
    }
    
    func getSeasondata(showId:Int,seasonNum:Int)
    {
        
        service.execute(action:"tv/\(showId)/season/\(seasonNum)",modelType:SeasonDetails.self,completionHandler: { response in
           
            self.seasonDetails = response
            self.delegate?.seasonDetailsGetFetched()
        })
    }
    
    func getEpisodedata(showId:Int,seasonNum:Int,episodeNum:Int)
    {
        service.execute(action:"tv/\(showId)/season/\(seasonNum)/episode/\(episodeNum)",modelType:Episode.self,completionHandler: { response in
            self.episodeDetails = response
           
        })
    }
    
    
    

}

