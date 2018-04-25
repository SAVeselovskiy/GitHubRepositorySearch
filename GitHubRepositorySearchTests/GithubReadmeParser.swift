//
//  GithubReadmeParser.swift
//  GitHubRepositorySearchTests
//
//  Created by Сергей Веселовский on 22/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import XCTest
//import Foundation

class GithubReadmeParser: XCTestCase {
    var provider: BackendProvider?
    var gitgubProvider: GitHubApiProvider?
    var response: Data?
    var content: String?
    override func setUp() {
        super.setUp()
        self.provider = BackendProvider()
        self.gitgubProvider = GitHubApiProvider()
        
        //Need save this to file, then loads
        content = """
        IyBIUExUYWdDbG91ZEdlbmVyYXRvcgoKQ3JlYXRlIHRhZyBjbG91ZHMgb24g\naU9TLiBBbGdvcml0aG0gYmFzZWQgb24gaHR0cDovL3N0YWNrb3ZlcmZsb3cu\nY29tL2EvMTQ3ODMxNC8xNDU0NjM0LCB1c2luZyBhbiBbQXJjaGltZWRlYW4g\nc3BpcmFsXShodHRwOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL0FyY2hpbWVk\nZWFuX3NwaXJhbCkKCiMjIyBFeGFtcGxlCgo8cCBhbGlnbj0iY2VudGVyIj4K\nICA8aW1nIHNyYz0iaHR0cDovL2kuaW1ndXIuY29tL1NFeWg1WXEucG5nIiBo\nZWlnaHQ9IjUwJSIgd2lkdGg9ImF1dG8iIC8+CjwvcD4KCiMjIEluc3RhbGxh\ndGlvbgoKSW5zdGFsbCBmcm9tIGNvY29hcG9kczoKCmBgYApwb2QgJ0hQTFRh\nZ0Nsb3VkR2VuZXJhdG9yJywgJ34+IDAuMC4zJwpgYGAKCiMjIFVzYWdlCgpg\nYGBvYmplY3RpdmUtYwpkaXNwYXRjaF9hc3luYyggZGlzcGF0Y2hfZ2V0X2ds\nb2JhbF9xdWV1ZShESVNQQVRDSF9RVUVVRV9QUklPUklUWV9ERUZBVUxULCAw\nKSwgXnsKICAgIC8vIFRoaXMgcnVucyBpbiBhIGJhY2tncm91bmQgdGhyZWFk\nCgogICAgLy8gZGljdGlvbmFyeSBvZiB0YWdzCiAgICBOU0RpY3Rpb25hcnkg\nKnRhZ0RpY3QgPSBAe0AidGFnMSI6IEAzLAogICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICBAInRhZzIiOiBANSwKICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgQCJ0YWczIjogQDcsCiAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgIEAidGFnNCI6IEAyfTsKCgogICAgSFBMVGFnQ2xvdWRHZW5lcmF0\nb3IgKnRhZ0dlbmVyYXRvciA9IFtbSFBMVGFnQ2xvdWRHZW5lcmF0b3IgYWxs\nb2NdIGluaXRdOwogICAgdGFnR2VuZXJhdG9yLnNpemUgPSBDR1NpemVNYWtl\nKHNlbGYudGFnVmlldy5mcmFtZS5zaXplLndpZHRoLCBzZWxmLnRhZ1ZpZXcu\nZnJhbWUuc2l6ZS5oZWlnaHQpOwogICAgdGFnR2VuZXJhdG9yLnRhZ0RpY3Qg\nPSB0YWdEaWN0OwoKICAgIE5TQXJyYXkgKnZpZXdzID0gW3RhZ0dlbmVyYXRv\nciBnZW5lcmF0ZVRhZ1ZpZXdzXTsKCiAgICBkaXNwYXRjaF9hc3luYyggZGlz\ncGF0Y2hfZ2V0X21haW5fcXVldWUoKSwgXnsKICAgICAgICAvLyBUaGlzIHJ1\nbnMgaW4gdGhlIFVJIFRocmVhZAoKICAgICAgICBmb3IoVUlWaWV3ICp2IGlu\nIHZpZXdzKSB7CiAgICAgICAgICAgIC8vIEFkZCB0YWdzIHRvIHRoZSB2aWV3\nIHdlIGNyZWF0ZWQgaXQgZm9yCiAgICAgICAgICAgIFtzZWxmLnRhZ1ZpZXcg\nYWRkU3Vidmlldzp2XTsKICAgICAgICB9CgogICAgfSk7Cn0pOwpgYGAKCiMj\nIEF1dGhvcnMKCiogW01hdHRoZXcgQ29ubGVuXShodHRwOi8vd3d3LmdpdGh1\nYi5jb20vbWF0aGlzb25pYW4pIG1jQG1hdGhpc29uaWFuLmNvbQoKIyMgTGlj\nZW5zZQoKVGhlIE1JVCBMaWNlbnNlIChNSVQpCgpDb3B5cmlnaHQgKGMpIDIw\nMTMgSHVmZmluZ3RvbiBQb3N0IExhYnMKClBlcm1pc3Npb24gaXMgaGVyZWJ5\nIGdyYW50ZWQsIGZyZWUgb2YgY2hhcmdlLCB0byBhbnkgcGVyc29uIG9idGFp\nbmluZyBhIGNvcHkKb2YgdGhpcyBzb2Z0d2FyZSBhbmQgYXNzb2NpYXRlZCBk\nb2N1bWVudGF0aW9uIGZpbGVzICh0aGUgIlNvZnR3YXJlIiksIHRvIGRlYWwK\naW4gdGhlIFNvZnR3YXJlIHdpdGhvdXQgcmVzdHJpY3Rpb24sIGluY2x1ZGlu\nZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlIHJpZ2h0cwp0byB1c2UsIGNvcHks\nIG1vZGlmeSwgbWVyZ2UsIHB1Ymxpc2gsIGRpc3RyaWJ1dGUsIHN1YmxpY2Vu\nc2UsIGFuZC9vciBzZWxsCmNvcGllcyBvZiB0aGUgU29mdHdhcmUsIGFuZCB0\nbyBwZXJtaXQgcGVyc29ucyB0byB3aG9tIHRoZSBTb2Z0d2FyZSBpcwpmdXJu\naXNoZWQgdG8gZG8gc28sIHN1YmplY3QgdG8gdGhlIGZvbGxvd2luZyBjb25k\naXRpb25zOgoKVGhlIGFib3ZlIGNvcHlyaWdodCBub3RpY2UgYW5kIHRoaXMg\ncGVybWlzc2lvbiBub3RpY2Ugc2hhbGwgYmUgaW5jbHVkZWQgaW4KYWxsIGNv\ncGllcyBvciBzdWJzdGFudGlhbCBwb3J0aW9ucyBvZiB0aGUgU29mdHdhcmUu\nCgpUSEUgU09GVFdBUkUgSVMgUFJPVklERUQgIkFTIElTIiwgV0lUSE9VVCBX\nQVJSQU5UWSBPRiBBTlkgS0lORCwgRVhQUkVTUyBPUgpJTVBMSUVELCBJTkNM\nVURJTkcgQlVUIE5PVCBMSU1JVEVEIFRPIFRIRSBXQVJSQU5USUVTIE9GIE1F\nUkNIQU5UQUJJTElUWSwKRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBP\nU0UgQU5EIE5PTklORlJJTkdFTUVOVC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhF\nCkFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERFUlMgQkUgTElBQkxFIEZPUiBB\nTlkgQ0xBSU0sIERBTUFHRVMgT1IgT1RIRVIKTElBQklMSVRZLCBXSEVUSEVS\nIElOIEFOIEFDVElPTiBPRiBDT05UUkFDVCwgVE9SVCBPUiBPVEhFUldJU0Us\nIEFSSVNJTkcgRlJPTSwKT1VUIE9GIE9SIElOIENPTk5FQ1RJT04gV0lUSCBU\nSEUgU09GVFdBUkUgT1IgVEhFIFVTRSBPUiBPVEhFUiBERUFMSU5HUyBJTgpU\nSEUgU09GVFdBUkUuCg==\n

        """
        let body = """
{
    "name": "README.md",
    "path": "README.md",
    "sha": "90b89bd8e0e9074377846d343c0d5d53311dc14c",
    "size": 26584,
    "url": "https://api.github.com/repos/octokit/octokit.rb/contents/README.md?ref=master",
    "html_url": "https://github.com/octokit/octokit.rb/blob/master/README.md",
    "git_url": "https://api.github.com/repos/octokit/octokit.rb/git/blobs/90b89bd8e0e9074377846d343c0d5d53311dc14c",
    "download_url": "https://raw.githubusercontent.com/octokit/octokit.rb/master/README.md",
    "type": "file",
    "content": ",
    "encoding": "base64",
    "_links": {
        "self": "https://api.github.com/repos/octokit/octokit.rb/contents/README.md?ref=master",
        "git": "https://api.github.com/repos/octokit/octokit.rb/git/blobs/90b89bd8e0e9074377846d343c0d5d53311dc14c",
        "html": "https://github.com/octokit/octokit.rb/blob/master/README.md"
    }
}
"""
        self.response = body.data(using: .utf8)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadingReadme() {
        
        if let encodedString = content {
            let str = encodedString.base64Decoded()
            if str == nil {
                XCTFail()
            }
            print(str ?? "")
        }
        else {
            XCTFail()
        }
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
