import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.icon,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        child: TextButton(
          onPressed: press as void Function()?,
          child: Container(
            height: SizeConfig.orientation == Orientation.landscape
                ? getProportionateScreenHeight(150)
                : getProportionateScreenHeight(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: Theme.of(context).buttonColor,
              color: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: FaIcon(
                    icon,
                    color: Colors.red.shade500,
                    size: getProportionateScreenWidth(22),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5),
                ),
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(22),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
