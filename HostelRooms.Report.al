#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51243 "Hostel Rooms"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Rooms.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Ledger";"ACA-Hostel Ledger")
        {
            DataItemTableView = sorting("Hostel No");
            RequestFilterFields = "Hostel No";
            column(ReportForNavId_3889; 3889)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Hostel_Ledger__Hostel_No_;"Hostel No")
            {
            }
            column(Hostel_Ledger__Hostel_No__Control1000000011;"Hostel No")
            {
            }
            column(Hostel_Ledger__Room_No_;"Room No")
            {
            }
            column(Hostel_Ledger__Space_No_;"Space No")
            {
            }
            column(Hostel_Ledger_Status;Status)
            {
            }
            column(Hostel_RoomsCaption;Hostel_RoomsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Hostel_Ledger__Hostel_No__Control1000000011Caption;FieldCaption("Hostel No"))
            {
            }
            column(Hostel_Ledger__Room_No_Caption;FieldCaption("Room No"))
            {
            }
            column(Hostel_Ledger__Space_No_Caption;FieldCaption("Space No"))
            {
            }
            column(Hostel_Ledger_StatusCaption;FieldCaption(Status))
            {
            }
            column(Hostel_Ledger__Hostel_No_Caption;FieldCaption("Hostel No"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Hostel No");
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
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Hostel_RoomsCaptionLbl: label 'Hostel Rooms';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

