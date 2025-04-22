//
//  GasStationPhotosModel.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/6/22.
//

import Foundation

class GasStationPhotosModel {
    
    static let sharedInstance = GasStationPhotosModel()
    
    var photos:[String] = []
    
    private init() {
        listFilesFromPhotosFolder()
    }

    func listFilesFromPhotosFolder()
    {
        let filesPath = Bundle.main.resourcePath! + "/photos/"
        let fileManager = FileManager.default

        do {
            photos = try fileManager.contentsOfDirectory(atPath: filesPath)
        } catch {
            print(error)
        }

    }
    
    func getImageFilePath(_ file: String) -> String? {
        let relativeFilePath = "/photos/" + file

        let fullFilePath = Bundle.main.path (forResource: relativeFilePath, ofType: "")
        return fullFilePath
    }

}
