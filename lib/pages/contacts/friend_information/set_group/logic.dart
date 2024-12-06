import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'index.dart';

class SetGroupLogic extends Logic<SetGroupPage> {
  final _groupApi = GroupApi();
  final _friendApi = FriendApi();
  late List<dynamic> groupList = [];
  late String selectedGroup;
  late String friendId;
  final FriendInformationLogic _friendInformationLogic =
      GetInstance().find<FriendInformationLogic>();
  final TextEditingController groupController = TextEditingController();
  final RxInt groupLength = 0.obs;

  @override
  void onInit() {
    selectedGroup = Get.arguments['groupName'];
    friendId = Get.arguments['friendId'];
    super.onInit();
    onGetGroupList();
  }

  void onGetGroupList() {
    _groupApi.list().then((res) {
      if (res['code'] == 0) {
        groupList = res['data'];
        update([const Key('set_group')]);
      }
    });
  }

  void onSetGroup(group) {
    if (group['name'] == selectedGroup ||
        group['value'] == '0' ||
        friendId == '0') {
      return;
    }
    _friendApi.setGroup(friendId, group['value']).then((res) {
      if (res['code'] == 0) {
        selectedGroup = group['label'];
        update([const Key('set_group')]);
        _friendInformationLogic.getFriendInfo();
      }
    });
  }

  void onUpdateGroup(context, dynamic group) {
    if (groupController.text.isEmpty) {
      return;
    }
    if (group != null) {
      _groupApi.update(group['value'], groupController.text).then((res) {
        if (res['code'] == 0) {
          onGetGroupList();
          groupController.text = '';
          CustomFlutterToast.showSuccessToast('修改成功~');
          Navigator.of(context).pop();
          update([const Key('set_group')]);
        } else {
          CustomFlutterToast.showErrorToast(res['msg']);
        }
      });
    } else {
      _groupApi.create(groupController.text).then((res) {
        if (res['code'] == 0) {
          onGetGroupList();
          groupController.text = '';
          CustomFlutterToast.showSuccessToast('添加成功~');
          Navigator.of(context).pop();
          update([const Key('set_group')]);
        } else {
          CustomFlutterToast.showErrorToast(res['msg']);
        }
      });
    }
  }

  void onUpdateGroupPress(BuildContext context, dynamic group) {
    if (group['value'] == '0') {
      Get.back();
      CustomFlutterToast.showSuccessToast("默认分组不能重命名~");
      return;
    }
    Get.back();
    widget?.showAddAndUpdateGroupDialog(
      context,
      group: group,
      title: '修改分组',
      hintText: group['label'],
    );
  }

  void onDeleteGroup(dynamic group) async {
    if (group['value'] == '0') {
      CustomFlutterToast.showSuccessToast("默认分组不能删除~");
      Get.back();
      return;
    }
    var res = await _groupApi.delete(group['value']);
    if (res['code'] == 0) {
      Get.back();
      CustomFlutterToast.showSuccessToast("删除成功~");
      onGetGroupList();
    } else {
      CustomFlutterToast.showErrorToast("网络错误");
    }
  }
}
