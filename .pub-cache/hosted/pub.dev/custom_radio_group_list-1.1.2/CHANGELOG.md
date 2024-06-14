## 1.0.0

* Initial release

## 1.1.0

1. Able to set the color for radio button
2. You can customize the label as per your needs
3. Radio List can be generated using list of object.

## 1.1.2

1. Added support for horizontal list
2. Support to disable selection in list
## Usage

### Example 1
This example shows using an object list
``` dart
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
  ```
### Example 2
This example shows use of String list.
``` dart
          RadioGroup(
                  items: stringList,
                  onChanged: (value) {
                    print('Value : $value');
                    selectedItem = value;
                    final snackBar = SnackBar(content: Text("$value"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  selectedItem: selectedItem,
                  disabled: true,
                  shrinkWrap: true,
                  labelBuilder: (ctx, index) {
                    return Text(stringList[index]);
                  },
                ),
```
### Example 3
This example shows disabled horizontal list.
``` dart
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
```