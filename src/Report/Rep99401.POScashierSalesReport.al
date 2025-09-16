#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99401 "POS cashier Sales Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POS cashier Sales Report.rdlc';
    UsageCategory = Lists;

    dataset
    {
        dataitem(posHeader;"POS Sales Header")
        {
            DataItemTableView = where(Posted=filter(true));
            RequestFilterFields = Cashier,"Posting date";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_posHeader;posHeader."No.")
            {
            }
            column(PostingDescription_posHeader;posHeader."Posting Description")
            {
            }
            column(TotalAmount_posHeader;posHeader."Total Amount")
            {
            }
            column(Postingdate_posHeader;Format(posHeader."Posting date"))
            {
            }
            column(Cashier_posHeader;posHeader.Cashier)
            {
            }
            column(CustomerType_posHeader;posHeader."Customer Type")
            {
            }
            column(BankAccount_posHeader;posHeader."Bank Account")
            {
            }
            column(IncomeAccount_posHeader;posHeader."Income Account")
            {
            }
            column(AmountPaid_posHeader;posHeader."Amount Paid")
            {
            }
            column(Balance_posHeader;posHeader.Balance)
            {
            }
            column(CName;Info.Name)
            {
            }
            column(address;Info.Address)
            {
            }
            column(cphone;Info."Phone No.")
            {
            }
            column(logo;Info.Picture)
            {
            }
            column(email;Info."E-Mail")
            {
            }
            column(url;Info."Home Page")
            {
            }

            trigger OnAfterGetRecord()
            begin
                sheader.Reset();
                  sheader.SetRange("No.", "No.");
                  if sheader.Find('-') then begin
                      sheader.CalcFields("Total Amount");
                      ttamount := sheader."Total Amount";
                  end;
            end;

            trigger OnPreDataItem()
            begin
                Info.Get;
                Info.CalcFields(Picture);
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
        Info: Record "Company Information";
        sheader: Record "POS Sales Header";
        ttamount: Decimal;
}

