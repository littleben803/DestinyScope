//
//  JSONResourceLoader.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

enum JSONResourceLoaderError: LocalizedError {
    case fileNotFound(name: String, subdirectory: String?)
    case readFailed(URL)
    case decodeFailed(name: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case let .fileNotFound(name, subdirectory):
            if let subdirectory {
                return "本地 JSON 资源未找到：\(subdirectory)/\(name).json"
            }
            return "本地 JSON 资源未找到：\(name).json"
        case let .readFailed(url):
            return "本地 JSON 资源读取失败：\(url.lastPathComponent)"
        case let .decodeFailed(name, underlying):
            return "本地 JSON 资源解析失败：\(name).json，\(underlying.localizedDescription)"
        }
    }
}

struct JSONResourceLoader {
    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func load<T: Decodable>(_ type: T.Type, named name: String, subdirectory: String? = nil) throws -> T {
        guard let url = bundle.url(forResource: name, withExtension: "json", subdirectory: subdirectory) else {
            throw JSONResourceLoaderError.fileNotFound(name: name, subdirectory: subdirectory)
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONResourceLoaderError.readFailed(url)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONResourceLoaderError.decodeFailed(name: name, underlying: error)
        }
    }
}
