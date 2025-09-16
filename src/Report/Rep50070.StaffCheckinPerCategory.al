#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50070 "Staff Check-in Per Category"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Check-in Per Category.rdlc';

    dataset
    {
        dataitem("PROC-Store Issue";"PROC-Store Issue")
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
            column(DeptName;"HRM-Staff Categories"."Category Description")
            {
            }
            column(DeptCode;"HRM-Staff Categories"."Category Code")
            {
            }
            dataitem("ACA-Exam Supp. Units";"ACA-Exam Supp. Units")
            {
                DataItemLink = Category=field("Category Code");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(VisitNo;"HRM-Visits Ledger"."Visit No.")
                {
                }
                column(TransDate;"HRM-Visits Ledger"."Transaction Date")
                {
                }
                column(IdNo;"HRM-Visits Ledger"."Staff No.")
                {
                }
                column(FullName;"HRM-Visits Ledger"."Full Name")
                {
                }
                column(Phone;"HRM-Visits Ledger"."Phone No.")
                {
                }
                column(Email;"HRM-Visits Ledger".Email)
                {
                }
                column(Company;"HRM-Visits Ledger".Company)
                {
                }
                column(Dept;"HRM-Visits Ledger"."Office Station/Department")
                {
                }
                column(InBy;"HRM-Visits Ledger"."Signed in by")
                {
                }
                column(TimeIn;"HRM-Visits Ledger"."Time In")
                {
                }
                column(OutBy;"HRM-Visits Ledger"."Signed in by")
                {
                }
                column(TimeOut;"HRM-Visits Ledger"."Time Out")
                {
                }
                column(Comment;"HRM-Visits Ledger".Comment)
                {
                }
                column(CheckedOut;"HRM-Visits Ledger"."Checked Out")
                {
                }
                column(seq;seq)
                {
                }
                column(seq2;seq2)
                {
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

