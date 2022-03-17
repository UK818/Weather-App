import Foundation

struct Weather: Codable {
	var main: String?
	var temp: Double?
	var humidity: Double?
	var temp_min: Double?
	var temp_max: Double?
}

struct WeatherMain: Codable {
	let main: Weather
}

struct WeatherData: Codable {
	let list : [List]?
}

struct Main: Codable {
	let temp : Float?
	let temp_max: Float?
	let temp_min: Float?
	let feels_like: Float?
	let humidity: Float?
}

struct Weather2: Codable {
	let main: String?
	let description: String?
	let icon: String?
}

struct List: Codable {
	let main: Main
	let weather: [Weather2]
	var dt_txt: String
}
