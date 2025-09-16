#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68056 "HRM-Employee-List"
{
    CardPageID = "PRL-Header Salary Card";
    DeleteAllowed = false;
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61118;
    SourceTableView = sorting("No.")
                      order(ascending)
                      where("Full / Part Time"=filter("Full Time"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("Basic Pay";"Basic Pay")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Posting Group";"Payroll Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
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
                    Visible = false;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Length Of Service";"Length Of Service")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address2";"Postal Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address3";"Postal Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address";"Residential Address")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address2";"Residential Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address3";"Residential Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code2";"Post Code2")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field("Home Phone Number";"Home Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Cellular Phone Number";"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Work Phone Number";"Work Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Ext.";"Ext.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Union Code";"Union Code")
                {
                    ApplicationArea = Basic;
                }
                field("UIF Number";"UIF Number")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Country Code";"Country Code")
                {
                    ApplicationArea = Basic;
                }
                field("Statistics Group Code";"Statistics Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code1";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field(Office;Office)
                {
                    ApplicationArea = Basic;
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Fax Number";"Fax Number")
                {
                    ApplicationArea = Basic;
                }
                field("Company E-Mail";"Company E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Known As";"Known As")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Full / Part Time";"Full / Part Time")
                {
                    ApplicationArea = Basic;
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field("Contract End Date";"Contract End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Notice Period";"Notice Period")
                {
                    ApplicationArea = Basic;
                }
                field("Union Member?";"Union Member?")
                {
                    ApplicationArea = Basic;
                }
                field("Shift Worker?";"Shift Worker?")
                {
                    ApplicationArea = Basic;
                }
                field("Contracted Hours";"Contracted Hours")
                {
                    ApplicationArea = Basic;
                }
                field("Pay Period";"Pay Period")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Code";"Cost Code")
                {
                    ApplicationArea = Basic;
                }
                field("PAYE Number";"PAYE Number")
                {
                    ApplicationArea = Basic;
                }
                field("UIF Contributor?";"UIF Contributor?")
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("Ethnic Origin";"Ethnic Origin")
                {
                    ApplicationArea = Basic;
                }
                field("First Language (R/W/S)";"First Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                }
                field("Driving Licence";"Driving Licence")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Registration Number";"Vehicle Registration Number")
                {
                    ApplicationArea = Basic;
                }
                field(Disabled;Disabled)
                {
                    ApplicationArea = Basic;
                }
                field("Health Assesment?";"Health Assesment?")
                {
                    ApplicationArea = Basic;
                }
                field("Health Assesment Date";"Health Assesment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join1";"Date Of Join")
                {
                    ApplicationArea = Basic;
                }
                field("Length Of Service1";"Length Of Service")
                {
                    ApplicationArea = Basic;
                }
                field("End Of Probation Date";"End Of Probation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pension Scheme Join";"Pension Scheme Join")
                {
                    ApplicationArea = Basic;
                }
                field("Time Pension Scheme";"Time Pension Scheme")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme Join";"Medical Scheme Join")
                {
                    ApplicationArea = Basic;
                }
                field("Time Medical Scheme";"Time Medical Scheme")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Leaving";"Date Of Leaving")
                {
                    ApplicationArea = Basic;
                }
                field(Paterson;Paterson)
                {
                    ApplicationArea = Basic;
                }
                field(Peromnes;Peromnes)
                {
                    ApplicationArea = Basic;
                }
                field(Hay;Hay)
                {
                    ApplicationArea = Basic;
                }
                field(Castellion;Castellion)
                {
                    ApplicationArea = Basic;
                }
                field("Allow Overtime";"Allow Overtime")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme No.";"Medical Scheme No.")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme Head Member";"Medical Scheme Head Member")
                {
                    ApplicationArea = Basic;
                }
                field("Number Of Dependants";"Number Of Dependants")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme Name";"Medical Scheme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Car Allowance ?";"Receiving Car Allowance ?")
                {
                    ApplicationArea = Basic;
                }
                field("Second Language (R/W/S)";"Second Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Language";"Additional Language")
                {
                    ApplicationArea = Basic;
                }
                field("Cell Phone Reimbursement?";"Cell Phone Reimbursement?")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Reimbursed";"Amount Reimbursed")
                {
                    ApplicationArea = Basic;
                }
                field("UIF Country";"UIF Country")
                {
                    ApplicationArea = Basic;
                }
                field("Direct/Indirect";"Direct/Indirect")
                {
                    ApplicationArea = Basic;
                }
                field("Primary Skills Category";"Primary Skills Category")
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field("Termination Category";"Termination Category")
                {
                    ApplicationArea = Basic;
                }
                field("Job Specification";"Job Specification")
                {
                    ApplicationArea = Basic;
                }
                field(DateOfBirth;DateOfBirth)
                {
                    ApplicationArea = Basic;
                }
                field(DateEngaged;DateEngaged)
                {
                    ApplicationArea = Basic;
                }
                field(Citizenship;Citizenship)
                {
                    ApplicationArea = Basic;
                }
                field("Name Of Manager";"Name Of Manager")
                {
                    ApplicationArea = Basic;
                }
                field("Disabling Details";"Disabling Details")
                {
                    ApplicationArea = Basic;
                }
                field("Disability Grade";"Disability Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Passport Number";"Passport Number")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Skills Category";"2nd Skills Category")
                {
                    ApplicationArea = Basic;
                }
                field("3rd Skills Category";"3rd Skills Category")
                {
                    ApplicationArea = Basic;
                }
                field(PensionJoin;PensionJoin)
                {
                    ApplicationArea = Basic;
                }
                field(DateLeaving;DateLeaving)
                {
                    ApplicationArea = Basic;
                }
                field(Region;Region)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(reporting)
        {
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
            action(View2PagePayslip)
            {
                ApplicationArea = Basic;
                Caption = 'Payslip (Horizontal)';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

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
            action("vew payslip")
            {
                ApplicationArea = Basic;
                Caption = 'vew payslip';
                Image = "report";
                Promoted = true;
                RunObject = Report "Individual Payslips mst";
            }
            action("Master Payroll Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Master Payroll Summary';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
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
            action("Payroll summary")
            {
                ApplicationArea = Basic;
                Caption = 'Payroll summary';
                Image = payslip;
                RunObject = Report "Payroll Summary 2";
            }
            action("Deductions Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Deductions Summary';
                Image = summary;
                RunObject = Report "PRL-Deductions Summary";
            }
            action("Earnings Summary")
            {
                ApplicationArea = Basic;
                Caption = 'Earnings Summary';
                Image = DepositSlip;
                RunObject = Report "PRL-Earnings Summary";
            }
            action("Staff pension")
            {
                ApplicationArea = Basic;
                Caption = 'Staff pension';
                Image = Aging;
                RunObject = Report "Staff Pension Report";
            }
            action("Gross Netpay")
            {
                ApplicationArea = Basic;
                Caption = 'Gross Netpay';
                Image = Giro;
                RunObject = Report prGrossNetPay;
            }
            action("Third Rule")
            {
                ApplicationArea = Basic;
                Caption = 'Third Rule';
                Image = AddWatch;
                RunObject = Report "A third Rule Report";
            }
            action("Co_op Remittance")
            {
                ApplicationArea = Basic;
                Caption = 'Co_op Remittance';
                Image = CreateForm;
                RunObject = Report "prCoop remmitance";
            }
            separator(Action41)
            {
                Caption = 'setup finance';
            }
            action("receipt type")
            {
                ApplicationArea = Basic;
                Caption = 'receipt type';
                Image = ServiceSetup;
                Promoted = true;
                RunObject = Page "FIN-Receipt Types";
            }
            action(Transactions)
            {
                ApplicationArea = Basic;
                Caption = 'Transactions';
                Image = "report";
                Promoted = true;
                RunObject = Report "pr Transactions";
            }
            action("bank Schedule")
            {
                ApplicationArea = Basic;
                Caption = 'bank Schedule';
                Image = "report";
                Promoted = true;
                RunObject = Report "pr Bank Schedule";
            }
            separator(Action36)
            {
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
            action("P9 Report")
            {
                ApplicationArea = Basic;
                Caption = 'P9 Report';
                Image = Report2;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "P9 Report (Final)";
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
            separator(Action29)
            {
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
                    //IF HrEmployee.GET("No.") THEN BEGIN
                    // HrEmployee.SETRANGE(HrEmployee."Employee Type",HrEmployee."Employee Type"::Permanent);
                     //HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Normal);
                     if HrEmployee.Find('-') then begin
                          PeriodTrans.Reset;
                          PeriodTrans.SetRange(PeriodTrans."Employee Code",HrEmployee."No.");
                          PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                          if PeriodTrans.Find('-') then
                          PeriodTrans.DeleteAll;

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
                    progre.Open('Processing Please wait..............\#1###############################################################'+
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
                    '\#13###############################################################',
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
                     salaryCard.SetFilter(salaryCard.Closed,'=%1',false);
                     //IF salaryCard.FIND('-') THEN BEGIN
                     //END;

                     dateofJoining:=0D;
                     dateofLeaving:=CalcDate('100Y',Today);
                      if HrEmployee."Contract End Date"<>0D then  dateofLeaving:=HrEmployee."Contract End Date";
                     if HrEmployee."Date Of Join"=0D then dateofJoining:=CalcDate('-1M',Today);
                       //Progress Window

                    Customer.Reset;
                    Customer.SetRange("No.",HrEmployee."No.");
                    if Customer.Find('-') then begin
                        Customer.CalcFields(Balance);
                      if Customer.Balance>0 then begin
                        // The Employee Has Imprest Balance (760)
                         prempTrns.Reset;
                     prempTrns.SetRange(prempTrns."Employee Code",HrEmployee."No.");
                     prempTrns.SetRange(prempTrns."Payroll Period",SelectedPeriod);
                     prempTrns.SetRange(prempTrns."Transaction Code",'760');
                     if prempTrns.Find('-') then begin
                       prempTrns.Amount:=Customer.Balance;
                    prempTrns.Balance:=Customer.Balance;
                    prempTrns."Recurance Index":=1;
                        end else begin
                    prempTrns.Init;
                    prempTrns."Employee Code":=HrEmployee."No.";
                    prempTrns."Transaction Code":='760';
                    prempTrns."Recovery Priority":=100;
                    prempTrns."Period Month":=Date2dmy(SelectedPeriod,2);
                    prempTrns."Period Year":=Date2dmy(SelectedPeriod,3);
                    prempTrns."Payroll Period":=SelectedPeriod;
                    if PRLTransactionCodes.Get('760') then
                    prempTrns."Transaction Name":=PRLTransactionCodes."Transaction Name";
                    prempTrns.Amount:=Customer.Balance;
                    prempTrns.Balance:=Customer.Balance;
                    prempTrns."Recurance Index":=1;
                          prempTrns.Insert;
                          end;
                      end;
                      end;

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
                          dateofLeaving,false,HrEmployee."Department Code",false);


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
                     salaryCard.SetFilter(salaryCard.Closed,'=%1',false);
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
                          dateofLeaving,GetsPAYERelief,HrEmployee."Department Code",salaryCard.paysHousLevy);
                    //ERROR('Invalid Date format');
                    Clear(Var1);
                        counts:=counts+1;
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


                    SalCard2.Reset;
                    SalCard2.SetRange("Employee Code","No.");
                    SalCard2.SetRange(SalCard2."Period Filter",SelectedPeriod);
                    SalCard2.SetFilter(SalCard2.Closed,'=%1',false);

                    //REPORT.RUN(39005514,TRUE,FALSE,SalCard);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (DepCode <> '') then
           SetFilter("Department Code", ' = %1', DepCode);
        if (OfficeCode <> '') then
           SetFilter(Office, ' = %1', OfficeCode);
    end;

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
        Customer: Record Customer;
        PRLTransactionCodes: Record UnknownRecord61082;


    procedure SetNewFilter(var DepartmentCode: Code[10];var "Office Code": Code[10])
    begin
        DepCode := DepartmentCode;
        OfficeCode := "Office Code";
    end;
}

