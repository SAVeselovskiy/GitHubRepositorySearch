//
//  GithubApiParsingTest.swift
//  GitHubRepositorySearchTests
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import XCTest

class GithubApiParsingTest: XCTestCase {
    var provider: BackendProvider?
    var gitgubProvider: GitHubApiProvider?
    var response: Data?

    override func setUp() {
        super.setUp()
        self.provider = BackendProvider()
        self.gitgubProvider = GitHubApiProvider()
        let body = """
{
"total_count": 16,
"incomplete_results": false,
"items": [
{
"id": 8262673,
"name": "Ios-Tag-cloud",
"full_name": "santanu1122/Ios-Tag-cloud",
"owner": {
"login": "santanu1122",
"id": 1969601,
"avatar_url": "https://avatars2.githubusercontent.com/u/1969601?v=4",
"gravatar_id": "",
"url": "https://api.github.com/users/santanu1122",
"html_url": "https://github.com/santanu1122",
"followers_url": "https://api.github.com/users/santanu1122/followers",
"following_url": "https://api.github.com/users/santanu1122/following{/other_user}",
"gists_url": "https://api.github.com/users/santanu1122/gists{/gist_id}",
"starred_url": "https://api.github.com/users/santanu1122/starred{/owner}{/repo}",
"subscriptions_url": "https://api.github.com/users/santanu1122/subscriptions",
"organizations_url": "https://api.github.com/users/santanu1122/orgs",
"repos_url": "https://api.github.com/users/santanu1122/repos",
"events_url": "https://api.github.com/users/santanu1122/events{/privacy}",
"received_events_url": "https://api.github.com/users/santanu1122/received_events",
"type": "User",
"site_admin": false
},
"private": false,
"html_url": "https://github.com/santanu1122/Ios-Tag-cloud",
"description": null,
"fork": false,
"url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud",
"forks_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/forks",
"keys_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/keys{/key_id}",
"collaborators_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/collaborators{/collaborator}",
"teams_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/teams",
"hooks_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/hooks",
"issue_events_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/issues/events{/number}",
"events_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/events",
"assignees_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/assignees{/user}",
"branches_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/branches{/branch}",
"tags_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/tags",
"blobs_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/git/blobs{/sha}",
"git_tags_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/git/tags{/sha}",
"git_refs_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/git/refs{/sha}",
"trees_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/git/trees{/sha}",
"statuses_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/statuses/{sha}",
"languages_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/languages",
"stargazers_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/stargazers",
"contributors_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/contributors",
"subscribers_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/subscribers",
"subscription_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/subscription",
"commits_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/commits{/sha}",
"git_commits_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/git/commits{/sha}",
"comments_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/comments{/number}",
"issue_comment_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/issues/comments{/number}",
"contents_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/contents/{+path}",
"compare_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/compare/{base}...{head}",
"merges_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/merges",
"archive_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/{archive_format}{/ref}",
"downloads_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/downloads",
"issues_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/issues{/number}",
"pulls_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/pulls{/number}",
"milestones_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/milestones{/number}",
"notifications_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/notifications{?since,all,participating}",
"labels_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/labels{/name}",
"releases_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/releases{/id}",
"deployments_url": "https://api.github.com/repos/santanu1122/Ios-Tag-cloud/deployments",
"created_at": "2013-02-18T06:05:50Z",
"updated_at": "2013-02-18T06:05:51Z",
"pushed_at": "2013-02-18T06:05:51Z",
"git_url": "git://github.com/santanu1122/Ios-Tag-cloud.git",
"ssh_url": "git@github.com:santanu1122/Ios-Tag-cloud.git",
"clone_url": "https://github.com/santanu1122/Ios-Tag-cloud.git",
"svn_url": "https://github.com/santanu1122/Ios-Tag-cloud",
"homepage": null,
"size": 56,
"stargazers_count": 0,
"watchers_count": 0,
"language": null,
"has_issues": true,
"has_projects": true,
"has_downloads": true,
"has_wiki": true,
"has_pages": false,
"forks_count": 0,
"mirror_url": null,
"archived": false,
"open_issues_count": 0,
"license": null,
"forks": 0,
"open_issues": 0,
"watchers": 0,
"default_branch": "master",
"score": 20.810734
}
]
}
"""
        self.response = body.data(using: .utf8)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadingSearchResults() {
        let expectation = XCTestExpectation(description: "Download test search list")
        gitgubProvider?.loadSearchResults(for: "Tag Cloud iOS", success: { (results) in
            expectation.fulfill()
        }, failure: { (error) in
            var loadingError = error
            if error == nil {
                loadingError = NSError(domain: "VSSearchList", code: 500, userInfo: nil)
            }
            print(loadingError?.localizedDescription as Any)
            expectation.fulfill()
            XCTFail()
        })
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testParsing() {
        if let body = self.response {
            let expectation = XCTestExpectation(description: "Download test search list")
            let successBlock: (GithubSearchResult)->() = {_ in
                expectation.fulfill()
            }
            provider?.decodeJSON(data: body, success: successBlock, failure: { (error) in
                var loadingError = error
                if error == nil {
                    loadingError = NSError(domain: "VSSearchList", code: 500, userInfo: nil)
                }
                print(loadingError?.localizedDescription as Any)
                expectation.fulfill()
                XCTFail()
            })
            wait(for: [expectation], timeout: 15.0)
        }
        else {
            XCTFail()
        }
    }
}
