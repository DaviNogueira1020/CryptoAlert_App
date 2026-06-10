// Area onde tou fazendo testes por isso não estar no index() ainda

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/widgets/animated_background.dart'; // Import do AnimatedBackground

class TableScreen extends StatefulWidget {
  final Color textColor;

  const TableScreen({
    this.textColor = Colors.white,
    super.key,
  });

  @override
  State<TableScreen> createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  Widget buildCell(
    String text, {
    Widget? leading,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: color ?? widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xff111827),
      ),
      children: [
        buildCell("#"),
        buildCell("Coin"),
        buildCell("Price"),
        buildCell("24 Hours"),
      ],
    );
  }

  TableRow buildDataRow(
    String rank,
    String coin,
    String price,
    String change24h,
    bool isPositive, {
    String? coinSvg,
    String? changeSvg,
  }) {
    return TableRow(
      children: [
        buildCell(rank),

        buildCell(
          coin,
          leading: coinSvg == null
              ? Icon(
                  Icons.currency_bitcoin,
                  color: widget.textColor,
                  size: 18,
                )
              : SvgPicture.asset(
                  coinSvg,
                  width: 18,
                  height: 18,
                ),
        ),

        buildCell(price),

        buildCell(
          change24h,
          leading: changeSvg == null
              ? Icon(
                  isPositive
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: isPositive
                      ? Colors.green
                      : Colors.red,
                  size: 18,
                )
              : SvgPicture.asset(
                  changeSvg,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    isPositive
                        ? Colors.green
                        : Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
          color: isPositive
              ? Colors.green
              : Colors.red,
        ),
      ],
    );
  }

  Widget buildTable() {
    return Center(
      child: SizedBox(
        width: 460,
        child: Container(
          color: const Color(0xff0F1B3D),
          child: Table(
            border: TableBorder.all(
              color: const Color(0xff22D3EE),
              width: 1,
            ),
            defaultVerticalAlignment:
                TableCellVerticalAlignment.middle,
            children: [
              buildHeaderRow(),

              buildDataRow(
                "1",
                "Bitcoin",
                "\$85,000",
                "+2.5%",
                true,
              ),

              buildDataRow(
                "2",
                "Ethereum",
                "\$2,500",
                "+1.2%",
                true,
                coinSvg: "assets/Icons/home.svg",
              ),

              buildDataRow(
                "3",
                "Solana",
                "\$145",
                "-3.8%",
                false,
              ),

              buildDataRow(
                "4",
                "Cardano",
                "\$0.75",
                "+0.5%",
                true,
                changeSvg: "assets/Icons/turnSignalTrue.svg",
              ),

              buildDataRow(
                "5",
                "XRP",
                "\$2.10",
                "-1.1%",
                false,
              ),

              buildDataRow(
                "6",
                "Dogecoin",
                "\$0.18",
                "+7.4%",
                true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTable();
    return AnimatedBackground(
      child: Column(
        children: [
          const Header(),
          Expanded(
            child: buildTable(),
          ),
          const Footer(initialBottonClicked: 1),
        ],
      ),
    );
  }
}

// alias para usar no shell e ajudar
typedef TableContent = TableScreen;
