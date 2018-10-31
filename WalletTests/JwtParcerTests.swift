//
//  JwtParcerTests.swift
//  WalletTests
//
//  Created by Daniil Miroshnichecko on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

class JwtParcerTests: XCTestCase {
    
    let jwtParcer = JwtTokenParser()
    
    // MARK: Given
    let jwtToken_1 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjo2MCwiZXhwIjoxNTQwMjIzNjk4LCJwcm92aWRlciI6IkVtYWlsIn0.elW5tLoixtCnZHmHK70UTAZIpvLtbb8eTONPoV3N812lSXH5Sm-zWqhFQMwF8toUqQLA3dAkmxmlWOXuCHmJjY02O7xvSRHR8ecizhFRW6YkRNbCBVQIRaTod1hIt7BmrvazMREnlE6_Ry1CpNzCiOeSfWmhY-xb0PZpUKZonrEsff3oJQch74BiCRqnZkCkCnVRCY6QXoL8j5hf-LWDXr5kRS5Jzu9pb3d12Juw-_EMvULYjZ23qbXJDfRJCgwO4tYsiLsAe-qZyP-tPlfHE6-FFrqpRF9e7q7I8N0N5Myn8zjxcIry7M1i6K3580cfNNpkrWq1IXRy_biVaSQWOA"
    let jwtToken_2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjo2MSwiZXhwIjoxNTQwMjIzODUwLCJwcm92aWRlciI6IkVtYWlsIn0.O_zmBvqGw705n_LUNpXwdDs8MVezh4yjKdN4W8X_oAbu_Z6xTV1oV3VecXPr_SL1BYeVnySaeLGpjIvuHXprSnYarklN1Eb6v5iIGcRMLn46EDAplvlg_L-RyKtB53qHa9A837K7e_89I-2yFUfS0v-BDWfYG_H1Mi6Vk_cygdr0HGM6PXAXuFDUV_GMAW_HvGiC24vcZVQVWT83v65g9A8hhYFukyAyX-yIkAIeoqPhwjiH_vHkTWFEhgSqw-ocJq7z90ufefeD1PR-KyglAw8i65TxzjHgq1Dqrl6C1Uv5ufsfLsDp84oLE9-pHaYvx6cKS20Nu59tI8RnUuBb0Q"
    let jwtToken_3 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjo2MCwiZXhwIjoxNTQwMjg1MzY0LCJwcm92aWRlciI6IkVtYWlsIn0.qmMpSyMWbTFH22W6qT4pxPDh-SZmY6vZoE_C2uC8tqDug171EqQZt6_f8nhkWdo6LhitgNKlPa4oAWWX0XAdnLcrUpmNs0Cu7CEjzJgusIz_I6-BI41eupsvludCArM8ldesD3jLf880_ViN1zymaA8d-0DuxU3Jc_4kRIgfm52Kzwp2WJdY8XJz5NetXWihz95d79CTmsJ8CMj1m-8mw7kddxHXXaFj4wcmiKhq-UrB49JBLFKwldyO5Mn9Elh1NzM0uLFKa58GvDNVK6GuYLZnCcZ8FFIOCn7dHy8ZXuKYGDJpl6XM8gi2boxPk7D25OXaMH2cs8GVELVfbhXw_A"
    
    override func setUp() {
     
    }
    
    func testParser() {
        let authToken_1 = jwtParcer.parse(jwtToken: jwtToken_1)
        XCTAssertEqual(authToken_1!.token, jwtToken_1)
        XCTAssertEqual(authToken_1!.expiredTimeStamp, 1540223698)
        XCTAssertEqual(authToken_1!.userId, 60)
        
        let authToken_2 = jwtParcer.parse(jwtToken: jwtToken_2)
        XCTAssertEqual(authToken_2!.token, jwtToken_2)
        XCTAssertEqual(authToken_2!.expiredTimeStamp, 1540223850)
        XCTAssertEqual(authToken_2!.userId, 61)
        
        let authToken_3 = jwtParcer.parse(jwtToken: jwtToken_3)
        XCTAssertEqual(authToken_3!.token, jwtToken_3)
        XCTAssertEqual(authToken_3!.expiredTimeStamp, 1540285364)
        XCTAssertEqual(authToken_3!.userId, 60)
    }
}
