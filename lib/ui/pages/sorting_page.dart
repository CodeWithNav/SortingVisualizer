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
          if (currentOp!.item1 == index) return const Color(0xffffdca7);
          if (currentOp!.item2 == index) return const Color(0xff8fd3ff);
        } else if (currentOp!.operationType == OperationType.compare) {
          if (currentOp!.item1 == index) return const Color(0xff1db3ff);
          if (currentOp!.item2 == index) return const Color(0xffffa013);
        }
      }
      return const Color(0xffA5C9CA);
    }
    return const Color(0xff3CCF4E);
  }

  String selectedAlgo = SortingAlgo.algorithms[0];
  bool stop = false;
  int currentIndex = 0;
  List<Operation> currOperation = [];
  void reset() {
    stop = false;
    currentIndex = 0;
    currOperation = [];
    sorting = false;
    size = 10;
    generateRandomList();
    setState(() {});
  }

  void animate(List<Operation> operation, {int startFrom = 0}) async {
    sorting = true;
    stop = false;
    for (int i = startFrom; i < operation.length; i++) {
      Operation element = operation[i];
      currentOp = element;
      currentIndex = i;
      if (stop) {
        currOperation = operation;
        return;
      }

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
      case "BubbleSort":
        animate(sortingAlgo.bubbleSort(data));
        break;
      case "QuickSort":
        animate(sortingAlgo.quickSort(data));
        break;
      default:
    }
  }

  startStopAnimation() {
    if (stop) {
      stop = !stop;
      animate(currOperation, startFrom: currentIndex);
    } else {
      stop = !stop;
    }

    setState(() {});
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
        appBar: AppBar(
          title: const Text("Sorting visualizer"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Wrap(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Select Sorting Algorithm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          underline: Container(
                            color: Theme.of(context).colorScheme.primary,
                            height: 1,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          value: selectedAlgo,
                          items: SortingAlgo.algorithms
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (!sorting &&
                                value != null &&
                                selectedAlgo != value) {
                              setState(() {
                                selectedAlgo = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Set Animation Speed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Slider(
                            min: 0.5,
                            max: 2,
                            label: "x$speed",
                            divisions: 3,
                            value: speed,
                            onChanged: (value) {
                              if (!sorting && value != speed) {
                                setState(() {
                                  speed = value;
                                });
                              }
                            })
                      ],
                    ),
                  ),
                ),
                if (!sorting)
                  PrimaryButton(
                      onPressed: () {
                        startSorting();
                      },
                      title: "Start Sorting"),
                if (sorting)
                  PrimaryButton(
                      onPressed: () {
                        startStopAnimation();
                      },
                      title: stop ? "Resume" : "Pause"),
                if (sorting && stop)
                  PrimaryButton(
                      onPressed: () {
                        reset();
                      },
                      title: "Reset")
              ],
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < data.length; i++) ...[
                      Expanded(
                          // key: Key("$i ${data[i].value}"),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Set Random Input Range : $size"),
                    Expanded(
                      child: Slider(
                          max: 300,
                          min: 5,
                          value: size.toDouble(),
                          onChanged: (newValue) {
                            if (sorting || size == newValue) return;
                            setState(() {
                              size = newValue.toInt();
                              generateRandomList();
                            });
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
