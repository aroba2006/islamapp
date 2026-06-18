/// Represents a country with its flag emoji and list of states/governorates.
/// If [regions] is empty, the app will fall back to using the country's
/// capital city directly for prayer time lookups.
class CountryData {
  final String name;
  final String flagEmoji;
  final List<String> regions;

  const CountryData({
    required this.name,
    required this.flagEmoji,
    this.regions = const [],
  });
}
