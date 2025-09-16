#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69000 "Post Payroll Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable69000;UnknownTable69000)
        {
            DataItemTableView = where("Employee Code"=filter(<>""));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            var
                empded: Record UnknownRecord61094;
                empCode: Code[20];
            begin
                Clear(empCode);
                if StrLen("prEmployer Deductions"."Employee Code")= 2 then empCode:='00'+"prEmployer Deductions"."Employee Code"
                else if StrLen("prEmployer Deductions"."Employee Code")= 3 then empCode:='0'+"prEmployer Deductions"."Employee Code"
                else  empCode:="prEmployer Deductions"."Employee Code";


                // Update System Table Data Employer Deductions
                empded.Reset;
                empded.SetRange(empded."Employee Code",empCode);
                empded.SetRange(empded."Transaction Code","prEmployer Deductions"."Transaction Code");
                empded.SetRange(empded."Period Month","prEmployer Deductions"."Period Month");
                empded.SetRange(empded."Period Year","prEmployer Deductions"."Period Year");
                if not empded.Find('-') then begin
                    if emp.Get(empCode) then begin
                        empded.Init;
                        empded."Employee Code":=empCode;
                empded."Transaction Code":="prEmployer Deductions"."Transaction Code";
                empded."Period Month":="prEmployer Deductions"."Period Month";
                empded."Period Year":="prEmployer Deductions"."Period Year";
                empded."Payroll Period":="prEmployer Deductions"."Payroll Period";
                empded.Amount:="prEmployer Deductions".Amount;
                empded."Payroll Code":="prEmployer Deductions"."Payroll Code";
                        empded.Insert;
                      end;
                  end;
            end;
        }
        dataitem(UnknownTable69001;UnknownTable69001)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            var
                p9info: Record UnknownRecord61093;
                empcode: Code[20];
            begin
                if StrLen("prEmployee P9 Info"."Employee Code")=2 then empcode:='00'+"prEmployee P9 Info"."Employee Code"
                else if StrLen("prEmployee P9 Info"."Employee Code")=3 then empcode:='0'+"prEmployee P9 Info"."Employee Code"
                else empcode:="prEmployee P9 Info"."Employee Code";

                p9info.Reset;
                p9info.SetRange(p9info."Employee Code",empcode);
                p9info.SetRange(p9info."Payroll Period","prEmployee P9 Info"."Payroll Period");
                if not p9info.Find('-') then begin
                  if emp.Get(empcode) then begin
                   p9info.Init;
                   p9info."Employee Code":=empcode;
                   p9info."Payroll Period":="prEmployee P9 Info"."Payroll Period";
                   p9info."Basic Pay":="prEmployee P9 Info"."Basic Pay";
                   p9info.Allowances:="prEmployee P9 Info".Allowances;
                   p9info.Benefits:="prEmployee P9 Info".Benefits;
                   p9info."Value Of Quarters":="prEmployee P9 Info"."Value Of Quarters";
                   p9info."Defined Contribution":="prEmployee P9 Info"."Defined Contribution";
                   p9info."Owner Occupier Interest":="prEmployee P9 Info"."Owner Occupier Interest";
                   p9info."Gross Pay":="prEmployee P9 Info"."Gross Pay";
                   p9info."Taxable Pay":="prEmployee P9 Info"."Taxable Pay";
                   p9info."Tax Charged":="prEmployee P9 Info"."Tax Charged";
                   p9info."Insurance Relief":="prEmployee P9 Info"."Insurance Relief";
                   p9info."Tax Relief":="prEmployee P9 Info"."Tax Relief";
                   p9info.PAYE:="prEmployee P9 Info".PAYE;
                   p9info.NSSF:="prEmployee P9 Info".NSSF;
                   p9info.NHIF:="prEmployee P9 Info".NHIF;
                   p9info.Deductions:="prEmployee P9 Info".Deductions;
                   p9info."Net Pay":="prEmployee P9 Info"."Net Pay";
                   p9info."Period Month":="prEmployee P9 Info"."Period Month";
                   p9info."Period Year":="prEmployee P9 Info"."Period Year";
                   p9info.Pension:="prEmployee P9 Info".Pension;
                   p9info.HELB:="prEmployee P9 Info".HELB;
                   p9info."Payroll Code":='';
                   p9info.Insert;
                   end;
                end;
            end;
        }
        dataitem(UnknownTable69002;UnknownTable69002)
        {
            column(ReportForNavId_1000000002; 1000000002)
            {
            }

            trigger OnAfterGetRecord()
            var
                unusedRelief: Record UnknownRecord61090;
                empcode: Code[20];
            begin
                Clear(empcode);
                if StrLen("UnUsed Relief"."Emp. No")=2 then empcode:='00'+"UnUsed Relief"."Emp. No"
                else if StrLen("UnUsed Relief"."Emp. No")=3 then empcode:='0'+"UnUsed Relief"."Emp. No"
                else empcode:="UnUsed Relief"."Emp. No";

                unusedRelief.Reset;
                unusedRelief.SetRange(unusedRelief."Employee Code",empcode);
                unusedRelief.SetRange(unusedRelief."Period Month","UnUsed Relief"."Period Month");
                unusedRelief.SetRange(unusedRelief."Period Year","UnUsed Relief"."Period Year");
                if not unusedRelief.Find('-') then begin
                if emp.Get(empcode) then begin
                  unusedRelief.Init;
                  unusedRelief."Employee Code":=empcode;
                  unusedRelief."Period Month":="UnUsed Relief"."Period Month";
                  unusedRelief."Period Year":="UnUsed Relief"."Period Year";
                  unusedRelief."Unused Relief":="UnUsed Relief".Amount;
                  unusedRelief.Insert;
                  end;
                end;
            end;
        }
        dataitem(UnknownTable69003;UnknownTable69003)
        {
            column(ReportForNavId_1000000003; 1000000003)
            {
            }

            trigger OnAfterGetRecord()
            var
                empcode: Code[20];
                periodTrans: Record UnknownRecord61092;
                salCard: Record UnknownRecord61105;
            begin
                Clear(empcode);
                if StrLen("prPeriod Transactions"."Employee No")=2 then empcode:='00'+"prPeriod Transactions"."Employee No"
                else  if StrLen("prPeriod Transactions"."Employee No")=3 then empcode:='0'+"prPeriod Transactions"."Employee No"
                else empcode:="prPeriod Transactions"."Employee No";

                periodTrans.Reset;
                periodTrans.SetRange(periodTrans."Employee Code",empcode);
                periodTrans.SetRange(periodTrans."Transaction Code","prPeriod Transactions"."Transaction Code");
                periodTrans.SetRange(periodTrans."Period Month","prPeriod Transactions"."Period Month");
                periodTrans.SetRange(periodTrans."Period Year","prPeriod Transactions"."Period Year");
                if not periodTrans.Find('-') then begin
                  if emp.Get(empcode) then begin
                    periodTrans.Init;
                    periodTrans."Employee Code":=empcode;
                    periodTrans."Transaction Code":="prPeriod Transactions"."Transaction Code";
                    periodTrans."Period Month":="prPeriod Transactions"."Period Month";
                    periodTrans."Period Year" :="prPeriod Transactions"."Period Year";
                    periodTrans.Membership:="prPeriod Transactions".Membership;
                    periodTrans."Reference No":="prPeriod Transactions"."Reference No";
                    periodTrans."Group Text":="prPeriod Transactions"."Group Text";
                    periodTrans."Transaction Name":="prPeriod Transactions"."Transaction Name";
                    periodTrans.Amount:="prPeriod Transactions".Amount;
                    periodTrans.Balance:="prPeriod Transactions".Balance;
                    periodTrans."Original Amount":="prPeriod Transactions"."Original Amount";
                    periodTrans."Group Order":="prPeriod Transactions"."Group Order";
                    periodTrans."Sub Group Order":="prPeriod Transactions"."Sub Group Order";
                    periodTrans."Payroll Period":="prPeriod Transactions"."Payroll Period";
                    periodTrans."Department Code":="prPeriod Transactions"."Department Code";
                    periodTrans.Lumpsumitems:="prPeriod Transactions".Lumpsumitems;
                    periodTrans.TravelAllowance:="prPeriod Transactions".TravelAllowance;
                    periodTrans."GL Account":="prPeriod Transactions"."GL Account";
                    periodTrans."Company Deduction":="prPeriod Transactions"."Company Deduction";
                    periodTrans."Emp Amount":="prPeriod Transactions"."Emp Amount";
                    periodTrans."Emp Balance":="prPeriod Transactions"."Emp Balance";
                    periodTrans."Journal Account Code":="prPeriod Transactions"."Journal Account Code";
                    //periodTrans."Journal Account Type":="prPeriod Transactions"."Journal Account Type";
                    periodTrans."Post As":="prPeriod Transactions"."Post As";
                    periodTrans."Loan Number":="prPeriod Transactions"."Loan Number";
                    //periodTrans."coop parameters":="prPeriod Transactions"."coop parameters";
                    periodTrans."Payroll Code":="prPeriod Transactions"."Payroll Code";
                   // periodTrans."Payment Mode":="prPeriod Transactions"."Payment Mode";
                    periodTrans.Insert;

                   if "prPeriod Transactions"."Transaction Code"='BPAY' then begin // Insert Basic Pay in the Salary Card Table
                    salCard.Reset;
                    salCard.SetRange(salCard."Employee Code",empcode);
                    salCard.SetRange(salCard."Period Month","prPeriod Transactions"."Period Month");
                    salCard.SetRange(salCard."Period Year","prPeriod Transactions"."Period Year");
                    if salCard.Find('-') then begin
                salCard."Basic Pay":="prPeriod Transactions".Amount;
                //salCard."Payment Mode":="prPeriod Transactions"."Payment Mode";
                salCard.Modify;
                      end else begin
                        salCard.Init;
                        salCard."Employee Code":=empcode;
                salCard."Payroll Period":="prPeriod Transactions"."Payroll Period";
                salCard."Basic Pay":="prPeriod Transactions".Amount;
                //salCard."Payment Mode":="prPeriod Transactions"."Payment Mode";
                salCard."Pays NSSF":=true;
                salCard."Pays NHIF":=true;
                salCard."Pays PAYE":=true;
                salCard."Period Month":="prPeriod Transactions"."Period Month";
                salCard."Period Year":="prPeriod Transactions"."Period Year";
                        salCard.Insert;
                        end;
                        end;
                  end;
                end;
            end;
        }
        dataitem(UnknownTable69004;UnknownTable69004)
        {
            column(ReportForNavId_1000000004; 1000000004)
            {
            }

            trigger OnAfterGetRecord()
            var
                empcode: Code[20];
                EmpTrans: Record UnknownRecord61091;
            begin
                Clear(empcode);
                if StrLen("pr Employee Transactions"."Employee Code")=2 then empcode:='00'+"pr Employee Transactions"."Employee Code"
                else if  StrLen("pr Employee Transactions"."Employee Code")=3 then empcode:='0'+"pr Employee Transactions"."Employee Code"
                else empcode:="pr Employee Transactions"."Employee Code";


                EmpTrans.Reset;
                EmpTrans.SetRange(EmpTrans."Employee Code",empcode);
                EmpTrans.SetRange(EmpTrans."Transaction Code","pr Employee Transactions"."Transaction Code");
                EmpTrans.SetRange(EmpTrans."Period Month","pr Employee Transactions"."Period Month");
                EmpTrans.SetRange(EmpTrans."Period Year","pr Employee Transactions"."Period Year");
                if not EmpTrans.Find('-') then begin
                  if emp.Get(empcode) then
                    EmpTrans.Init;
                    EmpTrans."Employee Code":=empcode;
                    EmpTrans."Transaction Code":="pr Employee Transactions"."Transaction Code";
                EmpTrans."Period Month":="pr Employee Transactions"."Period Month";
                EmpTrans."Period Year":="pr Employee Transactions"."Period Year";
                //IF "pr Employee Transactions"."Payroll Period"=''
                EmpTrans."Payroll Period":="pr Employee Transactions"."Payroll Period";
                EmpTrans."Reference No":="pr Employee Transactions"."Reference No";
                EmpTrans."Transaction Name":="pr Employee Transactions"."Transaction Name";
                EmpTrans.Amount:="pr Employee Transactions".Amount;
                EmpTrans.Balance:="pr Employee Transactions".Balance;
                EmpTrans."Original Amount":="pr Employee Transactions"."Original Amount";
                EmpTrans."#of Repayments":="pr Employee Transactions"."#of Repayments";
                EmpTrans.Membership:="pr Employee Transactions".Membership;
                EmpTrans.integera:="pr Employee Transactions".integera;
                EmpTrans."Employer Amount":="pr Employee Transactions"."Employer Amount";
                EmpTrans."Employer Balance":="pr Employee Transactions"."Employer Balance";
                EmpTrans."Stop for Next Period":="pr Employee Transactions"."Stop for Next Period";
                EmpTrans."Start Date":="pr Employee Transactions"."Start Date";
                EmpTrans."End Date":="pr Employee Transactions"."End Date";
                EmpTrans."Payroll Code":="pr Employee Transactions"."Payroll Code";
                EmpTrans."Transaction Type":="pr Employee Transactions"."Transaction Type";
                EmpTrans.Insert;
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

    var
        emp: Record UnknownRecord61118;

    local procedure updateEmpNo(var empNo: Code[20]) employeeNo: Code[20]
    begin
        /*IF STRLEN(empNo)=2 THEN BEGIN
          employeeNo:='00'+empNo;
          END ELSE IF STRLEN(empNo)=3 THEN BEGIN
            employeeNo:='0'+empNo;
          END ELSE employeeNo:=empNo; */

    end;
}

