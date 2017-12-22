//
//  TestJSONS.swift
//  ChildTests
//
//  Created by Tiziano Coroneo on 23/12/2017.
//

import Foundation
import XCTest

extension XCTestCase {
    
    var smallJsonTest1: String { return """

{
    "result": [
        {
            "id": 1,
            "user_id": 2,
            "date_time": "2017-11-14 16:42:29",
            "summary": "Test Description",
            "ratings": {
                "quality": "5",
                "communication": "2",
                "deadline": "3",
                "professionalism": "4",
                "terms_of_payment": "5",
                "project_description": "3"
            },
            "user": {
                "id": 3,
                "first_name": "test-name",
                "last_name": "test-last-name",
                "profile_img": null
            }
        }
    ]
}

"""
    }
    
    var bigJsonTest: String { return """

{
    "result": [
        {
            "id": 2,
            "firstName": "Daan",
            "lastName": "Heikens",
            "description": null,
            "subscriptionType": null,
            "averageRating": 6,
            "hourlyRate": 0,
            "currency": {
                "id": 1,
                "name": "EUR",
                "sign": "€"
            },
            "friendsInCommon": 4,
            "location": {
                "lat": 52.015411,
                "lng": 4.321424
            },
            "currentProjects": 2,
            "totalProjects": 3,
            "skills": [
                {
                    "name": "PHP"
                },
                {
                    "name": "HTML"
                },
                {
                    "name": "JAVA"
                },
                {
                    "name": "C#\r\n"
                }
            ],
            "emailVerified": false,
            "phoneVerified": false,
            "responseTime": 1,
            "contactStatus": 1,
            "contacts": {
                "id": 4,
                "imgUrl": null,
                "firstName": "test",
                "lastName": "test_last_name"
            },
            "sharedContacts": {
                "id": 4,
                "imgUrl": null,
                "firstName": "test",
                "lastName": "test_last_name"
            },
            "teams": [],
            "portfolio": [
                {
                    "id": "3",
                    "picture": "9930385ecf6505fcf81576460935772b.jpg",
                    "title": "Webdesign Fashion",
                    "summary": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna",
                    "websiteUrl": null,
                    "fileUrl": "45d02a1d8b99f86b5ed57bdbdc69bf80.pdf",
                    "userId": "2"
                },
                {
                    "id": "4",
                    "picture": "9be9fdddda68be9a9a163ef1e7752f00.jpg",
                    "title": "UI Development",
                    "summary": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna",
                    "websiteUrl": null,
                    "fileUrl": "a7545541850c51eeea70d0c13a67949f.pdf",
                    "userId": "2"
                }
            ],
            "pastProjects": {
                "external": {
                    "id": 1,
                    "name": "Title",
                    "summary": "Description",
                    "start_year": "2017-11-05 00:00:00",
                    "end_year": "2017-11-10 00:00:00",
                    "deliverable_url": "d-tt.nl",
                    "budget_type": 1,
                    "budget_min": 1,
                    "budget_max": 100000
                },
                "internal": {
                    "id": 3,
                    "name": "Programmer needed for website",
                    "summary": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
                    "posted_at": "2017-11-16 08:40:51",
                    "posted_by": {
                        "id": 2,
                        "first_name": "Daan",
                        "last_name": "Heikens"
                    },
                    "deliverable_url": "d-tt.nl"
                }
            },
            "feedback": [
                {
                    "freelancer": {
                        "quality": 0,
                        "communication": 0,
                        "deadline": 0,
                        "professionalism": 0
                    }
                },
                {
                    "employer": {
                        "quality": 3,
                        "communication": 3.5,
                        "deadline": 2.5,
                        "professionalism": 3,
                        "terms_of_payment": 4.5,
                        "project_description": 3
                    }
                }
            ]
        }
    ]
}

"""
    }
    
}
