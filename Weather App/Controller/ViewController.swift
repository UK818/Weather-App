//
//  ViewController.swift
//  Weather App
//
//  Created by mac on 05/11/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
	
	@IBOutlet weak var forecastTable: UITableView!
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var tempMain: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var tempDesc: UILabel!
	@IBOutlet weak var tempMax: UILabel!
	@IBOutlet weak var tempMin: UILabel!
	
	var currentDataLoader: DataLoader?
	var forecastDataLoader: DataLoader?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		config()
	}
	
	private func config() {
		forecastTable.delegate = self
		forecastTable.dataSource = self
		
		currentDataLoader = DataLoader()
		currentDataLoader?.pullJsonData(url: currentDataLoader?.url, forecast: false) {
			self.updateCurrentData()
		}
		
		forecastDataLoader = DataLoader()
		forecastDataLoader?.pullJsonData(url: forecastDataLoader?.url2, forecast: true){
			self.forecastTable.reloadData()
		}
	}
	
	func updateCurrentData() {
		let sunnyColor = UIColor(red: 71/225, green: 171/225, blue: 47/225, alpha: 1)
		let cloudyColor = UIColor(red: 84/225, green: 113/225, blue: 124/225, alpha: 1)
		let rainyColor = UIColor(red: 87/225, green: 87/225, blue: 93/225, alpha: 1)
		self.tempMain.text = String(Int((currentDataLoader?.currentWeather?.main.temp)!) - 273) + "°"
		self.tempMax.text = String(Int((currentDataLoader?.currentWeather?.main.temp_max)!) - 273) + "°"
		self.tempMin.text = String(Int((currentDataLoader?.currentWeather?.main.temp_min)!) - 273) + "°"
		self.tempLabel.text = String(Int((currentDataLoader?.currentWeather?.main.temp)!) - 273) + "°"
		
		switch currentDataLoader?.currentWeather?.main.main ?? "Clear" {
			case "Clear":
				self.tempDesc.text = "SUNNY"
				self.mainImage.image = UIImage(named: "forest_sunny")
				forecastTable.backgroundColor = UIColor(red: 71/225, green: 171/225, blue: 47/225, alpha: 1)
				self.view.layer.backgroundColor = sunnyColor.cgColor
			case "Clouds":
				self.tempDesc.text = "CLOUDY"
				self.mainImage.image = UIImage(named: "forest_cloudy")
				forecastTable.backgroundColor = UIColor(red: 84/225, green: 113/225, blue: 124/225, alpha: 1)
				self.view.layer.backgroundColor = cloudyColor.cgColor
			case "Rainy":
				self.tempDesc.text = "RAINY"
				self.mainImage.image = UIImage(named: "forest_rainy")
				forecastTable.backgroundColor = UIColor(red: 87/225, green: 87/225, blue: 93/225, alpha: 1)
				self.view.layer.backgroundColor = rainyColor.cgColor
			default:
				self.tempDesc.text = "SUNNY"
				self.mainImage.image = UIImage(named: "forest_sunny")
				forecastTable.backgroundColor = UIColor(red: 71/225, green: 171/225, blue: 47/225,alpha: 1)
				self.view.layer.backgroundColor = sunnyColor.cgColor
		}
		forecastTable.reloadData()
	}
	

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DailyForecastCell else {
			fatalError("unable to dequeue")
		}
		
		let dtTxt = forecastDataLoader?.weatherData?.list?[indexPath.row * 8 + 5].dt_txt
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.timeZone = TimeZone.current
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let dateValue = dtTxt ?? ""
		let date = dateFormatter.date(from: dateValue) ?? Date.now
		let dayOfWeek = Calendar.current.component(.weekday, from: date)
		let day = Calendar.current.weekdaySymbols[dayOfWeek - 1]
		cell.day.text = day
		cell.temperature.text = String(Int(forecastDataLoader?.weatherData?.list![indexPath.row * 8 + 5].main.temp ?? 293) - 273) + "°"
		let image = forecastDataLoader?.weatherData?.list![indexPath.row * 8 + 5].weather[0].main
		switch image ?? "Clear"{
			case "Clear": cell.weatherImage.image = UIImage(systemName: "sun.max")
			case "Clouds": cell.weatherImage.image = UIImage(systemName: "cloud")
			default: cell.weatherImage.image = UIImage(systemName: "cloud.rain")
		}
		
		switch currentDataLoader?.currentWeather?.main.main ?? "Clear" {
			case "Clear": cell.backgroundColor = UIColor(red: 71/225, green: 171/225, blue: 47/225, alpha: 1)
			case "Clouds": cell.backgroundColor = UIColor(red: 84/225, green: 113/225, blue: 124/225, alpha: 1)
			default: cell.backgroundColor = UIColor(red: 87/225, green: 87/225, blue: 93/225, alpha: 1)
		}
		return cell
	}

}

