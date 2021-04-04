import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StocialGroupedList extends StatefulWidget {

  final List<String> groupsNames;
  final int Function(String groupIndex) groupSize;
  final List<String> columns;
  final String Function({required String groupKey, required int itemIndex, required int columnIndex}) valueFor;

  StocialGroupedList({required this.groupsNames, required this.groupSize, required this.columns, required this.valueFor});

  @override
  State<StatefulWidget> createState() {
    return StocialGroupedListState();
  }

}

class StocialGroupedListState extends State<StocialGroupedList> {
  var _groupListController = ScrollController();

  int selectedGroup = 0;

  @override
  void initState() {
    super.initState();

    _groupListController.addListener(() {
      double position = _groupListController.offset;
      for(int i = 0; i < widget.groupsNames.length; i++) {
        if(position >= _getScrollPositionForGroup(i)) {
          setState(() {
            selectedGroup = i;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 50,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )
                ),
                child: _buildTypeIndexList(),
              ),
              Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for(String column in widget.columns) ... [
                              Text(
                                column,
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                            ]
                          ],
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                            child: _buildList(),
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                        ),
                        // child: Crop(
                        //   child: _buildList(),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))
                        //   ),
                        // ),
                      )
                    ])
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: widget.groupsNames.length,
        controller: _groupListController,
        itemBuilder: (context, groupIndex) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                    ),
                    child: Text(
                      widget.groupsNames[groupIndex],
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                  color: Colors.blue,
                ),
                Flexible(
                  child: StocialList(
                    lenght: widget.groupSize(widget.groupsNames[groupIndex]),
                    valueFor: (itemIndex, int columnIndex) {
                      return widget.valueFor(groupKey: widget.groupsNames[groupIndex], columnIndex: columnIndex, itemIndex: itemIndex);
                    },
                    columns: widget.columns.length,
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _buildTypeIndexList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 40),
      itemCount: widget.groupsNames.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Material(
            color: selectedGroup == index ? Colors.white : Color(0xbbffffff),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    "${widget.groupsNames[index]}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () {
                _groupListController.animateTo(_getScrollPositionForGroup(index), curve: Curves.easeIn, duration: Duration(milliseconds: 300));
              },
            ),
          ),
        );
      });
  }

  double _getScrollPositionForGroup(int index) {
    double position = 0;
    String groupKey = widget.groupsNames[index];
    for(int i = 0; i < widget.groupsNames.length; i++) {
      final iKey = widget.groupsNames[i];
      if(iKey == groupKey) break;
      position += 37;
      position += widget.groupSize(iKey) * 47;

    }
    return position;
  }
}

class StocialList extends StatelessWidget {

  final int lenght, columns;
  final String Function(int index, int columnIndex) valueFor;

  StocialList({required this.lenght, required this.valueFor, required this.columns});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: lenght,
        itemBuilder: (context, index) {
          return Container(
            color: index % 2 == 0 ? Colors.blue[50] : Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for(int i = 0; i < columns; i++) ... [
                        Text(
                            valueFor(index, i)
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
    });
  }

}