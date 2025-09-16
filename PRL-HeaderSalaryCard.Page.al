#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68062 "PRL-Header Salary Card"
{
    // strempcode,dtDOE,curbasicpay,blnpaye,blnnssf,blnnhif,selectedperio,dtopenperio,
    // membership,referenceno,dttermination,blngetspayereleif

    DeleteAllowed = false;
    PageType = Document;
    SaveValues = true;
    SourceTable = UnknownTable61118;

    layout
    {
        area(content)
        {
            group("Employee Details")
            {
                Caption = 'Employee Details';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Enabled = true;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Mode";"Payment Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Full / Part Time";"Full / Part Time")
                {
                    ApplicationArea = Basic;
                    Enabled = true;
                }
                field("Contract End Date";"Contract End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Grade Level";"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Code";"Payroll Code")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("NSSF No.";"NSSF No.")
                {
                    ApplicationArea = Basic;
                }
                field("NHIF No.";"NHIF No.")
                {
                    ApplicationArea = Basic;
                }
                field("PIN Number";"PIN Number")
                {
                    ApplicationArea = Basic;
                }
                field("Main Bank";"Main Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Bank";"Branch Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Physical Disability";"Physical Disability")
                {
                    ApplicationArea = Basic;
                }
                field("Salary Category";"Salary Category")
                {
                    ApplicationArea = Basic;
                }
                field("Salary Grade";"Salary Grade")
                {
                    ApplicationArea = Basic;
                }
                field(Section;Section)
                {
                    ApplicationArea = Basic;
                }
                field("New Number";"New Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Main Bank1";"Main Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Bank1";"Branch Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account Number1";"Bank Account Number")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102756041;"PRL-SalaryCard")
            {
                Caption = 'Salary Details';
                SubPageLink = "Employee Code"=field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Transactions)
            {
                Caption = 'Transactions';
                action("Assign Transaction")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign Transaction';
                    Image = ApplyEntries;
                    Promoted = true;
                    RunObject = Page "PRL-List Transactions";
                    RunPageLink = "Employee Code"=field("No.");
                }
                separator(Action1102756009)
                {
                }
                action("View Trans Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Trans Codes';
                    Image = ViewDetails;
                    Promoted = true;
                    RunObject = Page "PRL-List TransCode";
                }
                separator(Action1102756011)
                {
                }
                action(Rename)
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    var
                        NewNumber: Code[25];
                    begin
                        Rec.TestField("New Number");
                        if not Confirm('Do you wish to change the no?') then exit;
                          Rec.Rename("New Number");
                    end;
                }
            }
            group("Other Info")
            {
                Caption = 'Other Info';
                action("Banking Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Banking Details';
                    Image = BankAccount;
                    RunObject = Page "PRL-Employee Banks";
                    RunPageLink = "Employee Code"=field("No.");
                }
                separator(Action1102756059)
                {
                }
                action("Pension Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Details';
                    Image = History;
                    RunObject = Page "PRL-Pension Contrib. Details";
                    RunPageLink = "Employee Code"=field("No.");
                }
                action("Refresh HR Employees")
                {
                    ApplicationArea = Basic;
                    Image = UpdateDescription;
                    Visible = false;

                    trigger OnAction()
                    begin
                          i:=0;
                          HREmp.Reset;
                          HREmp.SetRange(HREmp.Status,HREmp.Status::Normal);
                          if HREmp.Find('-') then begin
                          repeat
                          if not objEmp.Get(HREmp."No.") then begin
                          i:=i+1;
                          objEmp.Init;
                          objEmp."No.":=HREmp."No.";
                          objEmp."First Name":=HREmp."First Name";
                          objEmp."Middle Name":=HREmp."Middle Name";
                          objEmp."Last Name":=HREmp."Last Name";
                          objEmp.Initials:=HREmp.Initials;
                          objEmp."Search Name":=HREmp."Search Name";
                          objEmp."Cellular Phone Number":=HREmp."Cellular Phone Number";
                          objEmp."E-Mail":=HREmp."E-Mail";
                          objEmp."ID Number":=HREmp."ID Number";
                          objEmp.Gender:=HREmp.Gender;
                          objEmp.Status:=objEmp.Status::Normal;
                          objEmp."Company E-Mail":=HREmp."Company E-Mail";
                          objEmp."Date Of Birth":=HREmp."Date Of Birth";
                          objEmp."Date Of Join":=HREmp."Date Of Join";
                          objEmp."PIN Number":=HREmp."PIN Number";
                          objEmp."NSSF No.":=HREmp."NSSF No.";
                          objEmp."NHIF No.":=HREmp."NHIF No.";
                         objEmp."Department Code":= HREmp."Department Code";
                          objEmp."Posting Group":='PAYROLL';
                          objEmp.Insert;
                          end else begin
                          j:=j+1;
                          objEmp."First Name":=HREmp."First Name";
                          objEmp."Middle Name":=HREmp."Middle Name";
                          objEmp."Last Name":=HREmp."Last Name";
                          objEmp.Initials:=HREmp.Initials;
                          objEmp."Search Name":=HREmp."Search Name";
                          objEmp."Cellular Phone Number":=HREmp."Cellular Phone Number";
                          objEmp."E-Mail":=HREmp."E-Mail";
                          objEmp."ID Number":=HREmp."ID Number";
                          objEmp.Gender:=HREmp.Gender;
                          objEmp.Status:=objEmp.Status::Normal;
                          objEmp."Company E-Mail":=HREmp."Company E-Mail";
                          objEmp."Date Of Birth":=HREmp."Date Of Birth";
                          objEmp."Date Of Join":=HREmp."Date Of Join";
                          objEmp."PIN Number":=HREmp."PIN Number";
                          objEmp."NSSF No.":=HREmp."NSSF No.";
                          objEmp."NHIF No.":=HREmp."NHIF No.";
                          objEmp."Department Code":= HREmp."Department Code";
                          objEmp."Posting Group":='PAYROLL';
                          objEmp.Modify;
                          end;
                          until HREmp.Next=0;
                          end;
                          Message(Format(i)+' Employees Created, '+Format(j)+ ' Employees Updated');
                    end;
                }
            }
        }
        area(reporting)
        {
            action(View2PagePayslip)
            {
                ApplicationArea = Basic;
                Caption = 'Payslip (Horizontal)';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed,false);
                    if objPeriod.Find('-') then;
                    SelectedPeriod:=objPeriod."Date Opened";

                    SalCard.Reset;
                    SalCard.SetRange(SalCard."Employee Code","No.");
                    SalCard.SetRange(SalCard."Payroll Period",SelectedPeriod);
                    if SalCard.Find('-') then
                    Report.Run(51745,true,false,SalCard);
                end;
            }
            action(ViewhorPayslip)
            {
                ApplicationArea = Basic;
                Caption = 'View 2 Pages Payslip';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed,false);
                    if objPeriod.Find('-') then;
                    SelectedPeriod:=objPeriod."Date Opened";

                    SalCard.Reset;
                    SalCard.SetRange(SalCard."Employee Code","No.");
                    SalCard.SetRange(SalCard."Payroll Period",SelectedPeriod);
                    if SalCard.Find('-') then
                    Report.Run(51736,true,false,SalCard);
                end;
            }
            action(View3PagePayslip)
            {
                ApplicationArea = Basic;
                Caption = 'View3 Pages Payslip';
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin

                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed,false);
                    if objPeriod.Find('-') then;
                    SelectedPeriod:=objPeriod."Date Opened";

                    SalCard.Reset;
                    SalCard.SetRange(SalCard."Employee Code","No.");
                    SalCard.SetRange(SalCard."Payroll Period",SelectedPeriod);
                    if SalCard.Find('-') then
                    Report.Run(51143,true,false,SalCard);
                end;
            }
            action("P9 Report")
            {
                ApplicationArea = Basic;
                Caption = 'P9 Report';
                Image = Report2;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "P9 Report (Final)";
            }
            action("Master Payroll Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Master Payroll Summary';
                Image = "Report";
                Promoted = true;
                RunObject = Report "PRL-Company Payroll Summary 3";
            }
            action("Deductions Summary 2")
            {
                ApplicationArea = Basic;
                Caption = 'Deductions Summary 2';
                Image = "Report";
                Promoted = true;
                RunObject = Report "PRL-Deductions Summary 2";
            }
            action("Earnings Summary 2")
            {
                ApplicationArea = Basic;
                Caption = 'Earnings Summary 2';
                Image = "Report";
                Promoted = true;
                RunObject = Report "PRL-Payments Summary 2";
            }
            action("Employer Certificate")
            {
                ApplicationArea = Basic;
                Caption = 'Employer Certificate';
                Image = "report";
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Employer Certificate P.10 mst";
            }
            action("P.10")
            {
                ApplicationArea = Basic;
                Caption = 'P.10';
                Image = "report";
                Promoted = true;
                RunObject = Report "P.10 A mst";
            }
            action("Paye Scheule")
            {
                ApplicationArea = Basic;
                Caption = 'Paye Scheule';
                Image = "report";
                Promoted = true;
                RunObject = Report "prPaye Schedule mst";
            }
            action("NHIF Schedult")
            {
                ApplicationArea = Basic;
                Caption = 'NHIF Schedult';
                Image = "report";
                Promoted = true;
                RunObject = Report "prNHIF mst";
            }
            action("NSSF Schedule")
            {
                ApplicationArea = Basic;
                Caption = 'NSSF Schedule';
                Image = "report";
                Promoted = true;
                RunObject = Report "prNSSF mst";
            }
        }
        area(processing)
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
                begin
                    // ContrInfo.GET;
                    //
                    // IF CONFIRM('This will process salaries for all employees, Continue?',FALSE)=FALSE THEN EXIT;
                    //
                    // objPeriod.RESET;
                    // objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                    // IF objPeriod.FIND('-') THEN;
                    // SelectedPeriod:=objPeriod."Date Opened";
                    //
                    // //SalCard.GET("No.");
                    //
                    //      PeriodTrans.RESET;
                    //      PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                    //      IF PeriodTrans.FIND('-') THEN
                    //      PeriodTrans.DELETEALL;
                    //
                    //
                    // //Use CODEUNIT
                    // HrEmployee.RESET;
                    // HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Normal);
                    // //IF HrEmployee.GET("No.") THEN BEGIN
                    // // HrEmployee.SETRANGE(HrEmployee."Employee Type",HrEmployee."Employee Type"::Permanent);
                    // //HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Normal);
                    // IF HrEmployee.FIND('-') THEN BEGIN
                    //      PeriodTrans.RESET;
                    //      PeriodTrans.SETRANGE(PeriodTrans."Employee Code",HrEmployee."No.");
                    //      PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                    //      IF PeriodTrans.FIND('-') THEN
                    //      PeriodTrans.DELETEALL;
                    //
                    // CLEAR(RecCount1);
                    // CLEAR(RecCount2);
                    // CLEAR(RecCount3);
                    // CLEAR(RecCount4);
                    // CLEAR(RecCount5);
                    // CLEAR(RecCount6);
                    // CLEAR(RecCount7);
                    // CLEAR(RecCount8);
                    // CLEAR(RecCount9);
                    // CLEAR(RecCount10);
                    // CLEAR(counts);
                    // progre.OPEN('Processing Please wait..............\#1###############################################################'+
                    // '\#2###############################################################'+
                    // '\#3###############################################################'+
                    // '\#4###############################################################'+
                    // '\#5###############################################################'+
                    // '\#6###############################################################'+
                    // '\#7###############################################################'+
                    // '\#8###############################################################'+
                    // '\#9###############################################################'+
                    // '\#10###############################################################'+
                    // '\#11###############################################################'+
                    // '\#12###############################################################'+
                    // '\#13###############################################################',
                    //    RecCount1,
                    //    RecCount2,
                    //    RecCount3,
                    //    RecCount4,
                    //    RecCount5,
                    //    RecCount6,
                    //    RecCount7,
                    //    RecCount8,
                    //    RecCount9,
                    //    RecCount10,
                    //    Var1,
                    //    Var1,
                    //    BufferString
                    // );
                    //
                    // REPEAT
                    // salaryCard.RESET;
                    // salaryCard.SETRANGE(salaryCard."Employee Code",HrEmployee."No.");
                    // salaryCard.SETFILTER(salaryCard.Closed,'=%1',FALSE);
                    // //IF salaryCard.FIND('-') THEN BEGIN
                    // //END;
                    //
                    // dateofJoining:=0D;
                    // dateofLeaving:=CALCDATE('100Y',TODAY);
                    // IF HrEmployee."Contract End Date"<>0D THEN  dateofLeaving:=HrEmployee."Contract End Date";
                    // IF HrEmployee."Date Of Join"=0D THEN dateofJoining:=CALCDATE('-1M',TODAY);
                    //   //Progress Window
                    //
                    // Customer.RESET;
                    // Customer.SETRANGE("No.",HrEmployee."No.");
                    // IF Customer.FIND('-') THEN BEGIN
                    //    Customer.CALCFIELDS(Balance);
                    //  IF Customer.Balance>0 THEN BEGIN
                    //    // The Employee Has Imprest Balance (760)
                    //     prempTrns.RESET;
                    // prempTrns.SETRANGE(prempTrns."Employee Code",HrEmployee."No.");
                    // prempTrns.SETRANGE(prempTrns."Payroll Period",SelectedPeriod);
                    // prempTrns.SETRANGE(prempTrns."Transaction Code",'760');
                    // IF prempTrns.FIND('-') THEN BEGIN
                    //   prempTrns.Amount:=Customer.Balance;
                    // prempTrns.Balance:=Customer.Balance;
                    // prempTrns."Recurance Index":=1;
                    //    END ELSE BEGIN
                    // prempTrns.INIT;
                    // prempTrns."Employee Code":=HrEmployee."No.";
                    // prempTrns."Transaction Code":='760';
                    // prempTrns."Recovery Priority":=100;
                    // prempTrns."Period Month":=DATE2DMY(SelectedPeriod,2);
                    // prempTrns."Period Year":=DATE2DMY(SelectedPeriod,3);
                    // prempTrns."Payroll Period":=SelectedPeriod;
                    // IF PRLTransactionCodes.GET('760') THEN
                    // prempTrns."Transaction Name":=PRLTransactionCodes."Transaction Name";
                    // prempTrns.Amount:=Customer.Balance;
                    // prempTrns.Balance:=Customer.Balance;
                    // prempTrns."Recurance Index":=1;
                    //      prempTrns.INSERT;
                    //      END;
                    //  END;
                    //  END;
                    //
                    // //  ProgressWindow.UPDATE(1,HrEmployee."No."+':'+HrEmployee."First Name"+' '+HrEmployee."Middle Name"+' '+HrEmployee."Last Name");
                    //  //IF SalCard.GET(HrEmployee."No.") THEN BEGIN
                    //
                    // IF NOT salaryCard.FIND('-')  THEN BEGIN
                    // // If employee has no Basic Salary
                    // prempTrns.RESET;
                    // prempTrns.SETRANGE(prempTrns."Employee Code",HrEmployee."No.");
                    // prempTrns.SETRANGE(prempTrns."Payroll Period",SelectedPeriod);
                    // IF prempTrns.FIND('-') THEN BEGIN
                    //      PeriodTrans.RESET;
                    //      PeriodTrans.SETRANGE(PeriodTrans."Employee Code",HrEmployee."No.");
                    //      PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                    //      PeriodTrans.DELETEALL; // Delete Processed Transactions
                    //
                    //  ProcessPayroll.fnProcesspayroll(HrEmployee."No.",DOJ,0,FALSE
                    //      ,FALSE,FALSE,SelectedPeriod,SelectedPeriod,'','',
                    //      dateofLeaving,FALSE,HrEmployee."Department Code");
                    //
                    //
                    // END;// Hast Transaction
                    // END ELSE
                    //  IF salaryCard.FIND('-')  THEN BEGIN
                    // IF salaryCard."Suspend Pay"<>TRUE THEN BEGIN
                    //  //IF salaryCard."Gets Personal Relief"=salaryCard."Gets Personal Relief"::"1" THEN GetsPAYERelief:=TRUE ELSE GetsPAYERelief:=FALSE;
                    //  GetsPAYERelief:=TRUE;
                    //  DOJ:=0D;
                    //  IF HrEmployee."Date Of Join"=0D THEN DOJ:=CALCDATE('-2M',TODAY) ELSE DOJ:=HrEmployee."Date Of Join";
                    // salaryCard.RESET;
                    // salaryCard.SETRANGE(salaryCard."Employee Code",HrEmployee."No.");
                    // salaryCard.SETFILTER(salaryCard.Closed,'=%1',FALSE);
                    // IF salaryCard.FIND('-') THEN BEGIN
                    // IF salaryCard."Suspend Pay"=TRUE THEN BEGIN
                    //      PeriodTrans.RESET;
                    //      PeriodTrans.SETRANGE(PeriodTrans."Employee Code",HrEmployee."No.");
                    //      PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                    //      PeriodTrans.DELETEALL;
                    // END// delete stuff from transactions table
                    // ELSE BEGIN
                    //  ProcessPayroll.fnProcesspayroll(HrEmployee."No.",DOJ,salaryCard."Basic Pay",salaryCard."Pays PAYE"
                    //      ,salaryCard."Pays NSSF",salaryCard."Pays NHIF",SelectedPeriod,SelectedPeriod,'','',
                    //      dateofLeaving,GetsPAYERelief,HrEmployee."Department Code");
                    // //ERROR('Invalid Date format');
                    // CLEAR(Var1);
                    //    counts:=counts+1;
                    //    IF counts=1 THEN
                    //    RecCount1:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    ELSE IF counts=2 THEN BEGIN
                    //    RecCount2:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=3 THEN BEGIN
                    //    RecCount3:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=4 THEN BEGIN
                    //    RecCount4:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=5 THEN BEGIN
                    //    RecCount5:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=6 THEN BEGIN
                    //    RecCount6:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=7 THEN BEGIN
                    //    RecCount7:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=8 THEN BEGIN
                    //    RecCount8:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=9 THEN BEGIN
                    //    RecCount9:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END
                    //    ELSE IF counts=10 THEN BEGIN
                    //    RecCount10:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
                    //    END ELSE IF counts>10 THEN BEGIN
                    //    RecCount1:=RecCount2;
                    //    RecCount2:=RecCount3;
                    //    RecCount3:=RecCount4;
                    //    RecCount4:=RecCount5;
                    //    RecCount5:=RecCount6;
                    //    RecCount6:=RecCount7;
                    //    RecCount7:=RecCount8;
                    //    RecCount8:=RecCount9;
                    //    RecCount9:=RecCount10;
                    //    RecCount10:=FORMAT(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
                    // HrEmployee."Middle Name"+' '+HrEmployee."Last Name";
                    //    END;
                    //    CLEAR(BufferString);
                    //    BufferString:='Total Records processed = '+FORMAT(counts);
                    //
                    //    progre.UPDATE();
                    //
                    //      END;
                    //      END;
                    //   //   END;
                    //      END;
                    //      END;
                    // UNTIL  HrEmployee.NEXT=0;
                    // ////Progress Window
                    // progre.CLOSE;
                    // END;
                    // //CODEUNIT
                    //
                    //
                    // SalCard2.RESET;
                    // SalCard2.SETRANGE("Employee Code","No.");
                    // SalCard2.SETRANGE(SalCard2."Period Filter",SelectedPeriod);
                    // SalCard2.SETFILTER(SalCard2.Closed,'=%1',FALSE);
                    //
                    // //REPORT.RUN(39005514,TRUE,FALSE,SalCard);
                end;
            }
        }
    }

    trigger OnInit()
    begin

        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then
        begin
            SelectedPeriod:=objPeriod."Date Opened";
            PeriodName:=objPeriod."Period Name";
            PeriodMonth:=objPeriod."Period Month";
            PeriodYear:=objPeriod."Period Year";
        end;
    end;

    var
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
        HREmp: Record UnknownRecord61118;
        j: Integer;
        PeriodTrans: Record UnknownRecord61092;
        salaryCard: Record UnknownRecord61105;
        dateofJoining: Date;
        dateofLeaving: Date;
        GetsPAYERelief: Boolean;
        DOJ: Date;
        SalCard2: Record UnknownRecord61105;
        Customer: Record Customer;
        PRLTransactionCodes: Record UnknownRecord61082;
}

