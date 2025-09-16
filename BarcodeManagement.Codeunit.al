#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50011 "Barcode Management"
{

    trigger OnRun()
    begin
        EncodingOption := EncodingOption.EncodingOptions();
        EncodingOption.Height := 300;
        EncodingOption.Width := 300;

        barcodeWriter := barcodeWriter.BarcodeWriter();
        barcodeWriter.Format := BarcodeFormat.QR_CODE;
        barcodeWriter.Options := EncodingOption;
        MyURL := 'http://dynamicsuser.net/nav/b/ara3n';

        BitMatrix := barcodeWriter.Encode(MyURL);
        bitmap := barcodeWriter.Write(BitMatrix);

        bitmap.Save('C:\temp\qrcode.bmp');
    end;

    var
        [RunOnClient]
        BarcodeFormat: dotnet BarcodeFormat;
        [RunOnClient]
        ImageFormat: dotnet ImageFormat;
        [RunOnClient]
        barcodeWriter: dotnet BarcodeWriter;
        [RunOnClient]
        EncodingOption: dotnet EncodingOptions;
        [RunOnClient]
        bitmap: dotnet Bitmap;
        [RunOnClient]
        BitMatrix: dotnet BitMatrix;
        MyURL: Text;
}

