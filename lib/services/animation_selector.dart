String getJSON(String? mainCondition) {
  if (mainCondition == null) return 'assets/sunny.json';

  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'smoke':
    case 'haze':
    case 'dust':
      return 'assets/cloudy.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/rainy_blue.json';
    // return 'assets/sun_rain.json';
    case 'snow':
      return 'assets/snow.json';
    case 'thunderstorm':
      return 'assets/thunderstorm.json';
    case 'thunderstorm with light rain':
    case 'thunderstorm with rain':
    case 'thunderstorm with heavy rain':
      return 'assets/thunder_rain.json';
    case 'clear':
      return 'assets/sunny.json';
    case 'mist':
      return 'assets/mist.json';
    default:
      return 'assets/sunny.json';
  }
}
