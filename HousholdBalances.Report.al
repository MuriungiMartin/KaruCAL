#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78097 "Houshold Balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Houshold Balances.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Type"=const(Student));
            RequestFilterFields = "Date Filter","No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_Customer;Customer."No.")
            {
            }
            column(Name_Customer;Customer.Name)
            {
            }
            column(HouseholdDebit;DebitH)
            {
            }
            column(HouseholdCredit;CreditH)
            {
            }
            column(HouseholdBalance;BalanceH)
            {
            }
            column(CompName;CompanyInfo.Name)
            {
            }
            column(CompPic;CompanyInfo.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Bandentry.Reset;
                Bandentry.SetRange("Student No.",Customer."No.");
                if not Bandentry.FindFirst then CurrReport.Skip;
                if SyncBalances then Report.Run(78095,false,false);
                NFM.Reset;
                NFM.SetRange("Student No.",Customer."No.");
                NFM.SetFilter(Date,DateFilter);
                if NFM.FindSet then begin
                  NFM.CalcFields(Balance);
                  NFM.CalcSums("Debit amount","Credit amount");
                  DebitH:=NFM."Debit amount";
                  CreditH:=NFM."Credit amount";
                  BalanceH:=NFM.Balance;
                  end else CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Sync Balances";SyncBalances)
                {
                    ApplicationArea = Basic;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        HouseHoldFee: Decimal;
        DebitH: Decimal;
        CreditH: Decimal;
        BalanceH: Decimal;
        CompanyInfo: Record "Company Information";
        NFM: Record "NFM Statement Entry";
        DateFilter: Text;
        SyncBalances: Boolean;
        Bandentry: Record "Funding Band Entries";
}

