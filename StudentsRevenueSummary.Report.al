#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51482 "Students Revenue Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Students Revenue Summary.rdlc';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            DataItemTableView = where("Global Dimension No."=const(4));
            RequestFilterFields = "Semester Filter";
            column(ReportForNavId_1; 1)
            {
            }
            column(Code_DimensionValue;"Dimension Value".Code)
            {
            }
            column(CompName;CompIf.Name)
            {
            }
            column(Name_DimensionValue;"Dimension Value".Name)
            {
            }
            column(SemesterFilter_DimensionValue;"Dimension Value"."Semester Filter")
            {
            }
            dataitem(UnknownTable61515;UnknownTable61515)
            {
                DataItemTableView = where(Show=const(Yes));
                column(ReportForNavId_4; 4)
                {
                }
                column(Code_Charge;"ACA-Charge".Code)
                {
                }
                column(Description_Charge;"ACA-Charge".Description)
                {
                }
                column(BillAmount;BillAmount)
                {
                }
                column(RecAmount;RecAmount)
                {
                }
                column(Balance;Bal)
                {
                }
                column(Perc;Perc)
                {
                }

                trigger OnAfterGetRecord()
                begin
                      BillAmount:=0;
                      RecAmount:=0;
                      Bal:=0;
                      Perc:=0;
                      Cust.Reset;
                      Cust.SetFilter(Cust."Current Faculty","Dimension Value".Code);
                      Cust.SetFilter(Cust."Semester Filter","Dimension Value".GetFilter("Dimension Value"."Semester Filter"));
                      Cust.SetFilter(Cust."Charge Filter","ACA-Charge".Code);
                      if Cust.Find('-') then begin
                      repeat
                      Cust.CalcFields(Cust."Charges Amount");
                      Cust.CalcFields(Cust.Balance);
                      Cust.CalcFields(Cust."Credit Amount");
                      if Cust."Credit Amount">Cust."Charges Amount" then
                      RecAmount:=RecAmount+Cust."Charges Amount";
                      BillAmount:=BillAmount+Cust."Charges Amount";
                      until Cust.Next=0;
                      end;
                      Bal:=BillAmount-RecAmount;
                      if (BillAmount>0) and (RecAmount>0) then
                      Perc:=(RecAmount/BillAmount)*100;

                      if BillAmount=0 then
                      CurrReport.Skip;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                  CompIf.Get;
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
        Cust: Record Customer;
        BillAmount: Decimal;
        RecAmount: Decimal;
        Bal: Decimal;
        Perc: Decimal;
        CompIf: Record "Company Information";
}

