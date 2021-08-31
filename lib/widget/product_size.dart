part of 'widget.dart';

class ProductSize extends StatefulWidget {
  final List productSize;
  final Function(String) onSelect;
  ProductSize({
    this.productSize,
    this.onSelect,
  });

  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.productSize.length; i++)
          GestureDetector(
            onTap: () {
              widget.onSelect("${widget.productSize[i]}");
              setState(() {
                selected = i;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                color: selected == i ? Colors.orange : Colors.black12,
              ),
              width: 40,
              height: 40,
              child: Center(
                child: Text(
                  widget.productSize[i],
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
