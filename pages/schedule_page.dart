import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, i) {
          return Column(
            children: [
              const SizedBox(height: 10.0),
              SizedBox(
                width: 390.0,
                height: 48.0,
                child: Row(
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, j) {
                          return Container(
                            width: 390 / 5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                          );
                        }),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
