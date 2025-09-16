#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70040 "Part-Time P9 Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Part-Time P9 Report.rdlc';

    dataset
    {
        dataitem(Vendors4P9Report;Vendor)
        {
            DataItemTableView = sorting("No.") order(ascending);
            column(ReportForNavId_8631; 8631)
            {
            }
            column(EmployerPIN;controlinfo."VAT Registration No.")
            {
            }
            column(Fname;Vendors4P9Report.Name)
            {
            }
            column(MName;'')
            {
            }
            column(Emp_No;Vendors4P9Report."No.")
            {
            }
            column(Pin_No;Vendors4P9Report."PIN No.")
            {
            }
            column(Comp_Name;controlinfo.Name)
            {
            }
            dataitem(FinPayLines;UnknownTable61705)
            {
                DataItemLink = "Account No."=field("No.");
                DataItemTableView = where("PV Category"=filter("Part-time Pay"));
                RequestFilterFields = "Date Posted";
                column(ReportForNavId_7242; 7242)
                {
                }
                column(Month;Format(YearSelection))
                {
                }
                column(SelectedPeriod;Format(YearSelection)+', '+Format(FinPayLines."Date Posted",0,'<Month Text>'))
                {
                }
                column(PeriodMonth;Format(FinPayLines."Date Posted",0,'<Month Text>'))
                {
                }
                column(B_Pay;FinPayLines.Amount)
                {
                }
                column(Benefits;0)
                {
                }
                column(Value_Of_Quoters;0)
                {
                }
                column(Gross;FinPayLines.Amount)
                {
                }
                column(Owner_Occupier;0)
                {
                }
                column(thirty_Perc_Of_BPay;FinPayLines.Amount*0.3)
                {
                }
                column(Actual;0)
                {
                }
                column(fixedDefContri;0)
                {
                }
                column(Gross_Pay__ColG;FinPayLines.Amount)
                {
                }
                column(TaxCharged;FinPayLines.Amount*0.3)
                {
                }
                column(Tax_Relief;0)
                {
                }
                column(Ins_Relief;0)
                {
                }
                column(PAYE1;FinPayLines.Amount*0.3)
                {
                }
                column(ColG;ColG)
                {
                }
                column(Emp_Code;Vendors4P9Report."No.")
                {
                }
                column(PayPeriod;Format(YearSelection)+', '+Format(FinPayLines."Date Posted",0,'<Month Text>'))
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
                column(PinNumber;objEmp."PIN Number")
                {
                }

                trigger OnAfterGetRecord()
                var
                    prPayrollProcess: Codeunit "BankAcc.Recon. PostNew";
                begin
                    FinPayLines.CalcFields("Date Posted");
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
                      ColG:=0;
                      TotalG:=TotalG+ColG;

                    fixedDefContri:=0;

                    ///////////////////////////////////////////////////////////////
                       TotaA:=FinPayLines.Amount;
                       TotalB:=0;
                       totalC:=0;
                       totalD:=FinPayLines.Amount;
                       TotalE1:=(FinPayLines.Amount*0.3);
                       TotalE2:=0;
                       TotalE3:=0;
                       TotalF:=0;
                       TotalG:=0;
                    // // // //   IF P9.NSSF<20000 THEN BEGIN
                    // // // //    //TotalG:=TotalG+P9.NSSF;
                    // // // //    TotalH:=TotalH+(P9."Gross Pay"-(P9.NSSF+P9.Pension+P9."Owner Occupier Interest"));
                    // // // //   END ELSE BEGIN
                    // // // //     //TotalG:=TotalG+20000;
                    // // // //     TotalH:=TotalH+(P9."Gross Pay"-(P9.NSSF+P9.Pension+P9."Owner Occupier Interest"));
                    // // // //   END;
                       //TotalJ:=TotalJ+(P9."Tax Charged"+(P9."Tax Relief"+P9."Insurance Relief"));
                       TotalJ:=FinPayLines.Amount*0.3;//TotalJ+(P9."Tax Charged");
                       TotalK:=0;//TotalK+(P9."Tax Relief"+P9."Insurance Relief");
                       TotalL:=FinPayLines.Amount*0.3;
                    //////////////////////////////////////////////////////////////////////
                    "Total Tax Charged":=TotalL;
                end;

                trigger OnPreDataItem()
                begin

                    //FinPayLines.SETFILTER("Date Posted",'%1..%2',PerStart,PerEnd);
                    // // // // // // // // // // //
                    // // // // // // // // // // //
                    // // // // // // // // // // // P9.RESET;
                    // // // // // // // // // // // P9.SETRANGE(P9."Employee Code","HRM-Employee (D)"."No.");
                    // // // // // // // // // // // P9.SETRANGE(P9."Period Year",yearFilters);
                    // // // // // // // // // // // IF P9.FIND('-') THEN
                    // // // // // // // // // // // BEGIN
                    // // // // // // // // // // //  REPEAT
                    // // // // // // // // // // //   TotaA:=TotaA+P9."Gross Pay";
                    // // // // // // // // // // //   TotalB:=TotalB+P9.Benefits;
                    // // // // // // // // // // //   totalC:=totalC+P9."Value Of Quarters";
                    // // // // // // // // // // //   totalD:=totalD+P9."Gross Pay";
                    // // // // // // // // // // //   TotalE1:=TotalE1+(P9."Gross Pay"*0.3);
                    // // // // // // // // // // //   TotalE2:=TotalE2+(P9.NSSF+P9.Pension);
                    // // // // // // // // // // //   TotalE3:=TotalE3+20000;
                    // // // // // // // // // // //   TotalF:=TotalF+P9."Owner Occupier Interest";
                    // // // // // // // // // // //   TotalG:=TotalG+(P9.NSSF+P9.Pension+P9."Owner Occupier Interest");
                    // // // // // // // // // // //   IF P9.NSSF<20000 THEN BEGIN
                    // // // // // // // // // // //    //TotalG:=TotalG+P9.NSSF;
                    // // // // // // // // // // //    TotalH:=TotalH+(P9."Gross Pay"-(P9.NSSF+P9.Pension+P9."Owner Occupier Interest"));
                    // // // // // // // // // // //   END ELSE BEGIN
                    // // // // // // // // // // //     //TotalG:=TotalG+20000;
                    // // // // // // // // // // //     TotalH:=TotalH+(P9."Gross Pay"-(P9.NSSF+P9.Pension+P9."Owner Occupier Interest"));
                    // // // // // // // // // // //   END;
                    // // // // // // // // // // //   //TotalJ:=TotalJ+(P9."Tax Charged"+(P9."Tax Relief"+P9."Insurance Relief"));
                    // // // // // // // // // // //   TotalJ:=TotalJ+(P9."Tax Charged");
                    // // // // // // // // // // //   TotalK:=TotalK+(P9."Tax Relief"+P9."Insurance Relief");
                    // // // // // // // // // // //   TotalL:=TotalL+P9.PAYE;
                    // // // // // // // // // // //  UNTIL P9.NEXT=0;
                    // // // // // // // // // // // END;
                    // // // // // // // // // // //
                    // // // // // // // // // // // "Total Tax Charged":=TotalH;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Clear(objEmp);
                objEmp.Reset;
                objEmp.SetRange("No.",Vendors4P9Report."No.");
                if objEmp.Find('-') then;
            end;

            trigger OnPreDataItem()
            begin
                // // CLEAR(DatesCount);
                // // CLEAR(yearFilters);
                // // IF EVALUATE(yearFilters,FORMAT(YearSelection)) THEN;
                // // CLEAR(DatesCount);
                // // DatesCount.RESET;
                // // DatesCount.SETRANGE("Period Type",DatesCount."Period Type"::Year);
                // // DatesCount.SETRANGE("Period Name",FORMAT(YearSelection));
                // // IF  DatesCount.FIND('-') THEN;
                // // CLEAR(PerStart);
                // // CLEAR(PerEnd);
                // // PerStart := DatesCount."Period Start";
                // // CLEAR(DatesCount);
                // // DatesCount.RESET;
                // // DatesCount.SETRANGE("Period Type",DatesCount."Period Type"::Year);
                // // DatesCount.SETRANGE("Period Name",FORMAT(YearSelection));
                // // IF  DatesCount.FIND('+') THEN;
                // // PerEnd := DatesCount."Period Start";
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
         controlinfo.Get();
         if FinPayLines.GetFilter("Date Posted") = '' then Error('Specify date filters');
        //IF PerStart = 0D THEN ERROR('Specify Period Start');
        //IF PerEnd = 0D THEN ERROR('Specify Period Start');
    end;

    var
        objEmp: Record UnknownRecord61188;
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
        YearSelection: Option " ","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030";
        DatesCount: Record Date;
}

