import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linyu_mobile/api/talk_api.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/utils/date.dart';

final _talkApi = TalkApi();
final _userApi = UserApi();

class Talk extends StatefulWidget {
  const Talk({super.key});

  @override
  State<StatefulWidget> createState() => _TalkPageState();
}

class _TalkPageState extends State<Talk> {
  List<dynamic> _talkList = [];
  int _index = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _onTalkList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _onTalkList();
    }
  }

  void _onTalkList() {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _talkApi.list(_index, 10).then((res) {
      if (res['code'] == 0) {
        final List<dynamic> newTalks = res['data'];

        setState(() {
          if (newTalks.isEmpty) {
            _hasMore = false;
          } else {
            _talkList.addAll(newTalks);
            _index += newTalks.length;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _talkList.clear();
      _index = 0;
      _hasMore = true;
    });
    _onTalkList();
  }

  Future<String> _onGetImg(String fileName, String userId) async {
    dynamic res = await _userApi.getImg(fileName, userId);
    if (res['code'] == 0) {
      return res['data'];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
          centerTitle: true,
          title: const Text('说说'),
          backgroundColor: const Color(0xFFF9FBFF),
          actions: [
            TextButton(
              onPressed: () {},
              child: CustomTextButton('发表', onTap: () {}, fontSize: 14),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _talkList.length + 1,
            itemBuilder: (context, index) {
              if (index < _talkList.length) {
                return _buildTalkItem(_talkList[index]);
              } else {
                return _buildFooter();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Color(0xFF4C9BFF),
            ),
          ),
        ),
      );
    } else if (!_hasMore) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Center(
          child: Text(
            '没有更多内容了~',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTalkItem(dynamic talk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: talk['portrait'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffffffff),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Image.asset(
                                'assets/images/default-portrait.jpeg'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            talk['remark'] ?? talk['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateUtil.formatTime(talk['time']),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[100]!, width: 1.0),
                        bottom:
                            BorderSide(color: Colors.grey[100]!, width: 1.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          talk['content']['text'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                        _buildImageGrid(
                            talk['content']['img'] ?? [], talk['userId']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("点赞（${talk['likeNum'] ?? 0}）",
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text("评论（${talk['commentNum'] ?? 0}）",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      CustomTextButton('删除', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 5),
                  CustomTextButton('查看更多内容', onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<dynamic> imageUrls, String userId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return _buildTalkImage(imageUrls[index], userId);
      },
    );
  }

  Widget _buildTalkImage(String imageStr, String userId) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: FutureBuilder<String>(
        future: _onGetImg(imageStr, userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              imageUrl: snapshot.data ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffffffff),
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                child: Image.asset('assets/images/empty-bg.png'),
              ),
            );
          } else {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffffffff),
                  strokeWidth: 2,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
