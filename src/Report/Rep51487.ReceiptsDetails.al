#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51487 "Receipts - Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipts - Details.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("User ID");
            RequestFilterFields = "User ID","Student No.","Receipt No.",Date;
            column(ReportForNavId_5672; 5672)
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
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt__Payment_Mode_;"Payment Mode")
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt__Transaction_Date_;"Transaction Date")
            {
            }
            column(Receipt__Transaction_Time_;"Transaction Time")
            {
            }
            column(SName;SName)
            {
            }
            column(Receipt_Entries___DetailedCaption;Receipt_Entries___DetailedCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt_Items_CodeCaption;"ACA-Receipt Items".FieldCaption(Code))
            {
            }
            column(Receipt_Items_DescriptionCaption;"ACA-Receipt Items".FieldCaption(Description))
            {
            }
            column(Receipt_Items_AmountCaption;"ACA-Receipt Items".FieldCaption(Amount))
            {
            }
            column(Receipt_Items_BalanceCaption;"ACA-Receipt Items".FieldCaption(Balance))
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt__Payment_Mode_Caption;FieldCaption("Payment Mode"))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__Transaction_Date_Caption;FieldCaption("Transaction Date"))
            {
            }
            column(Receipt__Transaction_Time_Caption;FieldCaption("Transaction Time"))
            {
            }
            column(SNameCaption;SNameCaptionLbl)
            {
            }
            column(Receipt_User_ID;"User ID")
            {
            }
            dataitem(UnknownTable61539;UnknownTable61539)
            {
                DataItemLink = "Receipt No"=field("Receipt No.");
                column(ReportForNavId_9528; 9528)
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
                column(Receipt_Items_Receipt_No;"Receipt No")
                {
                }
                column(Receipt_Items_Uniq_No_2;"Uniq No 2")
                {
                }
                column(Receipt_Items_Transaction_ID;"Transaction ID")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("ACA-Receipt"."Student No.") then
                SName:=Cust.Name
                else
                SName:='';
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("User ID");
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
        Cust: Record Customer;
        SName: Text[200];
        Receipt_Entries___DetailedCaptionLbl: label 'Receipt Entries - Detailed';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        SNameCaptionLbl: label 'Label1000000031';
}

