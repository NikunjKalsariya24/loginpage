import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loginpage/Homepage.dart';
import 'package:loginpage/smoothscreen.dart';

class addproducts extends StatefulWidget {
  const addproducts({Key? key}) : super(key: key);

  @override
  State<addproducts> createState() => _addproductsState();
}

class _addproductsState extends State<addproducts> {
  String dropdownvalue = 'T-Shirt';
  List<String> items = [
    'T-Shirt',
    'Mobile',
    'Headphone',
    'Bluthoth Speaker',
  ];
  TextEditingController pname = TextEditingController();
  TextEditingController psell = TextEditingController();
  TextEditingController pprice = TextEditingController();
  TextEditingController pdisc = TextEditingController();
  TextEditingController pstock = TextEditingController();

  String img = "";
  String? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = screen.prefs!.getString("id") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product ")),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 60,
            width: 290,
            margin: const EdgeInsets.only(top: 10, right: 20, left: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 60,
            width: 290,
            margin: const EdgeInsets.only(top: 10, right: 20, left: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(child: Text("Add Product Images")),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            width: 120,
            //  margin:
            //  const EdgeInsets.only(top: 10, right: 20, left: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Column(
                        children: [
                          ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.pop(context);
                                final ImagePicker _picker = ImagePicker();

                                final XFile? photo = await _picker.pickImage(
                                    source: ImageSource.camera);

                                setState(() {
                                  img = photo!.path;
                                });
                              },
                              icon: const Icon(Icons.camera),
                              label: const Text("Camera")),
                          ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.pop(context);
                                final ImagePicker _picker = ImagePicker();
                                final XFile? images = await _picker.pickImage(
                                    source: ImageSource.gallery);

                                setState(() {
                                  img = images!.path;
                                });
                              },
                              icon: const Icon(Icons.browse_gallery),
                              label: const Text("Gallary"))
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add)),
          ),
          Container(
            height: 80,
            width: twidth * 0.60,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(),
            child: TextField(
              controller: pname,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Product Name ",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 80,
            width: twidth * 0.60,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(),
            child: TextField(
              controller: pprice,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Product Selling Price ",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 80,
            width: twidth * 0.60,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(),
            child: TextField(
              controller: psell,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Product MRP ",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 80,
            width: twidth * 0.60,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(),
            child: TextField(
              controller: pdisc,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Product Description ",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 80,
            width: twidth * 0.60,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(),
            child: TextField(
              controller: pstock,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Product Stock ",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () async {
              String productname = pname.text;
              String productsell = psell.text;
              String productprice = pprice.text;
              String productdisc = pdisc.text;
              String productstock = pstock.text;

              List<int> iii = File(img).readAsBytesSync();
              String images = base64Encode(iii);

              Map productdata = {
                "loginid": id,
                "pname": productname,
                "psell": productsell,
                "pprice": productprice,
                "pdisc": productdisc,
                "pstoke": productstock,
                "pitem": dropdownvalue,
                "Image": images,
              };

              var url = Uri.parse(
                  'https://nikunjstore.000webhostapp.com/Imagesdata/addproduct/padproduct.php');
              var response = await http.post(url, body: productdata);
              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');

              var data2 = jsonDecode(response.body);

              // for(int i=0;i<productdata.length;i++)
              //   {
              //     allproduct sb2=allproduct.fromJson(data2[i]);
              //   }
              allproduct sb2 = allproduct.fromJson(data2);
              if (sb2.connection == 1) {
                if (sb2.result == 1) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return const homepage();
                    },
                  ));
                }
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Fill all details")));
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(143, 148, 251, 1),
                    Color.fromRGBO(143, 148, 251, 6)
                  ]),
                  //   color: Colors.indigo,
                ),
                height: 80,
                width: twidth * 0.80,
                child: const Center(
                    child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))),
          ),
        ]),
      ),
    );
  }
}

class allproduct {
  int? connection;
  int? result;

  allproduct({this.connection, this.result});

  allproduct.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    return data;
  }
}
