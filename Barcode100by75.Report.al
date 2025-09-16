#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50017 "Barcode 100 by 75"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Barcode 100 by 75.rdlc';

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

            trigger OnAfterGetRecord()
            begin
                if Number > 1 then
                  QRCode_gRecTemp.Next
                else
                  QRCode_gRecTemp.FindFirst;
                QRCode_gRecTemp.CalcFields("QR Code");
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
    }

    var
        QRCode_gRecTemp: Record "FIN-Cash Office Setup" temporary;


    procedure TransfterDate_gFnc(var QCRec_vRec: Record "FIN-Cash Office Setup" temporary)
    begin
        QRCode_gRecTemp.Copy(QCRec_vRec,true);
    end;
}

