#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70090 "Expenditure Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Expenditure Details.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.","Posting Date");
            RequestFilterFields = "G/L Account No.","Posting Date";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(no;"G/L Entry"."G/L Account No.")
            {
            }
            column(name;"G/L Entry"."G/L Account Name")
            {
            }
            column(Posting;"G/L Entry"."Posting Date")
            {
            }
            column(Document;"G/L Entry"."Document No.")
            {
            }
            column(Payee;"G/L Entry".Payee)
            {
            }
            column(VendNo;"G/L Entry"."Source No.")
            {
            }
            column(Description;"G/L Entry".Description)
            {
            }
            column(Campus;"G/L Entry"."Global Dimension 1 Code")
            {
            }
            column(Dept;"G/L Entry"."Global Dimension 2 Code")
            {
            }
            column(Amount;"G/L Entry".Amount)
            {
            }
            column(Cheque;"G/L Entry"."External Document No.")
            {
            }
            column(VendName;vends)
            {
            }
            column(CompName;controlInf.Name)
            {
            }
            column(Address;controlInf.Address+'  '+controlInf."Address 2"+','+controlInf.City)
            {
            }
            column(Phone;controlInf."Phone No."+','+controlInf."Phone No. 2")
            {
            }
            column(email;controlInf."E-Mail")
            {
            }
            column(homePage;controlInf."Home Page")
            {
            }
            column(pic;controlInf.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin
                vend.Reset;
                Clear(vends);
                if "G/L Entry"."Source Type"="G/L Entry"."source type"::Vendor then begin
                  vend.SetRange("No.","G/L Entry"."Source No.");
                  if vend.Find('-') then begin
                vends:=vend.Name;
                  end;
                  end;

                if "G/L Entry"."Source Type"="G/L Entry"."source type"::Customer then begin
                  cust.SetRange("No.","G/L Entry"."Source No.");
                  if cust.Find('-') then begin
                vends:=cust.Name;
                  end;
                  end;
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
        controlInf.Reset;
        if controlInf.Find('-') then begin
         // controlInf.CALCFIELDS(Picture);
          end;
    end;

    var
        vend: Record Vendor;
        controlInf: Record "Company Information";
        vends: Text[100];
        cust: Record Customer;
}

