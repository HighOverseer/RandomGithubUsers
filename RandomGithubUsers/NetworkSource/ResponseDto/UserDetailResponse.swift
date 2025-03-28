struct UserDetailResponse: Codable {
    let username: String
    let imageUrl: String
    let name: String?
    let repoCount: Int
    let followersCount: Int
    let followingCount: Int
    let profileUrl: String

    let company: String?
    let location: String?
    let email: String?
    let blog: String?

    let bio: String?

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case imageUrl = "avatar_url"
        case name
        case repoCount = "public_repos"
        case followersCount = "followers"
        case followingCount = "following"
        case company
        case bio
        case location
        case email
        case blog
        case profileUrl = "html_url"
    }
}
