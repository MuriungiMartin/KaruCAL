#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50004 "QR Code Mgt."
{
    // ------------------------------------------------------------------------------------------------------------------------------
    // Intech-Systems-info@intech-systems.com
    // ------------------------------------------------------------------------------------------------------------------------------
    // ID                     DATE         AUTHOR
    // ------------------------------------------------------------------------------------------------------------------------------
    // I-I032-550009-01       11/06/15     Chintan Panchal
    //                        NAV-Barcode Integration
    //                        New Codeunit for Barcode sticker print
    // ------------------------------------------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        AuditFileName_gTxt: Text;
        AuditFile_gFil: File;
        FileName_gTxt: Text;
        Window: Dialog;
        OutStream_gOsm: OutStream;
        FileMgt_gCdu: Codeunit "File Management";
        ServerFileName_gTxt: Text;


    procedure BarcodeForPurchaseRcptLine_gFnc(PurchRcptLine_iRec: Record "Purch. Rcpt. Line";Barcode100By75: Boolean;Barcode100By15: Boolean;Barcode50By20: Boolean;Barcode20By06: Boolean)
    var
        ItemLedgEntry_lRec: Record "Item Ledger Entry";
        Text5000_Ctx: label '<xpml><page quantity=''0'' pitch=''74.1 mm''></xpml>SIZE 100 mm, 74.1 mm';
        Text5001_Ctx: label 'DIRECTION 0,0';
        Text5002_Ctx: label 'REFERENCE 0,0';
        Text5003_Ctx: label 'OFFSET 0 mm';
        Text5004_Ctx: label 'SET PEEL OFF';
        Text5005_Ctx: label 'SET CUTTER OFF';
        Text5006_Ctx: label 'SET PARTIAL_CUTTER OFF';
        Text5007_Ctx: label '<xpml></page></xpml><xpml><page quantity=''1'' pitch=''74.1 mm''></xpml>SET TEAR ON';
        Text5008_Ctx: label 'CLS';
        Text5009_Ctx: label 'CODEPAGE 1252';
        Text5010_Ctx: label 'TEXT 806,792,"0",180,17,14,"SCHILLER_"';
        Text5011_Ctx: label 'TEXT 1093,443,"0",180,14,12,"Item"';
        Text5012_Ctx: label 'TEXT 1093,303,"0",180,10,12,"Part No."';
        Text5013_Ctx: label 'TEXT 1093,166,"0",180,12,12,"Sr. No."';
        Text5014_Ctx: label 'TEXT 933,443,"0",180,14,12,":"';
        Text5015_Ctx: label 'TEXT 933,303,"0",180,14,12,":"';
        Text5016_Ctx: label 'TEXT 933,166,"0",180,14,12,":"';
        Text5017_Ctx: label 'TEXT 896,303,"0",180,10,12,"%1"';
        Text5018_Ctx: label 'TEXT 896,166,"0",180,10,12,"%1"';
        Text5019_Ctx: label 'QRCODE 330,300,L,10,A,180,M2,S7,"%1"';
        Text5020_Ctx: label 'TEXT 896,443,"0",180,10,12,"%1"';
        Text5021_Ctx: label 'PRINT 1,1';
        Text5022_Ctx: label '<xpml></page></xpml><xpml><end/></xpml>';
        QRTempBlob_lRecTmp: Record "FIN-Cash Office Setup" temporary;
        SRNo_lInt: Integer;
        QRCodeInput: Text;
        TempBlob: Record TempBlob;
        R50017_lRpt: Report "ACA-Supp. Cons. Marksheet";
        R50018_lRpt: Report "Aca-Supp. Senate Summary x";
    begin
        QRTempBlob_lRecTmp.Reset;
        QRTempBlob_lRecTmp.DeleteAll;
        SRNo_lInt := 0;

        ItemLedgEntry_lRec.Reset;
        ItemLedgEntry_lRec.SetRange("Document Type",ItemLedgEntry_lRec."document type" :: "Purchase Receipt");
        ItemLedgEntry_lRec.SetRange("Document No.",PurchRcptLine_iRec."Document No.");
        ItemLedgEntry_lRec.SetRange("Document Line No.",PurchRcptLine_iRec."Line No.");
        ItemLedgEntry_lRec.SetFilter(Quantity,'>%1',0);
        if ItemLedgEntry_lRec.FindSet then begin
          repeat
            SRNo_lInt += 1;
            Clear(QRTempBlob_lRecTmp);
            QRTempBlob_lRecTmp.Init;
            QRTempBlob_lRecTmp."Entry No." := SRNo_lInt;

            QRCodeInput := StrSubstNo('%1|%2|%3',ItemLedgEntry_lRec."Serial No.",ItemLedgEntry_lRec."Item No.",ItemLedgEntry_lRec."Warranty Date");
            CreateQRCode(QRCodeInput,TempBlob);
            QRTempBlob_lRecTmp."Text 1" := PurchRcptLine_iRec.Description;
            QRTempBlob_lRecTmp."Text 2" := ItemLedgEntry_lRec."Item No.";
            QRTempBlob_lRecTmp."Text 3" := ItemLedgEntry_lRec."Serial No.";
            QRTempBlob_lRecTmp."Text 4" := Format(ItemLedgEntry_lRec."Warranty Date");
            QRTempBlob_lRecTmp."QR Code" := TempBlob.Blob;
            QRTempBlob_lRecTmp.Insert;

          until ItemLedgEntry_lRec.Next = 0;
        end;


        QRTempBlob_lRecTmp.Reset;

        if Barcode100By75 then begin
          Clear(R50017_lRpt);
          R50017_lRpt.TransfterDate_gFnc(QRTempBlob_lRecTmp);
          //R50017_lRpt.USEREQUESTPAGE(FALSE);
          R50017_lRpt.RunModal;
        end;

        if Barcode100By15 then begin
          Clear(R50018_lRpt);
          R50018_lRpt.TransfterDate_gFnc(QRTempBlob_lRecTmp);
          //R50017_lRpt.USEREQUESTPAGE(FALSE);
          R50018_lRpt.RunModal;
        end;
    end;


    procedure BarcodeForTransferRcptLine_gFnc(TransferRcptLine_iRec: Record "Transfer Receipt Line";Barcode100By75: Boolean;Barcode100By15: Boolean;Barcode50By20: Boolean;Barcode20By06: Boolean)
    var
        ItemLedgEntry_lRec: Record "Item Ledger Entry";
    begin
        if Barcode100By75 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE100By75MMTRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';

        if Barcode100By15 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE100By15MMTRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';

        if Barcode50By20 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE5020ByMMTRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';

        if Barcode20By06 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE20By06MMTRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';




        AuditFileName_gTxt := FileName_gTxt;
        AuditFile_gFil.TextMode(true);
        AuditFile_gFil.WriteMode(true);
        AuditFile_gFil.Create(AuditFileName_gTxt);
        //AuditFile_gFil.OPEN(AuditFileName_gTxt);
        AuditFile_gFil.CreateOutstream(OutStream_gOsm);

        //ItemDescription_gTxt := TransferRcptLine_iRec.Description;
        ItemLedgEntry_lRec.Reset;
        ItemLedgEntry_lRec.SetRange("Document Type",ItemLedgEntry_lRec."document type" :: "Transfer Receipt");
        ItemLedgEntry_lRec.SetRange("Document No.",TransferRcptLine_iRec."Document No.");
        ItemLedgEntry_lRec.SetRange("Document Line No.",TransferRcptLine_iRec."Line No.");
        ItemLedgEntry_lRec.SetFilter(Quantity,'>%1',0);
        if ItemLedgEntry_lRec.FindSet then begin
          repeat
            if Barcode100By75 then
              BarcodeFileFor100By75MM_gFnc(ItemLedgEntry_lRec);
            if Barcode100By15 then
              BarcodeFileFor100By15MM_gFnc(ItemLedgEntry_lRec);
            if Barcode50By20 then
              BarcodeFileFor50By20MM_gFnc(ItemLedgEntry_lRec);
            if Barcode20By06 then
              BarcodeFileFor20By06MM_gFnc(ItemLedgEntry_lRec);
          until ItemLedgEntry_lRec.Next = 0;
        end;
        AuditFile_gFil.Close;

        if Barcode100By75 then
          BarcodeCommandPrompFile_gFnc(true,false,false,false);
        if Barcode100By15 then
          BarcodeCommandPrompFile_gFnc(false,true,false,false);
        if Barcode50By20 then
          BarcodeCommandPrompFile_gFnc(false,false,true,false);
        if Barcode20By06 then
          BarcodeCommandPrompFile_gFnc(false,false,false,true);
    end;


    procedure BarcodeForReturnRcptLine_gFnc(ReturnRcptLine_iRec: Record "Return Receipt Line";Barcode100By75: Boolean;Barcode100By15: Boolean;Barcode50By20: Boolean;Barcode20By06: Boolean)
    var
        ItemLedgEntry_lRec: Record "Item Ledger Entry";
    begin
        if Barcode100By75 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE100By75MMRRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';

        if Barcode100By15 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE100By15MMRRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';

        if Barcode50By20 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE5020ByMMRRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';

        if Barcode20By06 then
          FileName_gTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE20By06MMRRL' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.prn';




        AuditFileName_gTxt := FileName_gTxt;
        AuditFile_gFil.TextMode(true);
        AuditFile_gFil.WriteMode(true);
        AuditFile_gFil.Create(AuditFileName_gTxt);
        //AuditFile_gFil.OPEN(AuditFileName_gTxt);
        AuditFile_gFil.CreateOutstream(OutStream_gOsm);

        //ItemDescription_gTxt := ReturnRcptLine_iRec.Description;
        ItemLedgEntry_lRec.Reset;
        ItemLedgEntry_lRec.SetRange("Document Type",ItemLedgEntry_lRec."document type" :: "Sales Return Receipt");
        ItemLedgEntry_lRec.SetRange("Document No.",ReturnRcptLine_iRec."Document No.");
        ItemLedgEntry_lRec.SetRange("Document Line No.",ReturnRcptLine_iRec."Line No.");
        ItemLedgEntry_lRec.SetFilter(Quantity,'>%1',0);
        if ItemLedgEntry_lRec.FindSet then begin
          repeat
            if Barcode100By75 then
              BarcodeFileFor100By75MM_gFnc(ItemLedgEntry_lRec);
            if Barcode100By15 then
              BarcodeFileFor100By15MM_gFnc(ItemLedgEntry_lRec);
            if Barcode50By20 then
              BarcodeFileFor50By20MM_gFnc(ItemLedgEntry_lRec);
            if Barcode20By06 then
              BarcodeFileFor20By06MM_gFnc(ItemLedgEntry_lRec);
          until ItemLedgEntry_lRec.Next = 0;
        end;
        AuditFile_gFil.Close;

        if Barcode100By75 then
          BarcodeCommandPrompFile_gFnc(true,false,false,false);
        if Barcode100By15 then
          BarcodeCommandPrompFile_gFnc(false,true,false,false);
        if Barcode50By20 then
          BarcodeCommandPrompFile_gFnc(false,false,true,false);
        if Barcode20By06 then
          BarcodeCommandPrompFile_gFnc(false,false,false,true);
    end;


    procedure BarcodeCommandPrompFile_gFnc(Barcode100By75: Boolean;Barcode100By15: Boolean;Barcode50By20: Boolean;Barcode20By06: Boolean)
    var
        CmdAuditFileName_lTxt: Text;
        CmdAuditFile_lFil: File;
        CmdFileName_lTxt: Text;
        CmdOutStream_lOsm: OutStream;
        CommandLine_lTxt: Text;
        Text5025_gCtx: label 'type %1>>\\192.168.0.225\TSC_P300';
        Text5026_gCtx: label 'pause';
        WShell_gAut: Automation WshShell;
        CmdFilePath_gTxt: Text;
        DummyInt_gInt: Integer;
        WaitOnReturn_gBln: Boolean;
    begin
        if Barcode100By75 then
          CmdFileName_lTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE100By75MM' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                    '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.bat';

        if Barcode100By15 then
          CmdFileName_lTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE100By15MM' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.bat';

        if Barcode50By20 then
          CmdFileName_lTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE5020ByMM' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.bat';

        if Barcode20By06 then
          CmdFileName_lTxt := '\\INTECHSERVER\Shared\TempFilePath\BARCODE20By06MM' + Format(Today,0,'<Day,2><Month,2><Year4>') +
                                                                                   '_' + Format(Time,0,'<Hours24,2><Minutes,2>') + '.bat';

        //FORMAT(TODAY,0,'<Day,2><Month,2><Year4>') + '_' + FORMAT(TIME,0,'<Hours24,2><Minutes,2>')
        CommandLine_lTxt := '"' + FileName_gTxt + '"';
        CmdAuditFileName_lTxt := CmdFileName_lTxt;
        CmdAuditFile_lFil.TextMode(true);
        CmdAuditFile_lFil.WriteMode(true);
        CmdAuditFile_lFil.Create(CmdAuditFileName_lTxt);
        CmdAuditFile_lFil.CreateOutstream(CmdOutStream_lOsm);
        CmdOutStream_lOsm.WriteText(StrSubstNo(Text5025_gCtx,CommandLine_lTxt));
        CmdOutStream_lOsm.WriteText();
        CmdOutStream_lOsm.WriteText(Text5026_gCtx);
        CmdAuditFile_lFil.Close;

        Clear(WShell_gAut);
        CmdFilePath_gTxt := CmdFileName_lTxt;
        DummyInt_gInt := 1;
        WaitOnReturn_gBln := false;
        Create(WShell_gAut,false,true);
        WShell_gAut.Run(CmdFilePath_gTxt,DummyInt_gInt,WaitOnReturn_gBln);
        Clear(WShell_gAut);
    end;


    procedure BarcodeFileFor100By75MM_gFnc(ItemLedgEntry_iRec: Record "Item Ledger Entry")
    var
        Text5000_Ctx: label '<xpml><page quantity=''0'' pitch=''74.1 mm''></xpml>SIZE 100 mm, 74.1 mm';
        Text5001_Ctx: label 'DIRECTION 0,0';
        Text5002_Ctx: label 'REFERENCE 0,0';
        Text5003_Ctx: label 'OFFSET 0 mm';
        Text5004_Ctx: label 'SET PEEL OFF';
        Text5005_Ctx: label 'SET CUTTER OFF';
        Text5006_Ctx: label 'SET PARTIAL_CUTTER OFF';
        Text5007_Ctx: label '<xpml></page></xpml><xpml><page quantity=''1'' pitch=''74.1 mm''></xpml>SET TEAR ON';
        Text5008_Ctx: label 'CLS';
        Text5009_Ctx: label 'CODEPAGE 1252';
        Text5010_Ctx: label 'TEXT 806,792,"0",180,17,14,"SCHILLER_"';
        Text5011_Ctx: label 'TEXT 1093,443,"0",180,14,12,"Item"';
        Text5012_Ctx: label 'TEXT 1093,303,"0",180,10,12,"Part No."';
        Text5013_Ctx: label 'TEXT 1093,166,"0",180,12,12,"Sr. No."';
        Text5014_Ctx: label 'TEXT 933,443,"0",180,14,12,":"';
        Text5015_Ctx: label 'TEXT 933,303,"0",180,14,12,":"';
        Text5016_Ctx: label 'TEXT 933,166,"0",180,14,12,":"';
        Text5017_Ctx: label 'TEXT 896,303,"0",180,10,12,"%1"';
        Text5018_Ctx: label 'TEXT 896,166,"0",180,10,12,"%1"';
        Text5019_Ctx: label 'QRCODE 330,300,L,10,A,180,M2,S7,"%1|%2|%3"';
        Text5020_Ctx: label 'TEXT 896,443,"0",180,10,12,"%1"';
        Text5021_Ctx: label 'PRINT 1,1';
        Text5022_Ctx: label '<xpml></page></xpml><xpml><end/></xpml>';
    begin
        //Begin Output File
        OutStream_gOsm.WriteText(Text5000_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5001_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5002_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5003_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5004_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5005_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5006_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5007_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5008_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5009_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5010_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5011_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5012_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5013_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5014_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5015_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5016_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5017_Ctx,ItemLedgEntry_iRec."Item No."));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5018_Ctx,ItemLedgEntry_iRec."Serial No."));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5019_Ctx,ItemLedgEntry_iRec."Serial No.",ItemLedgEntry_iRec."Item No.",ItemLedgEntry_iRec."Warranty Date"));
        OutStream_gOsm.WriteText();
        //OutStream_gOsm.WRITETEXT(STRSUBSTNO(Text5020_Ctx,ItemDescription_gTxt));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5021_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5022_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText();
        //End Output File
    end;


    procedure BarcodeFileFor100By15MM_gFnc(ItemLedgEntry_iRec: Record "Item Ledger Entry")
    var
        Text5000_Ctx: label '<xpml><page quantity=''0'' pitch=''15.1 mm''></xpml>SIZE 100 mm, 15.1 mm';
        Text5001_Ctx: label 'DIRECTION 0,0';
        Text5002_Ctx: label 'REFERENCE 0,0';
        Text5003_Ctx: label 'OFFSET 0 mm';
        Text5004_Ctx: label 'SET PEEL OFF';
        Text5005_Ctx: label 'SET CUTTER OFF';
        Text5006_Ctx: label 'SET PARTIAL_CUTTER OFF';
        Text5007_Ctx: label '<xpml></page></xpml><xpml><page quantity=''1'' pitch=''15.1 mm''></xpml>SET TEAR ON';
        Text5008_Ctx: label 'CLS';
        Text5009_Ctx: label 'CODEPAGE 1252';
        Text5010_Ctx: label 'TEXT 886,153,"0",180,8,4,"SCHILLER_"';
        Text5011_Ctx: label 'TEXT 1134,116,"0",180,7,6,"Item"';
        Text5012_Ctx: label 'TEXT 1140,66,"0",180,5,6,"Part No."';
        Text5013_Ctx: label 'TEXT 1140,31,"0",180,7,5,"Sr. No."';
        Text5014_Ctx: label 'TEXT 1056,116,"0",180,7,6,":"';
        Text5015_Ctx: label 'TEXT 1056,67,"0",180,7,6,":"';
        Text5016_Ctx: label 'TEXT 1056,31,"0",180,7,6,":"';
        Text5017_Ctx: label 'TEXT 1034,66,"0",180,5,6,"%1"';
        Text5018_Ctx: label 'TEXT 1034,31,"0",180,5,6,"%1"';
        Text5019_Ctx: label 'QRCODE 531,143,L,4,A,180,M2,S7,"%1|%2|%3"';
        Text5020_Ctx: label 'TEXT 1034,116,"0",180,5,6,"%1"';
        Text5021_Ctx: label 'PRINT 1,1';
        Text5022_Ctx: label '<xpml></page></xpml><xpml><end/></xpml>';
    begin
        //Begin Output File
        OutStream_gOsm.WriteText(Text5000_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5001_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5002_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5003_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5004_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5005_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5006_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5007_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5008_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5009_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5011_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5012_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5013_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5014_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5015_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5016_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5017_Ctx,ItemLedgEntry_iRec."Item No."));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5018_Ctx,ItemLedgEntry_iRec."Serial No."));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5019_Ctx,ItemLedgEntry_iRec."Serial No.",ItemLedgEntry_iRec."Item No.",ItemLedgEntry_iRec."Warranty Date"));
        OutStream_gOsm.WriteText();
        //OutStream_gOsm.WRITETEXT(STRSUBSTNO(Text5020_Ctx,ItemDescription_gTxt));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5010_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5021_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5022_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText();
        //End Output File
    end;


    procedure BarcodeFileFor50By20MM_gFnc(ItemLedgEntry_iRec: Record "Item Ledger Entry")
    var
        Text5000_Ctx: label '<xpml><page quantity=''0'' pitch=''20.1 mm''></xpml>SIZE 50 mm, 20.1 mm';
        Text5001_Ctx: label 'DIRECTION 0,0';
        Text5002_Ctx: label 'REFERENCE 0,0';
        Text5003_Ctx: label 'OFFSET 0 mm';
        Text5004_Ctx: label 'SET PEEL OFF';
        Text5005_Ctx: label 'SET CUTTER OFF';
        Text5006_Ctx: label 'SET PARTIAL_CUTTER OFF';
        Text5007_Ctx: label '<xpml></page></xpml><xpml><page quantity=''1'' pitch=''20.1 mm''></xpml>SET TEAR ON';
        Text5008_Ctx: label 'CLS';
        Text5009_Ctx: label 'CODEPAGE 1252';
        Text5010_Ctx: label 'TEXT 886,153,"0",180,8,4,"SCHILLER_"';
        Text5011_Ctx: label 'TEXT 541,124,"0",180,7,6,"Item"';
        Text5012_Ctx: label 'TEXT 548,73,"0",180,5,6,"Part No."';
        Text5013_Ctx: label 'TEXT 548,43,"0",180,6,6,"Sr. No."';
        Text5014_Ctx: label 'TEXT 465,124,"0",180,7,6,":"';
        Text5015_Ctx: label 'TEXT 465,73,"0",180,7,6,":"';
        Text5016_Ctx: label 'TEXT 465,43,"0",180,7,6,":"';
        Text5017_Ctx: label 'TEXT 443,73,"0",180,5,6,"%1"';
        Text5018_Ctx: label 'TEXT 443,43,"0",180,5,6,"%1"';
        Text5019_Ctx: label 'QRCODE 159,132,L,5,A,180,M2,S7,"%1|%2|%3"';
        Text5020_Ctx: label 'TEXT 443,124,"0",180,5,6,"%1"';
        Text5021_Ctx: label 'PRINT 1,1';
        Text5022_Ctx: label '<xpml></page></xpml><xpml><end/></xpml>';
        Text5027_gCtx: label 'GAP 3 mm, 0 mm';
        Text5028_gCtx: label 'SET RIBBON ON';
    begin
        //Begin Output File
        OutStream_gOsm.WriteText(Text5000_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5027_gCtx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5028_gCtx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5001_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5002_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5003_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5004_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5005_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5006_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5007_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5008_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5009_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5011_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5012_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5013_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5014_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5015_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5016_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5017_Ctx,ItemLedgEntry_iRec."Item No."));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5018_Ctx,ItemLedgEntry_iRec."Serial No."));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5019_Ctx,ItemLedgEntry_iRec."Serial No.",ItemLedgEntry_iRec."Item No.",ItemLedgEntry_iRec."Warranty Date"));
        OutStream_gOsm.WriteText();
        //OutStream_gOsm.WRITETEXT(STRSUBSTNO(Text5020_Ctx,ItemDescription_gTxt));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5021_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5022_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText();
        //End Output File
    end;


    procedure BarcodeFileFor20By06MM_gFnc(ItemLedgEntry_iRec: Record "Item Ledger Entry")
    var
        Text5000_Ctx: label '<xpml><page quantity=''0'' pitch=''6.0 mm''></xpml>SIZE 20 mm, 6 mm';
        Text5001_Ctx: label 'DIRECTION 0,0';
        Text5002_Ctx: label 'REFERENCE 0,0';
        Text5003_Ctx: label 'OFFSET 0 mm';
        Text5004_Ctx: label 'SET PEEL OFF';
        Text5005_Ctx: label 'SET CUTTER OFF';
        Text5006_Ctx: label 'SET PARTIAL_CUTTER OFF';
        Text5007_Ctx: label '<xpml></page></xpml><xpml><page quantity=''1'' pitch=''6.0 mm''></xpml>SET TEAR ON';
        Text5008_Ctx: label 'CLS';
        Text5019_Ctx: label 'QRCODE 139,56,L,2,A,180,M2,S7,"%1|%2|%3"';
        Text5021_Ctx: label 'PRINT 1,1';
        Text5022_Ctx: label '<xpml></page></xpml><xpml><end/></xpml>';
    begin
        //Begin Output File
        OutStream_gOsm.WriteText(Text5000_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5001_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5002_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5003_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5004_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5005_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5006_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5007_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5008_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(StrSubstNo(Text5019_Ctx,ItemLedgEntry_iRec."Serial No.",ItemLedgEntry_iRec."Item No.",ItemLedgEntry_iRec."Warranty Date"));
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5021_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText(Text5022_Ctx);
        OutStream_gOsm.WriteText();
        OutStream_gOsm.WriteText();
        //End Output File
    end;


    procedure "-----QR-----"()
    begin
    end;

    local procedure CreateQRCode(QRCodeInput: Text[95];var TempBLOB: Record TempBlob)
    var
        QRCodeFileName: Text[1024];
    begin
        Clear(TempBLOB);
        QRCodeFileName := GetQRCode(QRCodeInput);
        UploadFileBLOBImportandDeleteServerFile(TempBLOB,QRCodeFileName);
    end;


    procedure UploadFileBLOBImportandDeleteServerFile(var TempBlob: Record TempBlob;FileName: Text[1024])
    var
        FileManagement: Codeunit "File Management";
    begin
        FileName := FileManagement.UploadFileSilent(FileName);
        FileManagement.BLOBImportFromServerFile(TempBlob,FileName);
        DeleteServerFile(FileName);
    end;

    local procedure DeleteServerFile(ServerFileName: Text)
    begin
        if Erase(ServerFileName) then;
    end;

    local procedure GetQRCode(QRCodeInput: Text[95]) QRCodeFileName: Text[1024]
    var
        [RunOnClient]
        IBarCodeProvider: dotnet IBarcodeProvider;
    begin
        GetBarCodeProvider(IBarCodeProvider);
        QRCodeFileName := IBarCodeProvider.GetBarcode(QRCodeInput);
    end;


    procedure GetBarCodeProvider(var IBarCodeProvider: dotnet IBarcodeProvider)
    var
        [RunOnClient]
        QRCodeProvider: dotnet QRCodeProvider;
    begin
        if IsNull(IBarCodeProvider) then
          IBarCodeProvider := QRCodeProvider.QRCodeProvider;
    end;
}

