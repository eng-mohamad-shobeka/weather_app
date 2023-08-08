import 'package:flutter/material.dart';
import 'package:weather_app_20/helpers/api_helper.dart';

import '../models/country_model.dart';

class SelectCityPage extends StatefulWidget {
  const SelectCityPage({Key? key}) : super(key: key);

  @override
  State<SelectCityPage> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  ApiHelper apiHelper = ApiHelper();

  List<CountryModel> countries = [];
  List<CountryModel> filteredCountries = [];

  bool isLoading = false;

  String cityName = "";

  TextEditingController cityNameController = TextEditingController();

  getCountryList() async {
    setState(() {
      isLoading = true;
    });
    countries = await apiHelper.getCountryList();
    countries.sort((c1, c2) {
      return c1.name.compareTo(c2.name);
    });

    filteredCountries = countries;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  Navigator.pop(context, value);
                },
                controller: cityNameController,
                onChanged: (String value) {
                  cityName = value;
                  setState(() {
                    if (value == "") {
                      filteredCountries = countries;
                    } else {
                      filteredCountries = countries
                          .where((country) =>
                              country.name
                                  .toLowerCase()
                                  .startsWith(value.toLowerCase()) ||
                              country.capital
                                  .toLowerCase()
                                  .startsWith(value.toLowerCase()))
                          .toList();
                    }
                  });
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.pop(context, cityNameController.text);
                      },
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                    label: Text("cityName"),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    filled: true,
                    fillColor: Colors.blue.shade200,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          CountryModel country = filteredCountries[index];
                          return Card(
                              child: ListTile(
                            onTap: () {
                              //Navigator.pop(context, country.capital);
                              cityNameController.text = country.capital;
                            },
                            title: Text(country.name),
                            subtitle: Text(country.capital),
                            trailing: CircleAvatar(
                              backgroundImage: NetworkImage(country.flagUrl),
                            ),
                          ));
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
