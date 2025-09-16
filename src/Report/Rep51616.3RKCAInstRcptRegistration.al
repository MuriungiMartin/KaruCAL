#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51616 "3R KCA Inst Rcpt Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/3R KCA Inst Rcpt Registration.rdlc';

    dataset
    {
        dataitem(UnknownTable61539;UnknownTable61539)
        {
            DataItemTableView = sorting("Receipt No");
            RequestFilterFields = "Transaction ID";
            column(ReportForNavId_9528; 9528)
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
            column(Receipt_Items__Receipt_No_;"Receipt No")
            {
            }
            column(Receipt_Items_Code;Code)
            {
            }
            column(Receipt_Items_Description;Description)
            {
            }
            column(Receipt_Items_Amount;Amount)
            {
            }
            column(Receipt_Items_Balance;Balance)
            {
            }
            column(Receipt_Items_Date;Date)
            {
            }
            column(Receipt_ItemsCaption;Receipt_ItemsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt_Items__Receipt_No_Caption;FieldCaption("Receipt No"))
            {
            }
            column(Receipt_Items_CodeCaption;FieldCaption(Code))
            {
            }
            column(Receipt_Items_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Receipt_Items_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt_Items_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Receipt_Items_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt_Items_Uniq_No_2;"Uniq No 2")
            {
            }
            column(Receipt_Items_Transaction_ID;"Transaction ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                StudCharges.Reset;
                StudCharges.SetCurrentkey(StudCharges."Transacton ID",StudCharges."Student No.");
                StudCharges.SetRange(StudCharges."Student No.","ACA-Receipt Items"."Student No.");
                StudCharges.SetRange(StudCharges."Transacton ID","ACA-Receipt Items"."Transaction ID");
                if StudCharges.Find('-') then begin
                "ACA-Receipt Items".Code:=StudCharges.Code;
                "ACA-Receipt Items".Programme:=StudCharges.Programme;
                "ACA-Receipt Items".Stage:=StudCharges.Stage;
                "ACA-Receipt Items".Unit:=StudCharges.Unit;
                "ACA-Receipt Items".Semester:=StudCharges.Semester;
                "ACA-Receipt Items".Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //"Receipt Items".MODIFYALL("Receipt Items"."Transaction ID",'');
                //"Receipt Items".MODIFYALL("Receipt Items"."Student No.",'');
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
        Rcpt: Record UnknownRecord61538;
        StudCharges: Record UnknownRecord61535;
        Receipt_ItemsCaptionLbl: label 'Receipt Items';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

