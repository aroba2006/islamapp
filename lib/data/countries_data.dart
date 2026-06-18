import '../models/country_data.dart';

/// Master list of countries. Countries with a populated [regions] list show
/// a region-selection screen; others fall back to using the capital city.
final List<CountryData> countries = [
  CountryData(
    name: "Egypt",
    flagEmoji: "🇪🇬",
    regions: [
      "Cairo", "Alexandria", "Giza", "Qalyubia", "Sharqia", "Dakahlia",
      "Beheira", "Minya", "Gharbia", "Asyut", "Monufia", "Faiyum",
      "Kafr El Sheikh", "Beni Suef", "Damietta", "Aswan", "Suez",
      "Ismailia", "Luxor", "Qena", "Sohag", "Port Said", "Red Sea",
      "New Valley", "Matrouh", "North Sinai", "South Sinai"
    ],
  ),
  CountryData(
    name: "Saudi Arabia",
    flagEmoji: "🇸🇦",
    regions: [
      "Riyadh", "Makkah", "Madinah", "Eastern Province", "Asir",
      "Tabuk", "Hail", "Northern Borders", "Jazan", "Najran",
      "Al Bahah", "Al Jouf", "Qassim"
    ],
  ),
  CountryData(
    name: "United Arab Emirates",
    flagEmoji: "🇦🇪",
    regions: [
      "Abu Dhabi", "Dubai", "Sharjah", "Ajman", "Umm Al Quwain",
      "Ras Al Khaimah", "Fujairah"
    ],
  ),
  CountryData(
    name: "Pakistan",
    flagEmoji: "🇵🇰",
    regions: [
      "Punjab", "Sindh", "Khyber Pakhtunkhwa", "Balochistan",
      "Gilgit-Baltistan", "Azad Kashmir", "Islamabad Capital Territory"
    ],
  ),
  CountryData(
    name: "Indonesia",
    flagEmoji: "🇮🇩",
    regions: [
      "Jakarta", "West Java", "East Java", "Central Java", "Banten",
      "Aceh", "North Sumatra", "West Sumatra", "South Sumatra",
      "Yogyakarta", "Bali", "South Sulawesi", "East Kalimantan"
    ],
  ),
  CountryData(
    name: "Turkey",
    flagEmoji: "🇹🇷",
    regions: [
      "Istanbul", "Ankara", "Izmir", "Bursa", "Antalya", "Adana",
      "Konya", "Gaziantep", "Kayseri", "Mersin", "Diyarbakir", "Trabzon"
    ],
  ),
  CountryData(
    name: "Jordan",
    flagEmoji: "🇯🇴",
    regions: [
      "Amman", "Irbid", "Zarqa", "Aqaba", "Madaba", "Karak",
      "Mafraq", "Jerash", "Ajloun", "Balqa", "Maan", "Tafilah"
    ],
  ),
  CountryData(
    name: "Lebanon",
    flagEmoji: "🇱🇧",
    regions: [
      "Beirut", "Mount Lebanon", "North Lebanon", "South Lebanon",
      "Bekaa", "Nabatieh", "Akkar", "Baalbek-Hermel"
    ],
  ),
  CountryData(
    name: "Iraq",
    flagEmoji: "🇮🇶",
    regions: [
      "Baghdad", "Basra", "Mosul (Nineveh)", "Erbil", "Najaf",
      "Karbala", "Kirkuk", "Sulaymaniyah", "Anbar", "Diyala",
      "Babil", "Dhi Qar"
    ],
  ),
  CountryData(
    name: "Syria",
    flagEmoji: "🇸🇾",
    regions: [
      "Damascus", "Aleppo", "Homs", "Latakia", "Hama", "Daraa",
      "Deir ez-Zor", "Raqqa", "Idlib", "Tartus", "Quneitra", "As-Suwayda"
    ],
  ),
  CountryData(
    name: "Kuwait",
    flagEmoji: "🇰🇼",
    regions: [
      "Al Asimah (Capital)", "Hawalli", "Farwaniya", "Mubarak Al-Kabeer",
      "Ahmadi", "Jahra"
    ],
  ),
  CountryData(
    name: "Qatar",
    flagEmoji: "🇶🇦",
    regions: [
      "Doha", "Al Rayyan", "Al Wakrah", "Al Khor", "Umm Salal",
      "Al Daayen", "Al Shamal", "Al Shahaniya"
    ],
  ),
  CountryData(
    name: "Bahrain",
    flagEmoji: "🇧🇭",
    regions: [
      "Capital Governorate", "Muharraq", "Northern Governorate",
      "Southern Governorate"
    ],
  ),
  CountryData(
    name: "Oman",
    flagEmoji: "🇴🇲",
    regions: [
      "Muscat", "Dhofar", "Musandam", "Al Buraimi", "Ad Dakhiliyah",
      "Al Batinah North", "Al Batinah South", "Ash Sharqiyah North",
      "Ash Sharqiyah South", "Adh Dhahirah", "Al Wusta"
    ],
  ),
  CountryData(
    name: "Morocco",
    flagEmoji: "🇲🇦",
    regions: [
      "Casablanca-Settat", "Rabat-Salé-Kénitra", "Fès-Meknès",
      "Marrakesh-Safi", "Tangier-Tétouan-Al Hoceïma", "Oriental",
      "Souss-Massa", "Béni Mellal-Khénifra", "Drâa-Tafilalet",
      "Guelmim-Oued Noun", "Laâyoune-Sakia El Hamra", "Dakhla-Oued Ed-Dahab"
    ],
  ),
  CountryData(
    name: "Algeria",
    flagEmoji: "🇩🇿",
    regions: [
      "Algiers", "Oran", "Constantine", "Annaba", "Blida",
      "Batna", "Sétif", "Tlemcen", "Béchar", "Ghardaïa"
    ],
  ),
  CountryData(
    name: "Tunisia",
    flagEmoji: "🇹🇳",
    regions: [
      "Tunis", "Sfax", "Sousse", "Kairouan", "Bizerte", "Gabès",
      "Ariana", "Gafsa", "Monastir", "Nabeul"
    ],
  ),
  CountryData(
    name: "Libya",
    flagEmoji: "🇱🇾",
    regions: [
      "Tripoli", "Benghazi", "Misrata", "Sabha", "Zawiya",
      "Bayda", "Tobruk", "Sirte"
    ],
  ),
  CountryData(
    name: "Sudan",
    flagEmoji: "🇸🇩",
    regions: [
      "Khartoum", "North Kordofan", "South Darfur", "River Nile",
      "Red Sea", "Gezira", "Kassala", "Northern", "White Nile", "Sennar"
    ],
  ),
  CountryData(
    name: "Yemen",
    flagEmoji: "🇾🇪",
    regions: [
      "Sana'a", "Aden", "Taiz", "Hodeidah", "Ibb", "Hadhramaut",
      "Mukalla", "Saada"
    ],
  ),
  CountryData(
    name: "Palestine",
    flagEmoji: "🇵🇸",
    regions: [
      "Jerusalem", "Gaza", "Ramallah", "Hebron", "Nablus", "Bethlehem",
      "Jenin", "Khan Younis", "Rafah", "Tulkarm"
    ],
  ),
  CountryData(
    name: "Malaysia",
    flagEmoji: "🇲🇾",
    regions: [
      "Kuala Lumpur", "Selangor", "Johor", "Penang", "Sabah",
      "Sarawak", "Perak", "Kedah", "Kelantan", "Terengganu", "Malacca"
    ],
  ),
  CountryData(
    name: "Bangladesh",
    flagEmoji: "🇧🇩",
    regions: [
      "Dhaka", "Chittagong", "Khulna", "Rajshahi", "Sylhet",
      "Barisal", "Rangpur", "Mymensingh"
    ],
  ),
  CountryData(
    name: "Afghanistan",
    flagEmoji: "🇦🇫",
    regions: [
      "Kabul", "Herat", "Kandahar", "Mazar-i-Sharif", "Jalalabad",
      "Kunduz", "Balkh", "Nangarhar"
    ],
  ),
  CountryData(
    name: "Iran",
    flagEmoji: "🇮🇷",
    regions: [
      "Tehran", "Isfahan", "Mashhad", "Shiraz", "Tabriz", "Qom",
      "Ahvaz", "Kermanshah", "Yazd"
    ],
  ),
  CountryData(
    name: "Nigeria",
    flagEmoji: "🇳🇬",
    regions: [
      "Lagos", "Kano", "Kaduna", "Abuja (FCT)", "Borno", "Sokoto",
      "Oyo", "Rivers", "Katsina", "Bauchi"
    ],
  ),
  CountryData(
    name: "United States",
    flagEmoji: "🇺🇸",
    regions: [
      "New York", "California", "Texas", "Florida", "Illinois",
      "Michigan", "New Jersey", "Pennsylvania", "Ohio", "Virginia",
      "Georgia", "Minnesota", "Massachusetts", "Washington", "Arizona"
    ],
  ),
  CountryData(
    name: "United Kingdom",
    flagEmoji: "🇬🇧",
    regions: [
      "London", "Birmingham", "Manchester", "Leeds", "Glasgow",
      "Liverpool", "Bradford", "Sheffield", "Edinburgh", "Cardiff", "Belfast"
    ],
  ),
  CountryData(
    name: "Canada",
    flagEmoji: "🇨🇦",
    regions: [
      "Ontario", "Quebec", "British Columbia", "Alberta", "Manitoba",
      "Saskatchewan", "Nova Scotia"
    ],
  ),
  CountryData(
    name: "France",
    flagEmoji: "🇫🇷",
    regions: [
      "Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes",
      "Strasbourg", "Lille"
    ],
  ),
  CountryData(
    name: "Germany",
    flagEmoji: "🇩🇪",
    regions: [
      "Berlin", "Hamburg", "Munich", "Cologne", "Frankfurt",
      "Stuttgart", "Düsseldorf"
    ],
  ),
  CountryData(
    name: "India",
    flagEmoji: "🇮🇳",
    regions: [
      "Delhi", "Mumbai", "Hyderabad", "Bangalore", "Kolkata",
      "Chennai", "Lucknow", "Kashmir (Srinagar)", "Kerala (Kochi)"
    ],
  ),
  CountryData(
    name: "Australia",
    flagEmoji: "🇦🇺",
    regions: [
      "New South Wales", "Victoria", "Queensland", "Western Australia",
      "South Australia"
    ],
  ),
  // Countries below use capital-city fallback (no hardcoded regions yet).
  CountryData(name: "Albania", flagEmoji: "🇦🇱"),
  CountryData(name: "Austria", flagEmoji: "🇦🇹"),
  CountryData(name: "Azerbaijan", flagEmoji: "🇦🇿"),
  CountryData(name: "Belgium", flagEmoji: "🇧🇪"),
  CountryData(name: "Bosnia and Herzegovina", flagEmoji: "🇧🇦"),
  CountryData(name: "Brazil", flagEmoji: "🇧🇷"),
  CountryData(name: "Brunei", flagEmoji: "🇧🇳"),
  CountryData(name: "Chad", flagEmoji: "🇹🇩"),
  CountryData(name: "China", flagEmoji: "🇨🇳"),
  CountryData(name: "Comoros", flagEmoji: "🇰🇲"),
  CountryData(name: "Djibouti", flagEmoji: "🇩🇯"),
  CountryData(name: "Eritrea", flagEmoji: "🇪🇷"),
  CountryData(name: "Ethiopia", flagEmoji: "🇪🇹"),
  CountryData(name: "Gambia", flagEmoji: "🇬🇲"),
  CountryData(name: "Ghana", flagEmoji: "🇬🇭"),
  CountryData(name: "Greece", flagEmoji: "🇬🇷"),
  CountryData(name: "Guinea", flagEmoji: "🇬🇳"),
  CountryData(name: "Italy", flagEmoji: "🇮🇹"),
  CountryData(name: "Ivory Coast", flagEmoji: "🇨🇮"),
  CountryData(name: "Japan", flagEmoji: "🇯🇵"),
  CountryData(name: "Kazakhstan", flagEmoji: "🇰🇿"),
  CountryData(name: "Kenya", flagEmoji: "🇰🇪"),
  CountryData(name: "Kosovo", flagEmoji: "🇽🇰"),
  CountryData(name: "Kyrgyzstan", flagEmoji: "🇰🇬"),
  CountryData(name: "Maldives", flagEmoji: "🇲🇻"),
  CountryData(name: "Mali", flagEmoji: "🇲🇱"),
  CountryData(name: "Mauritania", flagEmoji: "🇲🇷"),
  CountryData(name: "Mexico", flagEmoji: "🇲🇽"),
  CountryData(name: "Mozambique", flagEmoji: "🇲🇿"),
  CountryData(name: "Netherlands", flagEmoji: "🇳🇱"),
  CountryData(name: "New Zealand", flagEmoji: "🇳🇿"),
  CountryData(name: "Niger", flagEmoji: "🇳🇪"),
  CountryData(name: "North Macedonia", flagEmoji: "🇲🇰"),
  CountryData(name: "Norway", flagEmoji: "🇳🇴"),
  CountryData(name: "Philippines", flagEmoji: "🇵🇭"),
  CountryData(name: "Poland", flagEmoji: "🇵🇱"),
  CountryData(name: "Portugal", flagEmoji: "🇵🇹"),
  CountryData(name: "Russia", flagEmoji: "🇷🇺"),
  CountryData(name: "Senegal", flagEmoji: "🇸🇳"),
  CountryData(name: "Serbia", flagEmoji: "🇷🇸"),
  CountryData(name: "Singapore", flagEmoji: "🇸🇬"),
  CountryData(name: "Somalia", flagEmoji: "🇸🇴"),
  CountryData(name: "South Africa", flagEmoji: "🇿🇦"),
  CountryData(name: "South Korea", flagEmoji: "🇰🇷"),
  CountryData(name: "Spain", flagEmoji: "🇪🇸"),
  CountryData(name: "Sri Lanka", flagEmoji: "🇱🇰"),
  CountryData(name: "Sweden", flagEmoji: "🇸🇪"),
  CountryData(name: "Switzerland", flagEmoji: "🇨🇭"),
  CountryData(name: "Tajikistan", flagEmoji: "🇹🇯"),
  CountryData(name: "Tanzania", flagEmoji: "🇹🇿"),
  CountryData(name: "Thailand", flagEmoji: "🇹🇭"),
  CountryData(name: "Turkmenistan", flagEmoji: "🇹🇲"),
  CountryData(name: "Uganda", flagEmoji: "🇺🇬"),
  CountryData(name: "Ukraine", flagEmoji: "🇺🇦"),
  CountryData(name: "Uzbekistan", flagEmoji: "🇺🇿"),
  CountryData(name: "Vietnam", flagEmoji: "🇻🇳"),
];

/// Capital city fallback for countries without hardcoded regions.
/// Used to query the Aladhan API by "city, country" when no region was picked.
const Map<String, String> countryCapitals = {
  "Albania": "Tirana",
  "Austria": "Vienna",
  "Azerbaijan": "Baku",
  "Belgium": "Brussels",
  "Bosnia and Herzegovina": "Sarajevo",
  "Brazil": "Brasilia",
  "Brunei": "Bandar Seri Begawan",
  "Chad": "N'Djamena",
  "China": "Beijing",
  "Comoros": "Moroni",
  "Djibouti": "Djibouti",
  "Eritrea": "Asmara",
  "Ethiopia": "Addis Ababa",
  "Gambia": "Banjul",
  "Ghana": "Accra",
  "Greece": "Athens",
  "Guinea": "Conakry",
  "Italy": "Rome",
  "Ivory Coast": "Yamoussoukro",
  "Japan": "Tokyo",
  "Kazakhstan": "Astana",
  "Kenya": "Nairobi",
  "Kosovo": "Pristina",
  "Kyrgyzstan": "Bishkek",
  "Maldives": "Malé",
  "Mali": "Bamako",
  "Mauritania": "Nouakchott",
  "Mexico": "Mexico City",
  "Mozambique": "Maputo",
  "Netherlands": "Amsterdam",
  "New Zealand": "Wellington",
  "Niger": "Niamey",
  "North Macedonia": "Skopje",
  "Norway": "Oslo",
  "Philippines": "Manila",
  "Poland": "Warsaw",
  "Portugal": "Lisbon",
  "Russia": "Moscow",
  "Senegal": "Dakar",
  "Serbia": "Belgrade",
  "Singapore": "Singapore",
  "Somalia": "Mogadishu",
  "South Africa": "Pretoria",
  "South Korea": "Seoul",
  "Spain": "Madrid",
  "Sri Lanka": "Colombo",
  "Sweden": "Stockholm",
  "Switzerland": "Bern",
  "Tajikistan": "Dushanbe",
  "Tanzania": "Dodoma",
  "Thailand": "Bangkok",
  "Turkmenistan": "Ashgabat",
  "Uganda": "Kampala",
  "Ukraine": "Kyiv",
  "Uzbekistan": "Tashkent",
  "Vietnam": "Hanoi",
};
