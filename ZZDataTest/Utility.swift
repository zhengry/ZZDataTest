//
//  Utility.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/19.
//  Copyright © 2019 ZRY. All rights reserved.
//

import Foundation

let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
let cachesPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first

let libraryURL = URL(fileURLWithPath: libraryPath!, isDirectory: true)
let preferPath = libraryURL.appendingPathComponent("Preferences")
let tmpPath = NSTemporaryDirectory()


