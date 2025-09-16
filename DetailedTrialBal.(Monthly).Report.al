#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77702 "Detailed Trial Bal. (Monthly)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Trial Bal. (Monthly).rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.") order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress1;CompanyInformation.Address)
            {
            }
            column(CompAddress2;CompanyInformation."Address 2")
            {
            }
            column(CompCity;CompanyInformation.City)
            {
            }
            column(CompPhone;CompanyInformation."Phone No.")
            {
            }
            column(CompPhone2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompMail;CompanyInformation."E-Mail")
            {
            }
            column(CompHomePage;CompanyInformation."Home Page")
            {
            }
            column(AccNo;"G/L Account"."No.")
            {
            }
            column(AccName;"G/L Account".Name)
            {
            }
            column(BeginingTotal;BeginingTotal)
            {
            }
            column(EndingTotal;EndingTotal)
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            dataitem("G/L Entry";"G/L Entry")
            {
                DataItemLink = "G/L Account No."=field("No.");
                DataItemTableView = sorting("G/L Account No.","Posting Date") order(ascending);
                RequestFilterFields = "G/L Account No.";
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(PDate;"G/L Entry"."Posting Date")
                {
                }
                column(DocNo;"G/L Entry"."Document No.")
                {
                }
                column(Descr;"G/L Entry".Description)
                {
                }
                column(Amount;"G/L Entry".Amount)
                {
                }
                column(DebitAmount;"G/L Entry"."Debit Amount")
                {
                }
                column(CreditAmount;"G/L Entry"."Credit Amount")
                {
                }
                column(ExternalDocNo;"G/L Entry"."External Document No.")
                {
                }
                column(RunningTotal;RunningTotal)
                {
                }
                column(MonthDesc;MonthDesc)
                {
                }
                column(CountedMonths;CountedMonths)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RunningTotal:=RunningTotal+"G/L Entry".Amount;
                    Clear(MonthDesc);
                    Clear(CountedMonths);
                    if Date2dmy("G/L Entry"."Posting Date",2)=1 then begin
                       MonthDesc:='JANUARY';
                      CountedMonths:=7;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=2 then begin
                       MonthDesc:='FEBRUARY';
                      CountedMonths:=8;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=3 then begin
                       MonthDesc:='MARCH';
                      CountedMonths:=9;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=4 then begin
                       MonthDesc:='APRIL';
                      CountedMonths:=10;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=5 then begin
                       MonthDesc:='MAY';
                      CountedMonths:=11;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=6 then begin
                       MonthDesc:='JUNE';
                      CountedMonths:=12;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=7 then begin
                       MonthDesc:='JULY';
                      CountedMonths:=1;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=8 then begin
                       MonthDesc:='AUGUST';
                      CountedMonths:=2;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=9 then begin
                       MonthDesc:='SEPTEMBER';
                      CountedMonths:=3;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=10 then begin
                       MonthDesc:='OCTOBER';
                      CountedMonths:=4;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=11 then begin
                       MonthDesc:='NOVEMBER';
                      CountedMonths:=5;
                      end;
                    if Date2dmy("G/L Entry"."Posting Date",2)=12 then begin
                       MonthDesc:='DECEMBER';
                      CountedMonths:=6;
                      end;
                end;

                trigger OnPreDataItem()
                begin
                    "G/L Entry".SetFilter("G/L Entry"."Posting Date",'%1..%2',StartDate,EndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(BeginingTotal);
                Clear(EndingTotal);
                Clear(RunningTotal);
                GLAccount.Reset;
                GLAccount.SetFilter("Date Filter",'..%1',CalcDate('-1D',StartDate));
                GLAccount.SetRange("No.","G/L Account"."No.");
                if GLAccount.Find('-') then begin
                  if GLAccount.CalcFields(Balance) then begin
                  BeginingTotal:=GLAccount.Balance;
                  RunningTotal:=GLAccount.Balance;
                  end;
                  end;

                GLAccount.Reset;
                GLAccount.SetFilter("Date Filter",'..%1',CalcDate('-1D',StartDate));
                GLAccount.SetRange("No.","G/L Account"."No.");
                if GLAccount.Find('-') then begin
                  if GLAccount.CalcFields(Balance) then
                  EndingTotal:=GLAccount.Balance;
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDates;StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                }
                field(Enddates;EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          end;
    end;

    var
        BeginingTotal: Decimal;
        EndingTotal: Decimal;
        RunningTotal: Decimal;
        MonthDesc: Code[20];
        StartDate: Date;
        EndDate: Date;
        CompanyInformation: Record "Company Information";
        CountedMonths: Integer;
        GLAccount: Record "G/L Account";
}

