#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51746 "P9 Report (Final)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/P9 Report (Final).rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("No.") order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_8631; 8631)
            {
            }
            column(EmployerPIN;controlinfo."VAT Registration No.")
            {
            }
            column(Fname;"First Name")
            {
            }
            column(MName;"Middle Name"+' '+"Last Name")
            {
            }
            column(Emp_No;"No.")
            {
            }
            column(Pin_No;"PIN Number")
            {
            }
            column(Tac_Charged;"Total Tax Charged")
            {
            }
            column(TotalL;TotalL)
            {
            }
            column(TotaA;TotaA)
            {
            }
            column(TotalB;TotalB)
            {
            }
            column(totalD;totalD)
            {
            }
            column(totalC;totalC)
            {
            }
            column(TotalF;TotalF)
            {
            }
            column(TotalE3;TotalE3)
            {
            }
            column(TotalE2;TotalE2)
            {
            }
            column(TotalE1;TotalE1)
            {
            }
            column(TotalK;TotalK)
            {
            }
            column(TotalJ;TotalJ)
            {
            }
            column(TotalH;TotalH)
            {
            }
            column(TotalG;TotalG)
            {
            }
            column(Comp_Name;controlinfo.Name)
            {
            }
            dataitem(UnknownTable61093;UnknownTable61093)
            {
                DataItemLink = "Employee Code"=field("No.");
                DataItemTableView = sorting("Employee Code","Payroll Period") order(ascending);
                RequestFilterFields = "Period Year","Employee Code";
                column(ReportForNavId_7242; 7242)
                {
                }
                column(Month;"PRL-Employee P9 Info".GetFilter("PRL-Employee P9 Info"."Period Year"))
                {
                }
                column(SelectedPeriod;"PRL-Employee P9 Info".GetFilter("PRL-Employee P9 Info"."Period Year"))
                {
                }
                column(PeriodMonth;Format("PRL-Employee P9 Info"."Payroll Period",0,'<Month Text>'))
                {
                }
                column(B_Pay;"Basic Pay")
                {
                }
                column(Benefits;"Gross Pay"-"Basic Pay")
                {
                }
                column(Value_Of_Quoters;"Value Of Quarters")
                {
                }
                column(Gross;"Gross Pay")
                {
                }
                column(Owner_Occupier;"Owner Occupier Interest")
                {
                }
                column(thirty_Perc_Of_BPay;"Basic Pay"*0.3)
                {
                }
                column(Actual;"PRL-Employee P9 Info"."External Pension"+"PRL-Employee P9 Info".NSSF+"PRL-Employee P9 Info".Pension)
                {
                }
                column(fixedDefContri;fixedDefContri)
                {
                }
                column(Gross_Pay__ColG;"Gross Pay"-("PRL-Employee P9 Info"."External Pension"+"PRL-Employee P9 Info".NSSF+"PRL-Employee P9 Info".Pension))
                {
                }
                column(TaxCharged;"Tax Charged")
                {
                }
                column(Tax_Relief;"Tax Relief")
                {
                }
                column(Ins_Relief;"Insurance Relief"+"Tax Relief")
                {
                }
                column(PAYE1;PAYE)
                {
                }
                column(ColG;ColG)
                {
                }
                column(Emp_Code;"Employee Code")
                {
                }
                column(PayPeriod;"Payroll Period")
                {
                }
                column(TotalAHL;TotalAHL)
                {
                }
                column(TotalSHIF;TotalSHIF)
                {
                }

                trigger OnAfterGetRecord()
                var
                    prPayrollProcess: Codeunit "BankAcc.Recon. PostNew";
                begin
                    //
                    "PRL-Employee P9 Info".CalcFields("PRL-Employee P9 Info".AHL,"PRL-Employee P9 Info".SHIF);
                    TotalAHL:="PRL-Employee P9 Info".AHL;
                    TotalSHIF:="PRL-Employee P9 Info".SHIF;
                    if ("Defined Contribution"+NSSF)>20000 then
                     begin
                      ColG:=20000+"Owner Occupier Interest";
                      TotalG:=TotalG+ColG;
                     end;

                    fixedDefContri:=20000;
                end;

                trigger OnPreDataItem()
                begin
                    //"PRL-Employee P9 Info".SETFILTER("PRL-Employee P9 Info"."Period Year",FORMAT(SelectedPeriod));
                    if "PRL-Employee P9 Info".GetFilter("PRL-Employee P9 Info"."Period Year")='' then Error('ERROR:\Specify the year in the Period Year Filter!');
                    Clear(yearFilters);
                    if Evaluate(yearFilters,"PRL-Employee P9 Info".GetFilter("PRL-Employee P9 Info"."Period Year")) then;
                    PerionTrans.Reset;
                    PerionTrans.SetRange(PerionTrans."Employee Code","HRM-Employee (D)"."No.") ;
                    PerionTrans.SetRange(PerionTrans."Period Year",yearFilters);
                    PerionTrans.SetRange(PerionTrans."Transaction Code",'PNSR');
                    if PerionTrans.Find('-') then begin
                    repeat
                    P9.Reset;
                    P9.SetRange(P9."Employee Code","HRM-Employee (D)"."No.");
                    P9.SetRange(P9."Payroll Period",PerionTrans."Payroll Period");
                    if P9.Find('-') then begin
                      if P9."Tax Relief"=0 then P9."Tax Relief":=2400;
                      P9.Modify;
                    P9.Pension:=PerionTrans.Amount;
                    P9.Modify;
                    end;
                    until PerionTrans.Next=0;
                    end;


                    P9.Reset;
                    P9.SetRange(P9."Employee Code","HRM-Employee (D)"."No.");
                    P9.SetRange(P9."Period Year",yearFilters);
                    if P9.Find('-') then
                     begin
                      repeat
                       TotaA:=TotaA+P9."Gross Pay";
                       TotalB:=TotalB+P9.Benefits;
                       totalC:=totalC+P9."Value Of Quarters";
                       totalD:=totalD+P9."Gross Pay";
                       TotalE1:=TotalE1+(P9."Gross Pay"*0.3);
                       TotalE2:=TotalE2+(P9.NSSF+P9.Pension);
                       TotalE3:=TotalE3+20000;
                       TotalF:=TotalF+P9."Owner Occupier Interest";
                       TotalG:=TotalG+(P9.NSSF+P9.Pension+P9."Owner Occupier Interest");
                       if P9.NSSF<20000 then begin
                        //TotalG:=TotalG+P9.NSSF;
                        TotalH:=TotalH+(P9."Gross Pay"-(P9.NSSF+P9.Pension+P9."Owner Occupier Interest"));
                       end else begin
                         //TotalG:=TotalG+20000;
                         TotalH:=TotalH+(P9."Gross Pay"-(P9.NSSF+P9.Pension+P9."Owner Occupier Interest"));
                       end;
                       //TotalJ:=TotalJ+(P9."Tax Charged"+(P9."Tax Relief"+P9."Insurance Relief"));
                       TotalJ:=TotalJ+(P9."Tax Charged");
                       TotalK:=TotalK+(P9."Tax Relief"+P9."Insurance Relief");
                       TotalL:=TotalL+P9.PAYE;
                      until P9.Next=0;
                     end;

                    "Total Tax Charged":=TotalH;
                end;
            }

            trigger OnAfterGetRecord()
            begin




                TotaA:=0;
                TotalB:=0;
                totalC:=0;
                totalD:=0;
                TotalE1:=0;
                TotalE2:=0;
                TotalE3:=0;
                TotalF:=0;
                TotalG:=0;
                TotalH:=0;
                TotalJ:=0;
                TotalK:=0;
                TotalL:=0;
                TotalAHL:=0;
                TotalSHIF:=0;
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
            Clear(fixedDefContri);
    end;

    trigger OnPreReport()
    begin

        //IF SelectedPeriod=0 THEN BEGIN
        // ERROR('Specify The Year');
        //END;
         controlinfo.Get();

        // fixedDefContri:=20000;
    end;

    var
        objEmp: Record UnknownRecord61619;
        strEmpName: Text[250];
        strPin: Text[30];
        EmployerPIN: Text[30];
        controlinfo: Record "Company Information";
        fixedDefContri: Decimal;
        "Total Tax Charged": Decimal;
        "Total PAYE": Decimal;
        TotaA: Decimal;
        TotalB: Decimal;
        totalC: Decimal;
        totalD: Decimal;
        TotalE1: Decimal;
        TotalE2: Decimal;
        TotalE3: Decimal;
        TotalF: Decimal;
        TotalG: Decimal;
        TotalH: Decimal;
        TotalI: Decimal;
        TotalJ: Decimal;
        TotalK: Decimal;
        TotalL: Decimal;
        P9: Record UnknownRecord61093;
        ColG: Decimal;
        PerionTrans: Record UnknownRecord61092;
        yearFilters: Integer;
        TotalAHL: Decimal;
        TotalSHIF: Decimal;
}

