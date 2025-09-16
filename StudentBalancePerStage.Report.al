#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51202 "Student Balance Per Stage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Balance Per Stage.rdlc';

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Date Filter","Semester Filter","Campus Filter","Code","Intake Filter";
            column(ReportForNavId_3691; 3691)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(BALANCES_AS_AT____Programme_Stages__GETFILTER__Date_Filter__;'BALANCES AS AT '+"ACA-Programme Stages".GetFilter("Date Filter"))
            {
            }
            column(Programme_Stages__GETFILTER__Campus_Filter__;"ACA-Programme Stages".GetFilter("Campus Filter"))
            {
            }
            column(Balance_;'Balance')
            {
            }
            column(Programme_Stages_Description;Description)
            {
            }
            column(Programme_Stages_Code;Code)
            {
            }
            column(GBal;GBal)
            {
            }
            column(Grand_Total_;'Grand Total')
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_Stages_Programme_Code;"Programme Code")
            {
            }
            dataitem(UnknownTable61511;UnknownTable61511)
            {
                DataItemLink = Code=field("Programme Code");
                column(ReportForNavId_1410; 1410)
                {
                }
                column(Programme_Code;Code)
                {
                }
                column(Programme_Description;Description)
                {
                }
                column(ProgBal;ProgBal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                        ProgBal:=0;
                        Prog:="ACA-Programme";
                       // Prog.SETFILTER(Prog."Date Filter",Programme.GETFILTER(Programme."Date Filter"));
                        Prog.CalcFields(Prog."Total Balance");
                        CurrBalance:=Prog."Total Balance";

                         Creg.Reset;
                         Creg.SetFilter(Creg.Semester,"ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Semester Filter"));
                         Creg.SetRange(Creg.Stage,"ACA-Programme Stages".Code);
                         Creg.SetRange(Creg.Programme,"ACA-Programme".Code);
                         Creg.SetRange(Creg.Reversed,false);
                         Creg.SetFilter(Creg.Session,"ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Intake Filter"));
                         if Creg.Find('-') then begin
                         repeat
                         if Cust.Get(Creg."Student No.") then begin
                         Cust.SetFilter(Cust."Date Filter","ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Date Filter"));
                         Cust.CalcFields(Cust.Balance);
                         ProgBal:=ProgBal+Cust.Balance;
                         StageBal:=StageBal+Cust.Balance;
                         GBal:=GBal+Cust.Balance;
                         end;
                         until Creg.Next=0;
                         end;

                        Prog.Reset;
                        Prog:="ACA-Programme";
                        Prog.SetFilter(Prog."Date Filter",PrevDateStr);
                        Prog.CalcFields(Prog."Total Balance");
                        PrevBalance:=Prog."Total Balance";

                        TotalPrev:=TotalPrev+PrevBalance;
                        TotalBal:=TotalBal+CurrBalance;
                        //Programme.GETFILTER(Programme."Opening Date Filter")
                end;

                trigger OnPreDataItem()
                begin
                       "ACA-Programme".SetFilter("ACA-Programme"."Date Filter","ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Date Filter"));
                       "ACA-Programme".SetFilter("ACA-Programme"."Campus Filter","ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Campus Filter"));

                      // CurrBalance:=0;
                     //  EVALUATE(PrevDate,Programme.GETFILTER(Programme."Date Filter"));
                     //  ProgBal:=0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                     /*
                      StageBal:=0;
                     Creg.reset;
                     Creg.setfilter(Creg.Semester,"Programme Stages".getfilter("Programme Stages"."Semester Filter"));
                     Creg.setrange(Creg.Stage,"Programme Stages".Code);
                     if Creg.find('-') then begin
                     repeat
                     if Cust.get(Creg."Student No.") then begin
                     Cust.setfilter(Cust."Date Filter","Programme Stages".getfilter("Programme Stages"."Date Filter"));
                     Cust.calcfields(Cust.Balance);
                     StageBal:=StageBal+Cust.Balance;
                     end;
                     until Creg.next=0;
                     end;
                     */

            end;

            trigger OnPostDataItem()
            begin
                    StageBal:=0;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        TotalBal: Decimal;
        PrevBalance: Decimal;
        CurrBalance: Decimal;
        Prog: Record UnknownRecord61511;
        PrevDate: Date;
        PrevDateStr: Text[30];
        TotalPrev: Decimal;
        Creg: Record UnknownRecord61532;
        Cust: Record Customer;
        StageBal: Decimal;
        ProgBal: Decimal;
        GBal: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

