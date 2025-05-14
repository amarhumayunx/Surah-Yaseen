import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';


class FilterRow extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final Function(String) onSearch;
  final VoidCallback onShowDeleteMode;

  const FilterRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearch,
    required this.onShowDeleteMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(
        children: [
          _buildFilterButton('all'.tr),
          const SizedBox(width: 2),
          _buildFilterButton('recents'.tr),
          const Spacer(),
          GestureDetector(
            onTap: () => _showSearchDialog(context),
            child: Icon(Icons.search, size: 24, color: AppColors.PrimaryColor),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => _showDeleteOptionsMenu(context),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.PrimaryColor, width: 2),
              ),
              child: Icon(Icons.more_vert, size: 16, color: AppColors.PrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => onFilterSelected(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          decoration: BoxDecoration(
            color: selectedFilter == filter ? AppColors.PrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.PrimaryColor, width: 1.5),
          ),
          child: Text(
            filter,
            style: TextStyle(
              color: selectedFilter == filter ? Colors.white : AppColors.PrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Set your desired color here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'search_bookmarks'.tr,
          style: TextStyle(
            color: AppColors.PrimaryColor,
            fontFamily: GoogleFonts.merriweather().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'verse_search_hint'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: AppColors.BarColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: AppColors.PrimaryColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.PrimaryColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              onSearch(searchController.text);
              Navigator.pop(context);
            },
            child: Text('search'.tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  void _showDeleteOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'bookmark_options'.tr,
                style: TextStyle(
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.PrimaryColor,
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.PrimaryColor),
                title: Text(
                  'delete_bookmarks'.tr,
                  style: TextStyle(
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    color: AppColors.PrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onShowDeleteMode();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}