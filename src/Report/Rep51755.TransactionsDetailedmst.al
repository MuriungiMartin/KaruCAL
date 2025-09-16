#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51755 "Transactions - Detailed mst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Transactions - Detailed mst.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Transaction Code","Employee Code","Payroll Period");
            RequestFilterFields = "Payroll Period","Transaction Code",Department,"Location/Division","Employee Classification",State;
            column(ReportForNavId_7769; 7769)
            {
            }
            column(GETFILTERS;GetFilters)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(prPeriod_Transactions__Transaction_Code_;"Transaction Code")
            {
            }
            column(prPeriod_Transactions__Transaction_Name_;"Transaction Name")
            {
            }
            column(prPeriod_Transactions__Employee_Code_;"Employee Code")
            {
            }
            column(prPeriod_Transactions_Membership;Membership)
            {
            }
            column(prPeriod_Transactions_Amount;Amount)
            {
            }
            column(prPeriod_Transactions_Balance;Balance)
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(prPeriod_Transactions_Amount_Control1102755029;Amount)
            {
            }
            column(prPeriod_Transactions_Balance_Control1102755030;Balance)
            {
            }
            column(RCount;RCount)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Transactions___DetailedCaption;Transactions___DetailedCaptionLbl)
            {
            }
            column(prPeriod_Transactions__Transaction_Code_Caption;FieldCaption("Transaction Code"))
            {
            }
            column(prPeriod_Transactions__Transaction_Name_Caption;FieldCaption("Transaction Name"))
            {
            }
            column(prPeriod_Transactions_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(prPeriod_Transactions_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Membership_No_Caption;Membership_No_CaptionLbl)
            {
            }
            column(prPeriod_Transactions__Employee_Code_Caption;FieldCaption("Employee Code"))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(prPeriod_Transactions_Period_Month;"Period Month")
            {
            }
            column(prPeriod_Transactions_Period_Year;"Period Year")
            {
            }
            column(prPeriod_Transactions_Reference_No;"Reference No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                EmpName:='';
                if Employee.Get("Employee Code") then begin
                EmpName:=Employee."Last Name"+' '+Employee."First Name"+' '+Employee."Middle Name";
                end;

                RCount:=RCount+1;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Transaction Code");

                RCount:=1;

                if CompanyInfo.Get() then
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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
        Employee: Record UnknownRecord61118;
        EmpName: Text[200];
        RCount: Integer;
        CompanyInfo: Record "Company Information";
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Transactions___DetailedCaptionLbl: label 'Transactions - Detailed';
        Membership_No_CaptionLbl: label 'Membership No.';
        NamesCaptionLbl: label 'Names';
}

