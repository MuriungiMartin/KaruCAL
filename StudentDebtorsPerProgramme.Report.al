#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51201 "Student Debtors Per Programme"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Debtors Per Programme.rdlc';

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Date Filter","Campus Filter","Code";
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
            column(DEBTORS_AS_AT____Programme_Stages__GETFILTER__Date_Filter__;'DEBTORS AS AT '+"ACA-Programme Stages".GetFilter("Date Filter"))
            {
            }
            column(Programme_Stages__GETFILTER__Campus_Filter__;"ACA-Programme Stages".GetFilter("Campus Filter"))
            {
            }
            column(Programme_Stages__GETFILTER__Date_Filter__;"ACA-Programme Stages".GetFilter("Date Filter"))
            {
            }
            column(PrevDateStr;PrevDateStr)
            {
            }
            column(Programme_Stages_Description;Description)
            {
            }
            column(Programme_Stages_Code;Code)
            {
            }
            column(TotalPrev;TotalPrev)
            {
            }
            column(TotalBal;TotalBal)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
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
                column(PrevBalance;PrevBalance)
                {
                }
                column(CurrBalance;CurrBalance)
                {
                }

                trigger OnAfterGetRecord()
                begin

                        Prog:="ACA-Programme";
                       // Prog.SETFILTER(Prog."Date Filter",Programme.GETFILTER(Programme."Date Filter"));
                        Prog.CalcFields(Prog."Total Balance");
                        CurrBalance:=Prog."Total Balance";

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
                       Evaluate(PrevDate,"ACA-Programme".GetFilter("ACA-Programme"."Date Filter"));
                       PrevDate:=PrevDate-7;
                       PrevDateStr:=Format(PrevDate);
                       "ACA-Programme"."Opening Date Filter":=PrevDate;
                end;
            }

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
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
}

