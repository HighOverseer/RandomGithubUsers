import Foundation

class NetworkService {
    private static let baseURL = "https://api.github.com/users"
    private static let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String
    private static let userCount = "20"

    private let decoder = JSONDecoder()

    func getListUserRandom() async -> (String?, [UserPreview]) {
        return await callApi(
            setupUrlComponents: {
                var urlComponents = URLComponents(string: NetworkService.baseURL)!
                let since = Int.random(in: 1 ... 1000)

                urlComponents.queryItems = [
                    URLQueryItem(name: "per_page", value: NetworkService.userCount),
                    URLQueryItem(name: "since", value: String(since)),
                ]
                return urlComponents
            },
            onSuccess: { (dataResponse: [UserPreviewResponse]) in
                (nil, dataResponse.map { dataResponse in
                    ResponseMapper.shared.mapUserPreviewResponse(response: dataResponse)
                })
            },
            onFailure: { message in
                (message, [])
            }
        )
    }

    func getUserDetail(username: String) async -> (String?, UserDetail?) {
        return await callApi(
            setupUrlComponents: {
                let url = NetworkService.baseURL + "/\(username)"
                let urlComponents = URLComponents(string: url)!
                return urlComponents
            },
            onSuccess: { dataResponse in
                (nil, ResponseMapper.shared.mapUserDetailResponse(response: dataResponse))
            },
            onFailure: { message in
                (message, nil)
            }
        )
    }

    private func callApi<DataResponse: Codable, ExpectedType>(
        setupUrlComponents: () -> URLComponents,
        onSuccess: (DataResponse) -> (String?, ExpectedType),
        onFailure: (String) -> (String, ExpectedType)
    ) async -> (String?, ExpectedType) {
        guard let _token = NetworkService.token else {
            return onFailure("Token Not Found...")
        }

        let urlComponents = setupUrlComponents()

        var request = URLRequest(url: urlComponents.url!)
        request.setValue("Bearer \(_token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let res = (response as? HTTPURLResponse) else {
                return onFailure(
                    "Error when fetching data.."
                )
            }

            guard (200 ... 299).contains(res.statusCode) else {
                return onFailure(
                    "Error when fetching data. Status Code : \(res.statusCode)"
                )
            }

            let listDataResponse = try decoder.decode(DataResponse.self, from: data)
            return onSuccess(listDataResponse)
        } catch {
            return onFailure(error.localizedDescription)
        }
    }
}
