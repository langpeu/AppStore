//
//  PhotoManager.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//
import Photos
import UIKit

struct PhotoManager {
    static func requestAuthorization() async -> Bool {
        let auth = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        let authResult = switch auth {
        case .authorized, .limited: true
        default: false
        }        
        return authResult
    }
    
    
    
    static func getAssets() -> [PHAsset] {
       let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assetResult = PHAsset.fetchAssets(with: .image, options: options)
        let asset = assetResult.objects(at: .init(0..<assetResult.count))
        
        return asset
    }
    
    static func fetchImage(asset: PHAsset, complete: @escaping (UIImage?) -> Void) {
     let manager = PHCachingImageManager()
        manager.requestImage(for: asset, targetSize: .init(width: 60, height: 60), contentMode: .aspectFill, options: nil) { image, _ in
            complete(image)
        }
    }
}
