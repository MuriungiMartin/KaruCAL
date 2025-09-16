#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50050 "Visitors Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Visitors Register.rdlc';

    dataset
    {
        dataitem("General Journal Archive";"General Journal Archive")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(VisitNo;"Visitors Ledger"."Visit No.")
            {
            }
            column(TransDate;"Visitors Ledger"."Transaction Date")
            {
            }
            column(IdNo;"Visitors Ledger"."ID No.")
            {
            }
            column(FullName;"Visitors Ledger"."Full Name")
            {
            }
            column(Phone;"Visitors Ledger"."Phone No.")
            {
            }
            column(Email;"Visitors Ledger".Email)
            {
            }
            column(Company;"Visitors Ledger".Company)
            {
            }
            column(Dept;"Visitors Ledger"."Office Station/Department")
            {
            }
            column(InBy;"Visitors Ledger"."Signed in by")
            {
            }
            column(TimeIn;"Visitors Ledger"."Time In")
            {
            }
            column(OutBy;"Visitors Ledger"."Signed Out By")
            {
            }
            column(TimeOut;"Visitors Ledger"."Time Out")
            {
            }
            column(Comment;"Visitors Ledger".Comment)
            {
            }
            column(CheckedOut;"Visitors Ledger"."Checked Out")
            {
            }
            column(CompName;compInfo.Name)
            {
            }
            column(CompAddress;compInfo.Address)
            {
            }
            column(CompCity;compInfo.City)
            {
            }
            column(CompPhone;compInfo."Phone No.")
            {
            }
            column(CompMail;compInfo."E-Mail")
            {
            }
            column(CompWeb;compInfo."Home Page")
            {
            }
            column(Logo;compInfo.Picture)
            {
            }
            column(CompPostCode;compInfo."Post Code")
            {
            }
            column(seq;seq)
            {
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
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
        if compInfo.Get() then begin
          compInfo.CalcFields(Picture);
          end;
          Clear(seq);
    end;

    var
        compInfo: Record "Company Information";
        seq: Integer;
        datefilter: Text[30];
}

