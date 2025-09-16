#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51297 "Bank Transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Transfer.rdlc';

    dataset
    {
        dataitem(UnknownTable61180;UnknownTable61180)
        {
            DataItemTableView = sorting("To Account No");
            RequestFilterFields = "To Account No";
            column(ReportForNavId_8573; 8573)
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
            column(Office_Transactions__To_Account_No_;"To Account No")
            {
            }
            column(Office_Transactions_No;No)
            {
            }
            column(Office_Transactions_Description;Description)
            {
            }
            column(Office_Transactions_Date;Date)
            {
            }
            column(Office_Transactions__From_Account_No_;"From Account No")
            {
            }
            column(Office_Transactions__To_Account_No__Control1102760023;"To Account No")
            {
            }
            column(Office_Transactions__Raised_By_;"Raised By")
            {
            }
            column(Office_Transactions__Posted_By_;"Posted By")
            {
            }
            column(Office_Transactions_Amount;Amount)
            {
            }
            column(TotalFor___FIELDCAPTION__To_Account_No__;TotalFor + FieldCaption("To Account No"))
            {
            }
            column(Office_Transactions_Amount_Control1102760035;Amount)
            {
            }
            column(Bank_TransferCaption;Bank_TransferCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Office_Transactions_NoCaption;FieldCaption(No))
            {
            }
            column(Office_Transactions_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Office_Transactions_DateCaption;FieldCaption(Date))
            {
            }
            column(Office_Transactions__From_Account_No_Caption;FieldCaption("From Account No"))
            {
            }
            column(Office_Transactions__To_Account_No__Control1102760023Caption;FieldCaption("To Account No"))
            {
            }
            column(Office_Transactions__Raised_By_Caption;FieldCaption("Raised By"))
            {
            }
            column(Office_Transactions__Posted_By_Caption;FieldCaption("Posted By"))
            {
            }
            column(Office_Transactions_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Office_Transactions__To_Account_No_Caption;FieldCaption("To Account No"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("To Account No");
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
        TotalFor: label 'Total for ';
        Bank_TransferCaptionLbl: label 'Bank Transfer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

