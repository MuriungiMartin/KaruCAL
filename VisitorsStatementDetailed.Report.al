#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50053 "Visitors Statement Detailed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Visitors Statement Detailed.rdlc';

    dataset
    {
        dataitem("Automated Notification Setup";"Automated Notification Setup")
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000024; 1000000024)
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
            column(VisitorNames;"Visitor Card"."Full Names")
            {
            }
            column(VisitorID;"Visitor Card"."ID No.")
            {
            }
            dataitem("General Journal Archive";"General Journal Archive")
            {
                DataItemLink = "ID No."=field("ID No.");
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
                column(seq;seq)
                {
                }
                column(seq2;seq2)
                {
                }
                dataitem("ACA-2ndSuppExam. Co. Reg.";"ACA-2ndSuppExam. Co. Reg.")
                {
                    DataItemLink = "Visitor ID"=field("ID No.");
                    column(ReportForNavId_1000000028; 1000000028)
                    {
                    }
                    column(VisitNo2;"Visitors Ledger"."Visit No.")
                    {
                    }
                    column(ItemDesc;"Visitor Personal Items"."Item Description")
                    {
                    }
                    column(SerialNo;"Visitor Personal Items"."Serial No.")
                    {
                    }
                    column(Cleared;"Visitor Personal Items".Cleared)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    seq:=seq+1;
                    seq2:=seq2+1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                seq:=0;
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
          Clear(seq2);
    end;

    var
        compInfo: Record "Company Information";
        seq: Integer;
        datefilter: Text[30];
        seq2: Integer;
}

