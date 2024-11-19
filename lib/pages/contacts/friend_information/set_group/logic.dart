import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/logic.dart';

class SetGroupLogic extends GetxController {
  final _groupApi = GroupApi();
  final _friendApi = FriendApi();
  late List<dynamic> groupList = [];
  late String selectedGroup;
  late String friendId;
  final FriendInformationLogic _friendInformationLogic =
      GetInstance().find<FriendInformationLogic>();
  final TextEditingController groupController = TextEditingController();

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
    if (group['name'] == selectedGroup) {
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

  void onAddGroup(context) {
    if (groupController.text.isEmpty) {
      return;
    }
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
