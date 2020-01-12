//
//  SignalInfoFetcher.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

public enum SignalInfoFetcherError: Error {
    case noInfo
}

public protocol SignalInfoFetcherProtocol: AnyObject {
    typealias SignalFetchCompletion = (Result<SignalInfo, Error>) -> Void
    func fetchInfo(routerAddress: URL, completion: @escaping SignalFetchCompletion)
}

public final class SignalInfoFetcher: SignalInfoFetcherProtocol {
    private let urlSession: URLSession

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public init(configuration: URLSessionConfiguration = .ephemeral) {
        self.urlSession = URLSession(configuration: configuration)
    }

    // MARK: - SignalInfoFetcherProtocol

    public func fetchInfo(routerAddress: URL, completion: @escaping SignalFetchCompletion) {
        if self.hasSessionId(routerAddress: routerAddress) {
            self.fetchInfoFromSession(routerAddress: routerAddress, completion: completion)
        } else {
            self.fetchSessionId(routerAddress: routerAddress) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.fetchInfoFromSession(routerAddress: routerAddress, completion: completion)
                }
            }
        }
    }

    // MARK: - Private

    private func hasSessionId(routerAddress: URL) -> Bool {
        let cookies = HTTPCookieStorage.shared.cookies(for: routerAddress)
        return cookies?.contains(where: { $0.name == "SessionID" && $0.value.isEmpty == false }) ?? false
    }

    private func fetchInfoFromSession(routerAddress: URL, completion: @escaping SignalFetchCompletion) {
        let fullURL = routerAddress.appendingPathComponent("api/device/signal")
        let request = URLRequest(url: fullURL)
        let task = self.urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let parserDelegate = ParserDelegate()
                let xmlParser = XMLParser(data: data)
                xmlParser.delegate = parserDelegate
                if xmlParser.parse(), let results = parserDelegate.results {
                    let sinrStringOptional = results["sinr"]?
                        .replacingOccurrences(of: "dBm", with: "")
                        .replacingOccurrences(of: "dB", with: "")
                    let rsrqStringOptional = results["rsrq"]?
                        .replacingOccurrences(of: "dBm", with: "")
                        .replacingOccurrences(of: "dB", with: "")
                    let rsrpStringOptional = results["rsrp"]?
                        .replacingOccurrences(of: "dBm", with: "")
                        .replacingOccurrences(of: "dB", with: "")
                    let rssiStringOptional = results["rssi"]?
                        .replacingOccurrences(of: "dBm", with: "")
                        .replacingOccurrences(of: "dB", with: "")
                    if let sinrString = sinrStringOptional,
                        let sinrNumber = Float(sinrString),
                        let rsrqString = rsrqStringOptional,
                        let rsrqNumber = Float(rsrqString),
                        let rsrpString = rsrpStringOptional,
                        let rsrpNumber = Float(rsrpString),
                        let rssiString = rssiStringOptional,
                        let rssiNumber = Float(rssiString) {
                        let sinr = SignalLevel(sinr: .init(rawValue: sinrNumber))
                        let rsrq = SignalLevel(rsrq: .init(rawValue: rsrqNumber))
                        let rsrp = SignalLevel(rsrp: .init(rawValue: rsrpNumber))
                        let rssi = SignalLevel(rssi: .init(rawValue: rssiNumber))
                        let info = SignalInfo(
                            sinr: sinr,
                            rssi: rssi,
                            rsrq: rsrq,
                            rsrp: rsrp
                        )
                        completion(.success(info))
                    }
                } else {
                    completion(.failure(SignalInfoFetcherError.noInfo))
                }
            } else {
                completion(.failure(SignalInfoFetcherError.noInfo))
            }
        }
        task.resume()
    }

    private func fetchSessionId(routerAddress: URL, completion: @escaping (Error?) -> Void) {
        let request = URLRequest(url: routerAddress)
        let task = self.urlSession.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    // MARK: - XMLParserDelegate

    private final class ParserDelegate: NSObject, XMLParserDelegate {
        private var currentDictionary: [String: String]?
        private var currentValue: String?
        var results: [String: String]?

        public func parser(_ parser: XMLParser,
                           didStartElement elementName: String,
                           namespaceURI: String?,
                           qualifiedName qName: String?,
                           attributes attributeDict: [String: String]) {
            if elementName == "response" {
                self.currentDictionary = [:]
            } else if self.currentDictionary != nil {
                self.currentValue = ""
            }
        }

        public func parser(_ parser: XMLParser,
                           foundCharacters string: String) {
            self.currentValue? += string
        }

        public func parser(_ parser: XMLParser,
                           didEndElement elementName: String,
                           namespaceURI: String?,
                           qualifiedName qName: String?) {
            if elementName == "response" {
                self.results = self.currentDictionary
                self.currentDictionary = nil
            } else if self.currentDictionary != nil, let value = self.currentValue {
                self.currentDictionary?[elementName] = value
                self.currentValue = nil
            }
        }

        public func parser(_ parser: XMLParser,
                           parseErrorOccurred parseError: Error) {
            self.currentValue = nil
            self.currentDictionary = nil
            self.results = nil
        }
    }
}
