
import UIKit
import CoreLocation
import Foundation

@IBDesignable
class CarouselItem: UIView, UITableViewDelegate, CLLocationManagerDelegate, UITableViewDataSource {
    
    @IBOutlet var vwContent: UIView!
    
    @IBOutlet weak var table: UITableView!
    
    var myURLComponents = URLComponents()
    let hostForURL = "api.weatherbit.io"
    var locationName: String!
    let keyForRequest = UserDefaults.standard.string(forKey: "key")
    
    var currentObj = [CurrentDataWeatherbit]()
    var hourlyObj = [HourlyDataWeatherbit]()
    var dailyObj = [weatherbitData]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var widthOfVC: CGFloat = 0 //For Header
    var units: String = "M"
    var style = "default"
        
    
    var abc = ""
    static let CAROUSEL_ITEM_NIB = "CarouselItem"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
        if UserDefaults.standard.bool(forKey: "units") == true { units = "I" }
        if UserDefaults.standard.bool(forKey: "style") == true { style = "american" }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(titleText: String?, width: CGFloat, lat: String?, lon: String? = "") {
        self.init()
        locationName = titleText
        widthOfVC = width
        
        getFullDataForView(with: titleText, lat: lat, lon: lon)
        
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(CarouselItem.CAROUSEL_ITEM_NIB, owner: self, options: nil)
        vwContent.frame = bounds
        vwContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(vwContent)
    }
    
    func encodeData(with data: weatherbitData) {
        let a = data
        let encoder = JSONEncoder()
        if let encodedPages = try? encoder.encode(a) {
            UserDefaults.standard.set(encodedPages, forKey: "dailyData")
        }
    }
    
    //MARK: Creating view
    func getFullDataForView(with locationTxt: String?, lat: String?, lon: String?) {
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        table.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)
        table.register(CurrentDayInfoCell.nib(), forCellReuseIdentifier: CurrentDayInfoCell.identifier)
        
        table.delegate = self
        table.dataSource = self

        table.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.table.refreshControl = refreshControl
        
        if locationTxt == "Current" {
            setupLocation()
        }
        if lat != ""  {
            getDataByCoords(with: lat!, lon: lon!)
        }
        else {
            getData(with: locationTxt!) //\(locationName!)
        }
    }
    
    func getDataByCoords(with lat: String, lon: String) {
        CurrentWeatherbitByCoords(with: lat, lon: lon)
        HourlyForecastWeatherbitByCoords(with: lat, lon: lon)
        ForecastWeatherbitByCoords(with: lat, lon: lon)
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if !locations.isEmpty, currentLocation == nil  {
           currentLocation = locations.first
           locationManager.stopUpdatingLocation()
           
           guard let currentLocation = currentLocation else {
               return
           }
        
        ForecastWeatherbitByCoords(with: "\(currentLocation.coordinate.latitude)",lon: "\(currentLocation.coordinate.longitude)")
        CurrentWeatherbitByCoords(with: "\(currentLocation.coordinate.latitude)", lon: "\(currentLocation.coordinate.longitude)")
        HourlyForecastWeatherbitByCoords(with: "\(currentLocation.coordinate.latitude)",lon: "\(currentLocation.coordinate.longitude)")
       }
   }
    
    @objc func refresh(_ sender: Any) {
        if locationName == "Current" {
            setupLocation()
        } else {
            getData(with: locationName!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.table.refreshControl?.endRefreshing()
            self.table.reloadData()
            self.table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
            self.table.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)

            self.table.delegate = self
            self.table.dataSource = self

            self.table.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
        }
    }
    
    func getData(with name: String) {
        CurrentWeatherbit(with: name)
        hourlyForecastWeatherbit(with: name)
        ForecastWeatherbit(with: name)
    }
    //MARK: Header
    
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: widthOfVC, height: widthOfVC - 125))
        
        headerView.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
        
        let locationLabel = UILabel(frame: CGRect(x: 0, y: 45, width: widthOfVC, height: 23 + 5))
        let summaryLabel = UILabel(frame: CGRect(x: 0, y: 54 + 3, width: vwContent.frame.size.width, height:50))
        let tempLabel = UILabel(frame: CGRect(x: 0, y: 74 + 15, width: widthOfVC, height: 60))
        let feelsLikeLabel = UILabel(frame: CGRect(x: 0, y: 134 + 15 , width: widthOfVC - 15, height:15))
        
        let sunriseLabel = UILabel(frame: CGRect(x: widthOfVC / 8 + 10, y: 118 + 20 + 10,width: 80, height: 60))
        let sunriseIcon = UIImageView(frame: CGRect(x: widthOfVC / 8 + 80, y: 161, width:30, height: 26))
        let sunsetLabel = UILabel(frame: CGRect(x: (widthOfVC / 8) * 4 + 10, y: 118 + 30, width:80, height: 60))
        let sunsetIcon = UIImageView(frame: CGRect(x: (widthOfVC / 8) * 4 + 80 + 10 + 5, y: 152 + 9, width:30, height: 27))
        
        let visibilityLabel =  UILabel(frame: CGRect(x: widthOfVC / 8 + 10, y: 138 + 30 + 10, width:80, height: 60))
        let visibilityIcon = UIImageView(frame: CGRect(x: widthOfVC / 8 + 80, y: 155 + 13 + 26, width: 29, height: 26))
        let windSpeedLabel = UILabel(frame: CGRect(x: (widthOfVC / 8) * 4 - 2 + 10, y: 138 + 10 + 30, width: 100, height: 60))
        let windSpeedIcon = UIImageView(frame: CGRect(x: (widthOfVC / 8) * 4 + 80 + 10 + 5, y: 155 + 30 + 8, width: 29, height: 26))
        
        let humidityLabel = UILabel(frame: CGRect(x: widthOfVC / 8 + 10, y: 162 + 15 + 30, width:80, height: 60))
        let humidityIcon = UIImageView(frame: CGRect(x: widthOfVC / 8 + 80, y: 186 + 35, width:30, height: 27))
        let pressureLabel = UILabel(frame: CGRect(x: widthOfVC / 8 * 4 + 12, y: 162 + 35 + 10, width: 80, height: 60))
        let pressureIcon = UIImageView(frame: CGRect(x: (widthOfVC / 8) * 4 + 80 + 15, y: 186 + 20 + 16, width:30, height: 23))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(feelsLikeLabel)
        
        
        headerView.addSubview(sunriseLabel)
        headerView.addSubview(sunriseIcon)
        headerView.addSubview(sunsetLabel)
        headerView.addSubview(sunsetIcon)
        
        headerView.addSubview(visibilityLabel)
        headerView.addSubview(visibilityIcon)
        headerView.addSubview(windSpeedLabel)
        headerView.addSubview(windSpeedIcon)
        
        headerView.addSubview(humidityLabel)
        headerView.addSubview(humidityIcon)
        headerView.addSubview(pressureLabel)
        headerView.addSubview(pressureIcon)
        
        feelsLikeLabel.textAlignment = .center
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        sunriseLabel.textAlignment = .left
        sunsetLabel.textAlignment = .left
        visibilityLabel.textAlignment = .left
        windSpeedLabel.textAlignment = .left
        
        var fontStyle = "HelveticaNeue-Light"
        if style == "american" { fontStyle = ".SFProText-Regular" }
        
        locationLabel.text = "\(currentObj.first!.city_name)"
        locationLabel.font = UIFont(name: fontStyle, size: 36)
        locationLabel.textColor = .white
        summaryLabel.text = "\(currentObj.first!.weather.description)"
        summaryLabel.font = UIFont(name: fontStyle, size: 22)
        summaryLabel.textColor = .white
        tempLabel.text = "\(Int(currentObj.first!.temp))°"
        tempLabel.font = UIFont(name: fontStyle, size: 70)
        tempLabel.textColor = .white
        feelsLikeLabel.text = "Like: \(Int(currentObj.first!.app_temp))°"
        feelsLikeLabel.font = UIFont(name: fontStyle, size: 17)
        feelsLikeLabel.textColor = .white
        
        sunriseLabel.text = "\(currentObj.first!.sunrise)"
        sunriseLabel.font = UIFont(name: fontStyle, size: 22)
        sunriseLabel.textColor = .white
        sunriseIcon.image = UIImage(systemName: "sunrise")
        sunriseIcon.tintColor = .white
        sunsetLabel.text = "\(currentObj.first!.sunset)"
        sunsetLabel.font = UIFont(name: fontStyle, size: 20)
        sunsetLabel.textColor = .white
        sunsetIcon.image = UIImage(systemName: "sunset")
        sunsetIcon.tintColor = .white
        
        visibilityLabel.text = "\(Int(currentObj.first!.vis)) Km"
        visibilityLabel.font = UIFont(name: fontStyle, size: 20)
//        visibilityLabel.font = UIFont(name: "Helvetica-LightOblique", size: 20)
        visibilityLabel.textColor = .white
        visibilityIcon.image = UIImage(systemName: "eye")
        visibilityIcon.tintColor = .white
        windSpeedLabel.text = " \(NSString(format: "%.1f", currentObj.first!.wind_spd)) m"
        windSpeedLabel.font = UIFont(name: fontStyle, size: 20)
//        windSpeedLabel.font = UIFont(name: "Helvetica-LightOblique", size: 20)
        windSpeedLabel.textColor = .white
        windSpeedIcon.image = UIImage(systemName: "wind")
        windSpeedIcon.tintColor = .white
        
        humidityLabel.text = "\(Int(currentObj.first!.rh))%"
        humidityLabel.font = UIFont(name: fontStyle, size: 20)
        humidityLabel.textColor = .white
        humidityIcon.image = UIImage(systemName: "drop")
        humidityIcon.tintColor = .white
        pressureLabel.text = "\(Int(currentObj.first!.pres)) Pa"
        pressureLabel.font = UIFont(name: fontStyle, size: 20)
        pressureLabel.textColor = .white
        pressureIcon.image = UIImage(systemName: "arrow.down.to.line.alt")
        pressureIcon.tintColor = .white
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        return headerView
        
    }

    //MARK: Current
    func CurrentWeatherbit(with name: String) {
        
        myURLComponents.scheme = "https"
        myURLComponents.host = hostForURL
        myURLComponents.path = "/v2.0/current"
        myURLComponents.queryItems = [
            URLQueryItem(name: "city", value: name),
            URLQueryItem(name: "key", value: keyForRequest),
            URLQueryItem(name: "units", value: units)
        ]
         
        URLSession.shared.dataTask(with: myURLComponents.url!.absoluteURL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongCurrent")
                return
            }
            var json: CurrentResponseWeatherbit?
            do {
                json = try JSONDecoder().decode(CurrentResponseWeatherbit.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            self.currentObj = result.data
            
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
    }
    
    func CurrentWeatherbitByCoords(with lat: String, lon: String) {
        myURLComponents.scheme = "https"
        myURLComponents.host = hostForURL
        myURLComponents.path = "/v2.0/current"
        myURLComponents.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "key", value: keyForRequest),
            URLQueryItem(name: "units", value: units)
        ]
        
        URLSession.shared.dataTask(with: myURLComponents.url!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongCurrent")
                return
            }
            var json: CurrentResponseWeatherbit?
            do {
                json = try JSONDecoder().decode(CurrentResponseWeatherbit.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            self.currentObj = result.data
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
        //UserDefaults.standard.array(forKey: "pages") as? [locationParam] ?? [locationParam(name: "Current", lat: "", lon: "")])
        //for _ in __{
        //if lat == __ && lot == __ {
        //__.name == currentObj.first?.city_name
    //}
        //MARK: search item by cord
    }
    
    //MARK: Hourly
    func hourlyForecastWeatherbit(with name: String) {
        //"https://api.weatherbit.io/v2.0/forecast/hourly?city=\(name)&hours=48&key=\(keyForRequest)"
        myURLComponents.scheme = "https"
        myURLComponents.host = hostForURL
        myURLComponents.path = "/v2.0/forecast/hourly"
        myURLComponents.queryItems = [
            URLQueryItem(name: "city", value: name),
            URLQueryItem(name: "hours", value: "48"),
            URLQueryItem(name: "key", value: keyForRequest),
            URLQueryItem(name: "units", value: units)
        ]
        
        URLSession.shared.dataTask(with: myURLComponents.url!.absoluteURL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongHourly")
                return
            }
            var json: HourlyResponseWeatherbit?
            do {
                json = try JSONDecoder().decode(HourlyResponseWeatherbit.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            
            self.hourlyObj = result.data
            self.hourlyObj.removeFirst()
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }).resume()
    }
    
    func HourlyForecastWeatherbitByCoords(with lat: String, lon: String) {
        myURLComponents.scheme = "https"
        myURLComponents.host = hostForURL
        myURLComponents.path = "/v2.0/forecast/hourly"
        myURLComponents.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "hours", value: "48"),
            URLQueryItem(name: "key", value: keyForRequest),
            URLQueryItem(name: "units", value: units)
        ]
        
        URLSession.shared.dataTask(with: myURLComponents.url!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongHourlyCoords")
                return
            }
            var json: HourlyResponseWeatherbit?
            do {
                json = try JSONDecoder().decode(HourlyResponseWeatherbit.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            
            self.hourlyObj = result.data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }).resume()
    }
    
    //MARK: Daily
    func ForecastWeatherbit(with name: String) {
        myURLComponents.scheme = "https"
        myURLComponents.host = hostForURL
        myURLComponents.path = "/v2.0/forecast/daily"
        myURLComponents.queryItems = [
            URLQueryItem(name: "city", value: name),
            URLQueryItem(name: "days", value: "8"),
            URLQueryItem(name: "key", value: keyForRequest),
            URLQueryItem(name: "units", value: units)
        ]
        //https://api.weatherbit.io/v2.0/forecast/daily?city=\(name)&days=8&key=\(keyForRequest)
        
        URLSession.shared.dataTask(with: myURLComponents.url!.absoluteURL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongDaily")
                return
            }
            var json: DailyWeatherbit?
            do {
                json = try JSONDecoder().decode(DailyWeatherbit.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            self.dailyObj = result.data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }).resume()
    }
    
    func ForecastWeatherbitByCoords(with lat: String, lon: String) {
        myURLComponents.scheme = "https"
        myURLComponents.host = hostForURL
        myURLComponents.path = "/v2.0/forecast/daily"
        myURLComponents.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "days", value: "8"),
            URLQueryItem(name: "key", value: keyForRequest),
            URLQueryItem(name: "units", value: units)
        ]
        URLSession.shared.dataTask(with: myURLComponents.url!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongDailyCoords")
                return
            }
            var json: DailyWeatherbit?
            do {
                json = try JSONDecoder().decode(DailyWeatherbit.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            self.dailyObj = result.data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }).resume()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return dailyObj.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            cell.configure(with: hourlyObj)
            
            return cell
        }
         if indexPath.section == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
        cell.configure(with: dailyObj[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentDayInfoCell.identifier, for: indexPath) as! CurrentDayInfoCell
        cell.selectionStyle = .none
        cell.configure(with: currentObj.first ?? CurrentDataWeatherbit(
            lon: 0.0, lat: 0.0, city_name: "", ts: 0, temp: 0, app_temp: 0, rh: 0, pres: 0, wind_spd: 0, wind_cdir: "", vis: 0, snow: 0, uv: 0, precip: 0, sunrise: "", sunset: "", weather: CurrentWeatherWeatherbit(description: "", icon: "")),
            daily: dailyObj.first ?? weatherbitData(datetime: "", ts: 0, snow: 0, max_temp: 0, min_temp: 0, app_max_temp: 0, app_min_temp: 0, pop: 0, precip: 0, rh: 0, pres: 0, vis: 0, uv: 0, clouds: 0, wind_cdir_full: "", wind_spd: 0, sunrise_ts: 0, sunset_ts: 0, moon_phase_lunation: 0, moonrise_ts: 0, moonset_ts: 0, weather: weatherbitWeather(icon: "", description: "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            return
        }
        presentSecondViewController(with: dailyObj[indexPath.row])
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func presentSecondViewController(with data: weatherbitData) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondDailyViewController") as! SecondDailyViewController
        let currentController = self.getCurrentViewController()
        vc.bit = data
        currentController?.present(vc, animated: true)
    }

    func getCurrentViewController() -> UIViewController? {
       if let rootController = UIApplication.shared.keyWindow?.rootViewController {
           var currentController: UIViewController! = rootController
           while( currentController.presentedViewController != nil ) {
               currentController = currentController.presentedViewController
           }
           return currentController
       }
       return nil

    }
}
