import 'dart:math';

import 'package:algo/ui/components/primary_button.dart';
import 'package:flutter/material.dart';

import '../../algo/sorting_algo.dart';
import '../../util/list_item.dart';

class SortingPage extends StatefulWidget {
  const SortingPage({Key? key}) : super(key: key);

  @override
  State<SortingPage> createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  Random random = Random(10);
  double baseHeight = 400;
  SortingAlgo sortingAlgo = SortingAlgo();
  List<ListItem> data = [];
  double speed = 1;
  int size = 10;
  static const speeds = [0.2, 0.5, 1, 1.5, 1.8];
  void generateRandomList() {
    data = List.generate(size, (index) {
      int value = random.nextInt(500);
      maxValue = max(maxValue, value);
      return ListItem(value, index);
    });
  }

  bool sorting = false;
  Operation? currentOp;
  Color getColor(int index) {
    if (sorting) {
      if (currentOp != null) {
        if (currentOp!.operationType == OperationType.swap) {
          if (currentOp!.item1 == index) return const Color(0xffEF5B0C);
          if (currentOp!.item2 == index) return const Color(0xffD4F6CC);
        } else if (currentOp!.operationType == OperationType.compare) {
          if (currentOp!.item1 == index) return const Color(0xff3AB4F2);
          if (currentOp!.item2 == index) return const Color(0xffFEB139);
        }
      }
      return const Color(0xffA5C9CA);
    }
    return const Color(0xff3CCF4E);
  }

  String selectedAlgo = SortingAlgo.algorithms[0];
  void animate(List<Operation> operation) async {
    sorting = true;
    for (var element in operation) {
      currentOp = element;

      if (element.operationType == OperationType.swap) {
        ListItem temp =
            ListItem(data[element.item1].value, data[element.item1].index);
        data[element.item1].index = data[element.item2].index;
        data[element.item1].value = data[element.item2].value;
        data[element.item2].index = temp.index;
        data[element.item2].value = temp.value;
      }
      setState(() {});
      await Future.delayed(
          Duration(milliseconds: 1000 - (speed * 1000).toInt()));
    }
    sorting = false;
    setState(() {});
  }

  int maxValue = 0;
  startSorting() {
    switch (selectedAlgo) {
      case "bubbleSort":
        animate(sortingAlgo.bubbleSort(data));
        break;
      case "quickSort":
        animate(sortingAlgo.quickSort(data));
        break;
      default:
    }
  }

  @override
  initState() {
    super.initState();
    data = List.generate(size, (index) {
      int value = random.nextInt(500);
      maxValue = max(maxValue, value);
      return ListItem(value, index);
    });
  }

  @override
  Widget build(BuildContext context) {
    baseHeight = MediaQuery.of(context).size.height - 300;
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.primary,
          child: Wrap(
            children: [
              const Text("Select Algorithm "),
              const SizedBox(
                width: 10,
              ),
              DropdownButton<String>(
                value: selectedAlgo,
                items: SortingAlgo.algorithms
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  if (value != null && selectedAlgo != value) {
                    setState(() {
                      selectedAlgo = value;
                    });
                  }
                },
              ),
              PrimaryButton(
                  onPressed: () {
                    startSorting();
                  },
                  child: const Text("Sort"))
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < data.length; i++) ...[
                  Expanded(
                      // key: Key("$i}_${data[i].value}"),
                      child: Container(
                    height: (baseHeight * (data[i].value / maxValue)) + 50,
                    color: getColor(i),
                    // child: Center(
                    //     child: Text(
                    //   "${data[i].value}",
                    //   overflow: TextOverflow.fade,
                    // )),
                  ))
                ],
              ],
            ),
          ),
        ),
        Slider(
            max: 300,
            min: 5,
            value: size.toDouble(),
            onChanged: (newValue) {
              if (size == newValue) return;
              setState(() {
                size = newValue.toInt();
                generateRandomList();
              });
            })
      ],
    ));
  }
}
