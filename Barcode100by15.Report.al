#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50018 "Barcode 100 by 15"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Barcode 100 by 15.rdlc';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            column(ReportForNavId_33027920; 33027920)
            {
            }
            column(QRCode_gRecTemp_Entry_No;QRCode_gRecTemp."Entry No.")
            {
            }
            column(QRCode_gRecTemp_QR_Code;QRCode_gRecTemp."QR Code")
            {
            }
            column(Text1;QRCode_gRecTemp."Text 1")
            {
            }
            column(Text2;QRCode_gRecTemp."Text 2")
            {
            }
            column(Text3;QRCode_gRecTemp."Text 3")
            {
            }
            column(Description;Description_gTxt)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number > 1 then
                  QRCode_gRecTemp.Next
                else
                  QRCode_gRecTemp.FindFirst;
                QRCode_gRecTemp.CalcFields("QR Code");

                Description_gTxt := '';

                Description_gTxt :=  Text000_gCtx + ' ' + QRCode_gRecTemp."Text 1" + ' ' + Text100_gCtx;
                Description_gTxt +=  Text001_gCtx + ' ' + QRCode_gRecTemp."Text 2" + ' ' + Text100_gCtx;
                Description_gTxt +=  Text002_gCtx + ' ' + QRCode_gRecTemp."Text 3";
            end;

            trigger OnPreDataItem()
            begin
                QRCode_gRecTemp.Reset;
                SetRange(Number,1,QRCode_gRecTemp.Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ItemNo_Lbl = 'Item No.';
        PartNo_Lbl = 'Part No.';
        SrNo_Lbl = 'Sr. No.';
        ComapnyName_Lbl = 'SCHILLER';
    }

    var
        QRCode_gRecTemp: Record "FIN-Cash Office Setup" temporary;
        Description_gTxt: Text;
        Text000_gCtx: label 'Item Desc :';
        Text001_gCtx: label 'Part No. :';
        Text002_gCtx: label 'Sr No. :';
        Text100_gCtx: label '<BR/>';
        Text101_gCtx: label '<B>';
        Text102_gCtx: label '<B/>';


    procedure TransfterDate_gFnc(var QCRec_vRec: Record "FIN-Cash Office Setup" temporary)
    begin
        QRCode_gRecTemp.Copy(QCRec_vRec,true);
    end;
}

