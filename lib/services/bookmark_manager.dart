import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  // Method to get the list of bookmarked parts
  Future<List<int>> getBookmarkedParts() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedParts = prefs.getStringList('bookmarkedParts') ?? [];
    return bookmarkedParts.map((e) => int.parse(e)).toList();
  }

  // Method to toggle the bookmark status
  Future<void> toggleBookmark(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedParts = prefs.getStringList('bookmarkedParts') ?? [];

    if (bookmarkedParts.contains(id.toString())) {
      // Remove the bookmark if it exists
      bookmarkedParts.remove(id.toString());
    } else {
      // Add the bookmark if it doesn't exist
      bookmarkedParts.add(id.toString());
    }

    // Save the updated list of bookmarked parts
    await prefs.setStringList('bookmarkedParts', bookmarkedParts);
  }
}
