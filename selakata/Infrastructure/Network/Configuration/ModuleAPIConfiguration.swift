//
//  ModuleAPIConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class ModuleAPIConfiguration : BaseAPIConfiguration{
    func makeModuleURL() -> URL? {
        makeURL(path: "/pub/modul")
    }
}
