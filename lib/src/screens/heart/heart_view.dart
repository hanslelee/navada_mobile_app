import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/screens/heart/heart_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/heart/heart_list_model.dart';
import '../../widgets/colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/divider.dart';
import '../../widgets/screen_size.dart';
import '../../widgets/space.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/text_style.dart';

class HeartView extends StatelessWidget {
  const HeartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return Scaffold(
      appBar: CustomAppBar(titleText: '관심 상품 목록'),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HeartViewModel()),
          ChangeNotifierProvider(create: (context) => HeartViewModel()),
        ],
        child: Center(
          child: SizedBox(
            width: size.getSize(335.0),
            child: Column(
              children: [
                const CheckButtonSection(),
                Expanded(child: HeartListSection())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
CheckButtonSection : 교환가능상품만보기 체크 버튼 부분
 */
class CheckButtonSection extends StatelessWidget {
  const CheckButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(child: Container()),
          IconButton(
              alignment: Alignment.centerRight,
              iconSize: size.getSize(18.0),
              color: grey153,
              onPressed: () {
                Provider.of<HeartViewModel>(context, listen: false)
                    .onButtonTapped();
              },
              icon: Provider.of<HeartViewModel>(context).isChecked
                  ? const Icon(Icons.check_circle, color: navy)
                  : const Icon(Icons.check_circle_outline)),
          Text('교환 가능 상품만 보기',
              style: TextStyle(
                  color: Provider.of<HeartViewModel>(context).isChecked
                      ? navy
                      : grey153))
        ],
      ),
    );
  }
}

/*
HeartListSection : 좋아요 상품 리스트 부분
 */
// ignore: must_be_immutable
class HeartListSection extends StatelessWidget {
  HeartListSection({Key? key}) : super(key: key);
  ScreenSize size = ScreenSize();

  @override
  Widget build(BuildContext context) {
    return Consumer<HeartViewModel>(
        builder: (BuildContext context, HeartViewModel provider, Widget? _) {
      Future(() {
        if (provider.isInitial) {
          provider.fetchHeartList();
          provider.setInitialFalse();
        }
      });
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildItem(provider.heartList?[index].product);
        },
        itemCount: provider.heartList?.length,
      );
    });
  }

  Widget _buildItem(Product? product) {
    return Column(
      children: [
        SizedBox(
          height: size.getSize(8.0),
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset(
                'assets/images/test.jpeg',
                width: size.getSize(65.0),
                height: size.getSize(65.0),
              ),
            ),
            SizedBox(
              width: size.getSize(12.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                B14Text(text: product?.productName),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: '원가 ',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  TextSpan(
                      text: '${product?.productCost}원',
                      style: const TextStyle(color: Colors.black))
                ])),
                Space(height: size.getSize(5.0)),
                _statusBadge(product),
              ],
            ),
            Expanded(child: Container()),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  size: size.getSize(25.0),
                  color: green,
                ))
          ],
        ),
        Space(height: size.getSize(8.0)),
        const CustomDivider()
      ],
    );
  }

  Widget _statusBadge(Product? product) {
    switch (product?.productStatusCd) {
      case 0:
        return Container();
      case 1:
        return const StatusBadge(
          label: '교환중',
          backgroundColor: green,
        );
      case 2:
        return const StatusBadge(
          label: '교환완료',
          backgroundColor: navy,
        );
    }
    return Container();
  }
}
