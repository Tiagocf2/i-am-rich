import 'package:flutter/material.dart';
import 'package:i_am_rich/models.dart';
import 'package:provider/provider.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Stats>(
      builder: (context, stats, child) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text('Shop', style: Theme.of(context).textTheme.headline2),
            ),
            Text(
              "${stats.money}\$",
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 40, right: 40, bottom: 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Tap Power: ${stats.tapValue}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          'MPS: ${stats.mps}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  ItemRow(itemId: Tap.ID),
                  ItemRow(itemId: Clicker.ID),
                  ItemRow(itemId: Farm.ID),

                  // ItemRow(itemId: Clicker.ID),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class ItemRow extends StatefulWidget {
  final int itemId;

  const ItemRow({super.key, required this.itemId});

  @override
  State<ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  late Item item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stats>(
      builder: (context, stats, child) {
        void upgrade({int amount = 1}) {
          stats.upgrade(widget.itemId, amount: amount);
        }

        void Function()? canAfford =
            stats.canAfford(widget.itemId) ? upgrade : null;

        if (stats.items[widget.itemId] == null) {
          throw Exception('Item ${widget.itemId} não existe');
        }

        item = stats.items[widget.itemId]!;

        return SizedBox(
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        '${item.amount}x',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      ElevatedButton(
                        onPressed: canAfford,
                        child: Column(
                          children: [
                            Text('Buy \$${item.price}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
