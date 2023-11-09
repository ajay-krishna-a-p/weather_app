import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/Constant/constant.dart' as k;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  num? temp;
  num? press;
  num? hum;
  num? cover;
  String cityname = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(243, 224, 226, 225),
      body: SafeArea(
          child: Center(
        child: Container(
          child: Visibility(
              visible: isLoaded,
              replacement: Center(child: CircularProgressIndicator()),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 13),
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: TextFormField(
                            onFieldSubmitted: (String s) {
                              setState(() {
                                cityname = s;
                                getCityWeather(s);
                                isLoaded = false;
                                _controller.clear();
                              });
                            },
                            controller: _controller,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                                hintText: 'Search city',
                                hintStyle: TextStyle(fontSize: 16),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Image.asset(
                        "images/free-weather-296-1100758.png",
                        height: 83,
                        width: 83,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${temp?.toInt()} ℃",
                        style: TextStyle(fontSize: 54),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color: Colors.red[800],
                            ),
                            Text(
                              cityname,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/2945800.png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Pressure: ${press?.toInt()} hPa",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          )),
                      Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/humidity-vetor-icon-vector-removebg-preview.png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Humidity: ${hum?.toInt()} %",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          )),
                      Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/252035.png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Cloud Cover: ${cover?.toInt()} ",
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              )),
        ),
      )),
    );
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (p != null) {
      print('Lat:${p.latitude},Long:${p.longitude}');
      getCurrentCityWeather(p);
    } else {
      print("Data unavailable");
    }
  }

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityname = "Not available";
      } else {
        temp = decodedData['main']['temp'] - 273;
        press = decodedData['main']['pressure'];
        hum = decodedData['main']['humidity'];
        cover = decodedData['clouds']['all'];
        cityname = decodedData['name'];
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
