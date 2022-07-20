import '../util/list_item.dart';

class SortingAlgo {
  static const algorithms = ["bubbleSort", "quickSort"];
  _swap(List<ListItem> list, int i, int j, List<Operation> operation) {
    ListItem temp = list[i];
    list[i] = list[j];
    list[j] = temp;
    operation
        .add(Operation(operationType: OperationType.swap, item1: i, item2: j));
  }

  List<Operation> bubbleSort(List<ListItem> l) {
    List<ListItem> list = List.from(l);
    List<Operation> res = [];
    int n = list.length;
    for (int i = 0; i < n - 1; i++) {
      bool swapFound = false;
      for (int j = 0; j < n - 1 - i; j++) {
        // add compare;
        res.add(Operation(
            operationType: OperationType.compare, item1: j, item2: j + 1));
        if (list[j].value > list[j + 1].value) {
          _swap(list, j, j + 1, res);
          swapFound = true;
        }
      }
      if (!swapFound) break;
    }

    return res;
  }

  List<Operation> quickSort(List<ListItem> list) {
    List<Operation> res = [];
    _quickSortSub(0, list.length - 1, list, res);
    return res;
  }

  void _quickSortSub(
      int low, int high, List<ListItem> l, List<Operation> operations) {
    List<ListItem> list = List.from(l);
    if (low >= high) return;
    int j = low;
    int i = j;
    int k = high;
    int pivot = list[k].value;
    while (i <= k) {
      // compare
      operations.add(
          Operation(operationType: OperationType.compare, item1: i, item2: k));
      if (list[i].value <= pivot) {
        _swap(list, j, i, operations);
        j++;
      }
      i++;
    }
    // print("$i $j $k");
    _quickSortSub(low, j - 2, list, operations);
    _quickSortSub(j, high, list, operations);
  }
}

class Operation {
  final OperationType operationType;
  final int item1;
  final int item2;
  Operation(
      {required this.operationType, required this.item1, required this.item2});
}

enum OperationType { swap, compare }
