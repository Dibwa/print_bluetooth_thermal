import 'package:flutter/material.dart';

void b() {
  Builder(builder: (BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {} //scanBarcodeNormal()
                  ,
                  child: Text('Start barcode scan')),
              ElevatedButton(
                  onPressed: () {} //scanQR()
                  ,
                  child: Text('Start QR scan')),
              ElevatedButton(
                  onPressed: () {} //startBarcodeScanStream()
                  ,
                  child: Text('Start barcode scan stream')),
              ElevatedButton(
                  onPressed: () async {}, child: Text('Start sound')),
              Text('Scan result : ', style: TextStyle(fontSize: 20))
            ]));
  });
}
