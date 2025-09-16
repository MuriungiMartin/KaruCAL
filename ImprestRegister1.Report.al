#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51336 "Imprest Register1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Register1.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(UnknownTable61704;UnknownTable61704)
        {
            DataItemTableView = where(Posted=filter(Yes));
            RequestFilterFields = "No.",Date,Payee;
            column(ReportForNavId_1102755009; 1102755009)
            {
            }
            column(No;"FIN-Imprest Header"."No.")
            {
            }
            column(AccNo;"FIN-Imprest Header"."Account No.")
            {
            }
            column(Payee;"FIN-Imprest Header".Payee)
            {
            }
            column(ChequeNo;"FIN-Imprest Header"."Cheque No.")
            {
            }
            column(DocDates;"FIN-Imprest Header".Date)
            {
            }
            column(Purpose;"FIN-Imprest Header".Purpose)
            {
            }
            column(Amount;"FIN-Imprest Header"."Total Net Amount")
            {
            }
            column(DatetoAccount;"FIN-Imprest Header".Date)
            {
            }
            column(CustName;Cust.Name)
            {
            }
            column(ReportFilters;ReportFilters)
            {
            }
            column(CompName;compInfo.Name)
            {
            }
            column(Addresses;compInfo.Address+', '+compInfo."Address 2")
            {
            }
            column(Telephone;compInfo."Phone No."+'/'+compInfo."Phone No. 2")
            {
            }
            column(Emails;compInfo."E-Mail"+'/'+compInfo."Home Page")
            {
            }
            dataitem(FINImprestSurrHeader;UnknownTable61504)
            {
                DataItemLink = "Imprest Issue Doc. No"=field("No.");
                column(ReportForNavId_1000000006; 1000000006)
                {
                }
                column(DateAccounted;FINImprestSurrHeader."Surrender Date")
                {
                }
                column(AmountSpent;FINImprestSurrHeader."Actual Spent")
                {
                }
                column(OverSpent;FINImprestSurrHeader."Over Expenditure")
                {
                }
                column(CashSurrendered;FINImprestSurrHeader."Cash Surrender Amt")
                {
                }
                column(surrNo;FINImprestSurrHeader.No)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                "FIN-Imprest Header".CalcFields("FIN-Imprest Header"."Total Payment Amount");

                Cust.Reset;
                Cust.SetRange(Cust."No.","FIN-Imprest Header"."Account No.");
                if Cust.Find('-') then begin
                  end;



                FINImprestSurrHeader.Reset;
                FINImprestSurrHeader.SetRange(FINImprestSurrHeader."Imprest Issue Doc. No","FIN-Imprest Header"."No.");
                if FINImprestSurrHeader.Find('-') then begin
                  FINImprestSurrHeader.CalcFields("Cash Receipt No","Cash Surrender Amt","Over Expenditure","Actual Spent");
                  end;// ELSE IF FINImprestSurrHeader.FINDLAST THEN BEGIN
                   // END;
            end;

            trigger OnPreDataItem()
            begin
                ReportFilters:="FIN-Imprest Header".GetFilters;
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

    trigger OnInitReport()
    begin
        Clear(ReportFilters);
        compInfo.Reset;
        if compInfo.Find('-') then begin
          end;
    end;

    var
        Cust: Record Customer;
        compInfo: Record "Company Information";
        ReportFilters: Text[1024];
}

