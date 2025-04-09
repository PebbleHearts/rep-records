import 'package:flutter/material.dart';
import 'package:rep_records/screens/log-screen/components/log_set_item.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogItem extends StatelessWidget {
  const LogItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).extension<AppTheme>()!.background2,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Exercise name',
                  style: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()!.text,
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: IconButton(
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                            )),
                      ),
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: IconButton(
                          onPressed: () => {},
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          LogSetItem(),
          LogSetItem(),
          LogSetItem()
        ],
      ),
    );
  }
}