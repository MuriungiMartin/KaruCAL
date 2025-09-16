#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68084 "PRL-Salary Arrears (B)"
{
    PageType = Card;
    SourceTable = UnknownTable61118;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("""First Name""+' '+""Middle Name""+' '+""Last Name""";"First Name"+' '+"Middle Name"+' '+"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(StartDate;StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
                }
                field(EndDate;EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
                }
                field(ProcessAll;ProcessAll)
                {
                    ApplicationArea = Basic;
                    Caption = 'All Employees';
                }
            }
            part(Control1102756010;"PRL-Salary Arrears (C)")
            {
                SubPageLink = "Employee Code"=field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Process Arrears")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Arrears';

                    trigger OnAction()
                    begin
                        //Get the Salary Arrears code
                        TransCode.SetRange(TransCode."Special Transactions",6);
                        if TransCode.Find('-') then
                           strTransCode:=TransCode."Transaction Code";

                        //Get the open/current period
                        PayPeriod.SetRange(PayPeriod.Closed,false);
                        if PayPeriod.Find('-') then begin
                           PeriodMonth:=PayPeriod."Period Month";
                           PeriodYear:=PayPeriod."Period Year";
                        end;

                        if ProcessAll then begin
                         HrEmployee.Reset;
                         HrEmployee.SetRange(HrEmployee.Status,HrEmployee.Status::Normal);
                         if HrEmployee.Find('-') then begin
                           repeat
                              //Get the staff current salary
                              if SalCard.Get(HrEmployee."No.") then begin
                                 CurrBasic:=SalCard."Basic Pay";
                              end;
                            objOcx.fnSalaryArrears(HrEmployee."No.",strTransCode,CurrBasic,StartDate,EndDate,PayPeriod."Date Opened",
                            HrEmployee."Date Of Join",HrEmployee."Date Of Leaving");
                           until HrEmployee.Next=0;
                         end;
                        end else begin
                              //Get the staff current salary
                              if SalCard.Get("No.") then begin
                                 CurrBasic:=SalCard."Basic Pay";
                              end;

                            objOcx.fnSalaryArrears("No.",strTransCode,CurrBasic,StartDate,EndDate,PayPeriod."Date Opened",
                            "Date Of Join","Date Of Leaving");

                        end;
                    end;
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        ProcessAll: Boolean;
        HrEmployee: Record UnknownRecord61118;
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        SalCard: Record UnknownRecord61105;
        PayPeriod: Record UnknownRecord61081;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        TransCode: Record UnknownRecord61082;
        strTransCode: Text[30];
        strEmpCode: Text[30];
        SalArr: Record UnknownRecord61088;
        strEmpName: Text[50];
        objEmp: Record UnknownRecord61118;
        CurrBasic: Decimal;
}

