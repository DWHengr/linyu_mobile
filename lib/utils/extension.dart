import 'package:flutter/foundation.dart';

extension UsersListExtension<E extends Map<String, dynamic>> on List {
  bool include(Map value) {
    for (E e in this) {
      if (e['friendId'] == value['friendId']) return true;
    }
    return false;
  }

  bool delete(Map value) {
    for (E e in this) {
      if (e['friendId'] == value['friendId']) {
        return remove(e);
      }
    }
    return false;
  }

  List copy({List? list}) {
    List sourceList = list ?? this; // 若 list 为空，将其设为当前对象
    if (sourceList.isEmpty) return []; // 若源列表为空，返回空列表
    List copyList = []; // 创建一个新的列表用于存放复制的元素
    try {
      for (var item in sourceList) {
        if (item is Map) {
          Map<String, dynamic> mapItem = Map.from(item);
          copyList.add(mapItem);
        } else if (item is List) {
          copyList.add(item.copy());
        } else {
          copyList.add(item);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('复制列表时发生错误: $e');
      } // 错误处理，输出错误信息
    }
    return copyList; // 返回复制后的列表
  }

  List replace({dynamic oldValue, dynamic newValue, List? list}) {
    List sourceList = list ?? this.copy();
    oldValue ??= newValue;
    // 如果源列表为空，直接返回空列表
    if (sourceList.isEmpty) return [];
    try {
      // 遍历列表并进行替换
      for (var i = 0; i < sourceList.length; i++) {
        if (sourceList[i]['id'] == oldValue['id']) {
          sourceList[i] = newValue;
          break; // 找到并替换后退出循环
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('替换值时发生错误: $e'); // 输出错误信息
      }
    }

    return sourceList; // 返回处理后的列表
  }
}
