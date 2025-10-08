import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CommonDropdown<T> extends StatefulWidget {
  final List<T> items;
  bool? hidesearch;
  bool? hidedropdown;
  final String hintText;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemAsString;

  CommonDropdown({
    required this.items,
    required this.hintText,
    this.hidesearch,
    this.hidedropdown,
    this.selectedValue,
    required this.onChanged,
    required this.itemAsString,
  });

  @override
  _CommonDropdownState<T> createState() => _CommonDropdownState<T>();
}

class _CommonDropdownState<T> extends State<CommonDropdown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedValue = widget.selectedValue;
    return DropdownSearch<T>(
      enabled: widget.hidedropdown ?? true,
      autoValidateMode: AutovalidateMode.always,
      items: widget.items,
      itemAsString: widget.itemAsString,
      selectedItem: selectedValue,
      onChanged: (T? value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged(value);
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.all(15),
          border: UnderlineInputBorder(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey, // Customize the underline color
            ),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: widget.hidesearch ?? true,
        emptyBuilder: (context, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    child: Image.asset("assets/images/no-results.png")),
                SizedBox(height: 15),
                Text("No data found")
              ],
            ),
          );
        },
        scrollbarProps: const ScrollbarProps(
            thickness: 3, thumbColor: Colors.indigo, thumbVisibility: true),
        searchDelay: const Duration(seconds: 0),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.all(15),
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            fontSize: 14,

            // Font size for the search word
          ),
        ),
        itemBuilder: (context, item, isSelected) => ListTile(
          title: Text(
            widget.itemAsString(item),
            style: TextStyle(fontSize: 14, color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}
