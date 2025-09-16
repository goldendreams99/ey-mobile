part of employ.widgets;

class RelationShipCard extends StatelessWidget {
  final int index;
  final dynamic value;
  final Map<String, TextEditingController> controllers;
  final Function(int, dynamic) onSelected;
  final Function(int, String, dynamic) onChanged;
  final Function(int) onLocation;
  final ValueChanged<int> onRemove;

  const RelationShipCard({
    required this.index,
    required this.value,
    required this.controllers,
    required this.onSelected,
    required this.onChanged,
    required this.onLocation,
    required this.onRemove,
  });

  TextStyle get hintStyle => FONT.REGULAR.merge(
        TextStyle(color: COLOR.white.withOpacity(0.5), fontSize: 20.0),
      );
  TextStyle get labelStyle => FONT.SEMIBOLD.merge(
        TextStyle(
          color: COLOR.very_light_pink_five,
          fontSize: 11.0,
        ),
      );
  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );

  bool get canClose {
    bool close = false;
    Map.from(value).keys.forEach((k) {
      if (value[k] != null && value[k].toString().isNotEmpty) close = true;
    });
    return close;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7.5),
          width: calcSize(size, 250.0),
          height: calcSize(size, 340.0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(21.5, 10.0, 21.5, 0.0),
                child: Column(
                  children: <Widget>[
                    InkResponse(
                      onTap: () => onSelected(index, value),
                      child: UnderlineTextField(
                        height: calcSize(size, 51.0),
                        controller: controllers['relationship']!,
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        label: 'Parentesco',
                        hint: 'Madre',
                        color: COLOR.white,
                        type: TextInputType.text,
                        insidePadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 9.0),
                        suffixIcon: EmployIcons.chevron_right,
                        style: textStyle,
                        hintStyle: hintStyle,
                        labelStyle: labelStyle,
                        enabled: false,
                      ),
                    ),
                    UnderlineTextField(
                      height: calcSize(size, 51.0),
                      controller: controllers['name']!,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      label: 'Nombre Completo',
                      hint: 'Ana María Linares ',
                      color: COLOR.white,
                      type: TextInputType.text,
                      insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                      suffixIcon: EmployIcons.edit,
                      style: textStyle,
                      hintStyle: hintStyle,
                      labelStyle: labelStyle,
                      onChange: (text) => onChanged(index, 'document', text),
                    ),
                    UnderlineTextField(
                      height: calcSize(size, 51.0),
                      controller: controllers['document']!,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      label: 'N° Documento',
                      hint: '123456789 ',
                      color: COLOR.white,
                      type: TextInputType.number,
                      insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                      suffixIcon: EmployIcons.edit,
                      style: textStyle,
                      hintStyle: hintStyle,
                      labelStyle: labelStyle,
                      onChange: (text) => onChanged(index, 'document', text),
                    ),
                    InkResponse(
                      onTap: () => onLocation(index),
                      child: UnderlineTextField(
                        controller: controllers['address']!,
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        label: 'Domicilio',
                        hint: 'Esmeralda 850, Buenos Aires',
                        color: COLOR.white,
                        type: TextInputType.text,
                        insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                        suffixIcon: EmployIcons.chevron_right,
                        style: textStyle,
                        hintStyle: hintStyle,
                        labelStyle: labelStyle,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: canClose
                    ? InkResponse(
                        onTap: () => onRemove(index),
                        child: Container(
                          width: calcSize(size, 20.0),
                          height: calcSize(size, 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: COLOR.white),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                EmployIcons.close,
                                size: 8.0,
                                color: COLOR.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: COLOR.bluish,
            border: Border.all(width: 3.0, color: COLOR.white),
            borderRadius: BorderRadius.circular(19.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: COLOR.black_50,
                spreadRadius: -1,
                offset: Offset(0, 1),
              )
            ],
          ),
        ),
      ],
    );
  }
}
