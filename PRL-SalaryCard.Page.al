#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68063 "PRL-SalaryCard"
{
    PageType = List;
    SourceTable = UnknownTable61105;
    SourceTableView = where(Closed=filter(No));

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                field("Basic Pay";"Basic Pay")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Mode";"Payment Mode")
                {
                    ApplicationArea = Basic;
                }
                field(Currency;Currency)
                {
                    ApplicationArea = Basic;
                }
                field("Pays NSSF";"Pays NSSF")
                {
                    ApplicationArea = Basic;
                }
                field("Pays NHIF";"Pays NHIF")
                {
                    ApplicationArea = Basic;
                }
                field("Pays PAYE";"Pays PAYE")
                {
                    ApplicationArea = Basic;
                }
                field("Pays Pension";"Pays Pension")
                {
                    ApplicationArea = Basic;
                }
                field("Payslip Message";"Payslip Message")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field("Suspend Pay";"Suspend Pay")
                {
                    ApplicationArea = Basic;
                }
                field("Suspension Date";"Suspension Date")
                {
                    ApplicationArea = Basic;
                }
                field("Suspension Reasons";"Suspension Reasons")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm BasicPay";"Cumm BasicPay")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm GrossPay";"Cumm GrossPay")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm NetPay";"Cumm NetPay")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm Allowances";"Cumm Allowances")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm Deductions";"Cumm Deductions")
                {
                    ApplicationArea = Basic;
                }
                field("Period Filter";"Period Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm PAYE";"Cumm PAYE")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm NSSF";"Cumm NSSF")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm Pension";"Cumm Pension")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm HELB";"Cumm HELB")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm NHIF";"Cumm NHIF")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm Employer Pension";"Cumm Employer Pension")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ProcessPayroll)
            {
                ApplicationArea = Basic;
                Caption = 'Process Payslip';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;

                trigger OnAction()
                var
                    progre: Dialog;
                    counts: Integer;
                    RecCount1: Text[120];
                    RecCount2: Text[120];
                    RecCount3: Text[120];
                    RecCount4: Text[120];
                    RecCount5: Text[120];
                    RecCount6: Text[120];
                    RecCount7: Text[120];
                    RecCount8: Text[120];
                    RecCount9: Text[120];
                    RecCount10: Text[120];
                    BufferString: Text[1024];
                    Var1: Code[10];
                    prempTrns: Record UnknownRecord61091;
                    progDots: Text[50];
                    counted: Integer;
                    text1: label '.';
                    text2: label '.  .';
                    text3: label '.  .  .';
                    text4: label '.  .  .  .';
                    text5: label '.  .  .  .  .';
                    text6: label '.  .  .  .  .  .';
                    text7: label '.  .  .  .  .  .  .';
                    text8: label '.  .  .  .  .  .  .  .';
                    text9: label '.  .  .  .  .  .  .  .  .';
                    text10: label '.  .  .  .  .  .  .  .  .  .';
                begin
                    ContrInfo.Get;

                    if Confirm('This will process salaries for all employees, Continue?',false)=false then exit;

                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed,false);
                    if objPeriod.Find('-') then;
                    SelectedPeriod:=objPeriod."Date Opened";

                    //SalCard.GET("No.");

                          PeriodTrans.Reset;
                          PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                          if PeriodTrans.Find('-') then
                          PeriodTrans.DeleteAll;


                    //Use CODEUNIT
                     HrEmployee.Reset;
                     HrEmployee.SetRange(HrEmployee.Status,HrEmployee.Status::Normal);
                    // HrEmployee.SETRANGE(HrEmployee."Employee Type",HrEmployee."Employee Type"::Permanent);
                     //HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Normal);
                     if HrEmployee.Find('-') then begin
                          PeriodTrans.Reset;
                          PeriodTrans.SetRange(PeriodTrans."Employee Code",HrEmployee."No.");
                          PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                          if PeriodTrans.Find('-') then
                          PeriodTrans.DeleteAll;
                     Clear(progDots);
                    Clear(RecCount1);
                    Clear(RecCount2);
                    Clear(RecCount3);
                    Clear(RecCount4);
                    Clear(RecCount5);
                    Clear(RecCount6);
                    Clear(RecCount7);
                    Clear(RecCount8);
                    Clear(RecCount9);
                    Clear(RecCount10);
                    Clear(counts);
                    progre.Open('Processing Please wait #1#############################'+
                    '\ '+
                    '\#2###############################################################'+
                    '\#3###############################################################'+
                    '\#4###############################################################'+
                    '\#5###############################################################'+
                    '\#6###############################################################'+
                    '\#7###############################################################'+
                    '\#8###############################################################'+
                    '\#9###############################################################'+
                    '\#10###############################################################'+
                    '\#11###############################################################'+
                    '\#12###############################################################'+
                    '\#13###############################################################'+
                    '\#14###############################################################',
                        progDots,
                        RecCount1,
                        RecCount2,
                        RecCount3,
                        RecCount4,
                        RecCount5,
                        RecCount6,
                        RecCount7,
                        RecCount8,
                        RecCount9,
                        RecCount10,
                        Var1,
                        Var1,
                        BufferString
                    );

                     repeat
                     salaryCard.Reset;
                     salaryCard.SetRange(salaryCard."Employee Code",HrEmployee."No.");
                     //IF salaryCard.FIND('-') THEN BEGIN
                     //END;

                     dateofJoining:=0D;
                     dateofLeaving:=CalcDate('100Y',Today);
                     if HrEmployee."Date Of Join"=0D then dateofJoining:=CalcDate('-1M',Today);
                       //Progress Window


                     //  ProgressWindow.UPDATE(1,HrEmployee."No."+':'+HrEmployee."First Name"+' '+HrEmployee."Middle Name"+' '+HrEmployee."Last Name");
                      //IF SalCard.GET(HrEmployee."No.") THEN BEGIN

                    if not salaryCard.Find('-')  then begin
                    // If employee has no Basic Salary
                     prempTrns.Reset;
                     prempTrns.SetRange(prempTrns."Employee Code",HrEmployee."No.");
                     prempTrns.SetRange(prempTrns."Payroll Period",SelectedPeriod);
                     if prempTrns.Find('-') then begin
                          PeriodTrans.Reset;
                          PeriodTrans.SetRange(PeriodTrans."Employee Code",HrEmployee."No.");
                          PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                          PeriodTrans.DeleteAll; // Delete Processed Transactions

                      ProcessPayroll.fnProcesspayroll(HrEmployee."No.",DOJ,0,false
                          ,false,false,SelectedPeriod,SelectedPeriod,'','',
                          dateofLeaving,false,HrEmployee."Department Code");


                     end;// Hast Transaction
                    end else
                      if salaryCard.Find('-')  then begin
                     if salaryCard."Suspend Pay"<>true then begin
                      //IF salaryCard."Gets Personal Relief"=salaryCard."Gets Personal Relief"::"1" THEN GetsPAYERelief:=TRUE ELSE GetsPAYERelief:=FALSE;
                      GetsPAYERelief:=true;
                      DOJ:=0D;
                      if HrEmployee."Date Of Join"=0D then DOJ:=CalcDate('-2M',Today) else DOJ:=HrEmployee."Date Of Join";
                     salaryCard.Reset;
                     salaryCard.SetRange(salaryCard."Employee Code",HrEmployee."No.");
                     if salaryCard.Find('-') then begin
                     if salaryCard."Suspend Pay"=true then begin
                          PeriodTrans.Reset;
                          PeriodTrans.SetRange(PeriodTrans."Employee Code",HrEmployee."No.");
                          PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                          PeriodTrans.DeleteAll;
                     end// delete stuff from transactions table
                     else begin
                      ProcessPayroll.fnProcesspayroll(HrEmployee."No.",DOJ,salaryCard."Basic Pay",salaryCard."Pays PAYE"
                          ,salaryCard."Pays NSSF",salaryCard."Pays NHIF",SelectedPeriod,SelectedPeriod,'','',
                          dateofLeaving,GetsPAYERelief,HrEmployee."Department Code");

                    Clear(Var1);
                        counts:=counts+1;
                        if ((counted=21) or(counted=11)) then begin
                        if counted=21 then counted := 0;
                        Sleep(150);
                        end;
                        counted:=counted+1;
                        if counted=1 then progDots:=text1
                        else if counted=2 then progDots:=text2
                        else if counted=3 then progDots:=text3
                        else if counted=4 then progDots:=text4
                        else if counted=5 then progDots:=text5
                        else if counted=6 then progDots:=text6
                        else if counted=7 then progDots:=text7
                        else if counted=8 then progDots:=text8
                        else if counted=9 then progDots:=text9
                        else if counted=10 then progDots:=text10
                        else if counted=19 then progDots:=text1
                        else if counted=18 then progDots:=text2
                        else if counted=17 then progDots:=text3
                        else if counted=16 then progDots:=text4
                        else if counted=15 then progDots:=text5
                        else if counted=14 then progDots:=text6
                        else if counted=13 then progDots:=text7
                        else if counted=12 then progDots:=text8
                        else if counted=11 then progDots:=text9
                        else progDots:='';

                        if counts=1 then
                        RecCount1:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        else if counts=2 then begin
                        RecCount2:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=3 then begin
                        RecCount3:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=4 then begin
                        RecCount4:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=5 then begin
                        RecCount5:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=6 then begin
                        RecCount6:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=7 then begin
                        RecCount7:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=8 then begin
                        RecCount8:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=9 then begin
                        RecCount9:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end
                        else if counts=10 then begin
                        RecCount10:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                        end else if counts>10 then begin
                        RecCount1:=RecCount2;
                        RecCount2:=RecCount3;
                        RecCount3:=RecCount4;
                        RecCount4:=RecCount5;
                        RecCount5:=RecCount6;
                        RecCount6:=RecCount7;
                        RecCount7:=RecCount8;
                        RecCount8:=RecCount9;
                        RecCount9:=RecCount10;
                        RecCount10:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    HrEmployee."Middle Name"+' '+HrEmployee."Last Name";
                        end;
                        Clear(BufferString);
                        BufferString:='Total Records processed = '+Format(counts);

                        progre.Update();
                         Sleep(50);
                          end;
                          end;
                       //   END;
                          end;
                          end;
                     until  HrEmployee.Next=0;
                     ////Progress Window
                     progre.Close;
                     end;
                    //CODEUNIT


                    //SalCard2.RESET;
                    //SalCard2.SETRANGE("Employee Code","No.");
                    //SalCard2.SETRANGE(SalCard2."Period Filter",SelectedPeriod);

                    //REPORT.RUN(39005514,TRUE,FALSE,SalCard);
                end;
            }
        }
    }

    var
        Mail: Codeunit Mail;
        PictureExists: Boolean;
        DepCode: Code[10];
        OfficeCode: Code[10];
        objEmp: Record UnknownRecord61118;
        SalCard: Record UnknownRecord61105;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;
        ProcessPayroll: Codeunit "BankAcc.Recon. PostNew";
        HrEmployee: Record UnknownRecord61118;
        ProgressWindow: Dialog;
        prPeriodTransactions: Record UnknownRecord61092;
        prEmployerDeductions: Record UnknownRecord61094;
        PayrollType: Record UnknownRecord61103;
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record UnknownRecord61119;
        HREmp: Record UnknownRecord61188;
        j: Integer;
        PeriodTrans: Record UnknownRecord61092;
        salaryCard: Record UnknownRecord61105;
        dateofJoining: Date;
        dateofLeaving: Date;
        GetsPAYERelief: Boolean;
        DOJ: Date;
        SalCard2: Record UnknownRecord61105;
}

