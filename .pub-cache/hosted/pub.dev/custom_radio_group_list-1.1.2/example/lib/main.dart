import 'package:custom_radio_group_list/custom_radio_group_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List<SampleData> sampleList = [];

List<String> stringList = [
  'test1',
  'test2',
  'test3',
  'test4',
  'test5',
];
List<String> hLisItem = [
  'Delhi',
  'Mumbai',
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Radio Group List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Radio Group List Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedItem;
  SampleData? selectedItemNew;
  String? hSelectedItem;
  @override
  void initState() {
    super.initState();
    sampleList.add(SampleData(title: 'Mumbai', id: '1'));
    sampleList.add(SampleData(title: 'Delhi', id: '2'));
    sampleList.add(SampleData(title: 'Bhopal', id: '3'));
    sampleList.add(SampleData(title: 'Bangalore', id: '4'));
    sampleList.add(SampleData(title: 'Indore', id: '5'));

    selectedItem = stringList.first;
    selectedItemNew = sampleList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Object List Selection'),
              RadioGroup(
                  items: sampleList,
                  selectedItem: selectedItemNew,
                  onChanged: (value) {
                    selectedItemNew = value;
                    final snackBar = SnackBar(content: Text("$value"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  labelBuilder: (ctx, index) {
                    return Row(
                      children: [
                        Text(
                          'Id : ${sampleList[index].id}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'City : ${sampleList[index].title}',
                        ),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  disabled: false),
              const Text('String List Selection'),
              RadioGroup(
                items: stringList,
                onChanged: (value) {
                  print('Value : $value');
                  selectedItem = value;
                  final snackBar = SnackBar(content: Text("$value"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                selectedItem: selectedItem,
                shrinkWrap: true,
                fillColor: Colors.green,
                labelBuilder: (ctx, index) {
                  return Text(
                    stringList[index],
                    style: TextStyle(
                        color: selectedItem == stringList[index]
                            ? Colors.green
                            : Colors.black),
                  );
                },
              ),
              const Text('Horizontal List Disabled'),
              SizedBox(
                height: 30,
                child: RadioGroup(
                  items: hLisItem,
                  disabled: true,
                  scrollDirection: Axis.horizontal,
                  onChanged: (value) {
                    print('Value : $value');
                    hSelectedItem = value;
                    final snackBar = SnackBar(content: Text("$value"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  selectedItem: hSelectedItem,
                  shrinkWrap: true,
                  labelBuilder: (ctx, index) {
                    return Text(
                      hLisItem[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SampleData {
  String id;
  String title;

  SampleData({required this.id, required this.title});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
