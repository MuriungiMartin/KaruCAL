#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68835 "ACA-Std Billing List"
{
    Caption = 'All Students List';
    CardPageID = "ACA-Student Billing";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student),
                            Blocked=const(" "));

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
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount (LCY)";"Debit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount (LCY)";"Credit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Catering Amount";"Catering Amount")
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
            group(Registration)
            {
                Caption = 'Registration';
                action("Trimester registration")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Course Registration 3";
                    RunPageLink = "Student No."=field("No.");
                }
                action(StoppedReg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stopped Registrations';
                    Image = StopPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Course Reg. Reservour";
                    RunPageLink = "Student No."=field("No.");
                }
                action("Posted Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Charges';
                    Image = PostedVendorBill;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "ACA-Student Posted Charges";
                    RunPageLink = "Customer No."=field("No.");
                }
                action(Receipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipts';
                    Image = Receipt;
                    Promoted = true;
                    RunObject = Page "ACA-Receipts";
                    RunPageLink = "Student No."=field("No.");
                }
            }
            group(ActionGroup1000000040)
            {
                Caption = 'Registration';
                action(Prerequisite)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prerequisite';
                    Image = Approval;
                    RunObject = Page "ACA-Prerequisite Approval";
                    RunPageLink = "Student No."=field("No.");
                }
            }
            group("&Student")
            {
                Caption = '&Student';
                action("Edit Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Edit Details';
                    Image = EditCustomer;
                    RunObject = Page "ACA-Students Card";
                    RunPageLink = "No."=field("No.");
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = LedgerEntries;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Visible = false;
                    action("Issued &Reminders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Reminders';
                        RunObject = Page "Issued Reminder";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Customer No.","Posting Date");
                        Visible = false;
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Finance Charge Memos';
                        RunObject = Page "Issued Finance Charge Memo";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Customer No.","Posting Date");
                        Visible = false;
                    }
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Customer),
                                  "No."=field("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(18),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Customer Bank Account Card";
                    RunPageLink = "Customer No."=field("No.");
                }
                action("Ship-&to Addresses")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-&to Addresses';
                    RunObject = Page "Ship-to Address";
                    RunPageLink = "Customer No."=field("No.");
                    Visible = false;
                }
                action("C&ontact")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ontact';
                    Image = ContactPerson;

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                separator(Action1000000027)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Statistics by C&urrencies")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics by C&urrencies';
                    Enabled = false;
                    RunObject = Page "Dimension Set ID Filter";
                    RunPageLink = Code=field("No."),
                                  Field56=field("Global Dimension 1 Filter"),
                                  Field57=field("Global Dimension 2 Filter"),
                                  Field55=field("Date Filter");
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    Visible = false;
                }
                separator(Action1000000023)
                {
                    Caption = '';
                }
                separator(Action1000000022)
                {
                    Caption = '';
                }
                action("Ser&vice Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Customer Service Contracts";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.","Ship-to Code");
                    Visible = false;
                }
                action("Service &Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Items';
                    RunObject = Page "Service Items";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.","Ship-to Code","Item No.","Serial No.");
                    Visible = false;
                }
                separator(Action1000000019)
                {
                }
                action("&Jobs")
                {
                    ApplicationArea = Basic;
                    Caption = '&Jobs';
                    RunObject = Page "Job Card";
                    RunPageLink = "Bill-to Customer No."=field("No.");
                    RunPageView = sorting("Bill-to Customer No.");
                    Visible = false;
                }
                separator(Action1000000017)
                {
                }
            }
            group("&Transact")
            {
                Caption = '&Transact';
                action(Receipting)
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipting';
                    Image = Receipt;
                    RunObject = Page "ACA-Student Payments Form";
                    RunPageLink = "Student No."=field("No.");
                    ShortCutKey = 'F9';
                }
                action(Billing)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing';
                    Image = VendorBill;
                    RunObject = Page "ACA-Students Card";
                    RunPageLink = "No."=field("No.");
                }
            }
        }
        area(processing)
        {
            action("Catering Funds Transfers")
            {
                ApplicationArea = Basic;
                Caption = 'Catering Funds Transfers';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "ACA-Catering Funds Transfer";
                RunPageLink = "Student No"=field("No.");
            }
            action("Make Payment")
            {
                ApplicationArea = Basic;
                Caption = 'Make Payment';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //BILLING
                    AccPayment:=false;
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.","No.");
                    StudentCharges.SetRange(StudentCharges.Recognized,false);
                    StudentCharges.SetFilter(StudentCharges.Code,'<>%1','') ;
                    if StudentCharges.Find('-') then begin
                    if not Confirm('Un-billed charges will be posted. Do you wish to continue?',false) = true then
                     Error('You have selected to Abort Student Billing');
                    
                    
                    SettlementType:='';
                    CReg.Reset;
                    CReg.SetFilter(CReg."Settlement Type",'<>%1','');
                    CReg.SetRange(CReg."Student No.","No.");
                    if CReg.Find('-') then
                    SettlementType:=CReg."Settlement Type"
                    else
                    Error('The Settlement Type Does not Exists in the Course Registration');
                    
                    SettlementTypes.Get(SettlementType);
                    SettlementTypes.TestField(SettlementTypes."Tuition G/L Account");
                    
                    
                    
                    
                    // MANUAL APPLICATION OF ACCOMODATION FOR PREPAYED STUDENTS BY BKK...//
                    if StudentCharges.Count=1 then begin
                    CalcFields(Balance);
                    if Balance<0 then begin
                    if Abs(Balance)>StudentCharges.Amount then begin
                    "Application Method":="application method"::Manual;
                    AccPayment:=true;
                    Modify;
                    end;
                    end;
                    end;
                    
                    end;
                    
                    
                    //ERROR('TESTING '+FORMAT("Application Method"));
                    
                    if Cust.Get("No.") then;
                    
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;
                    
                    GenSetUp.Get();
                    //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
                    
                    //Charge Student if not charged
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.","No.");
                    StudentCharges.SetRange(StudentCharges.Recognized,false);
                    if StudentCharges.Find('-') then begin
                    
                    repeat
                    if StudentCharges.Amount<>0 then begin
                    DueDate:=StudentCharges.Date;
                    if Sems.Get(StudentCharges.Semester) then begin
                    if Sems.From<>0D then begin
                    if Sems.From > DueDate then
                    DueDate:=Sems.From;
                    end;
                    end;
                    
                    
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=StudentCharges."Transacton ID";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    //
                    if Cust.Get("No.") then begin
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Account No.":="No.";
                    end;
                    
                    GenJnl.Amount:=StudentCharges.Amount;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=CopyStr(StudentCharges.Description,1,50);
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
                    
                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                       (StudentCharges.Charge = false) then begin
                    GenJnl."Bal. Account No.":=SettlementTypes."Tuition G/L Account";
                    
                    CReg.Reset;
                    CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                    CReg.SetRange(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
                    CReg.SetRange(CReg."Student No.",StudentCharges."Student No.");
                    if CReg.Find('-') then begin
                    if CReg."Register for"=CReg."register for"::Stage then begin
                    Stages.Reset;
                    Stages.SetRange(Stages."Programme Code",CReg.Programme);
                    Stages.SetRange(Stages.Code,CReg.Stage);
                    if Stages.Find('-') then begin
                    if (Stages."Modules Registration" = true) and (Stages."Ignore No. Of Units"= false) then begin
                    CReg.CalcFields(CReg."Units Taken");
                    if CReg. Modules <> CReg."Units Taken" then
                    Error('Units Taken must be equal to the no of modules registered for.');
                    
                    end;
                    end;
                    end;
                    
                    CReg.Posted:=true;
                    CReg.Modify;
                    end;
                    
                    
                    end else if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                                (StudentCharges.Charge = false) then begin
                    //GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";
                    StudentCharges.CalcFields(StudentCharges."Settlement Type");
                    GenJnl."Bal. Account No.":=SettlementTypes."Tuition G/L Account";
                    
                    
                    CReg.Reset;
                    CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                    CReg.SetRange(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
                    if CReg.Find('-') then begin
                    CReg.Posted:=true;
                    CReg.Modify;
                    end;
                    
                    
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Exam Fees" then begin
                    if ExamsByStage.Get(StudentCharges.Programme,StudentCharges.Stage,StudentCharges.Semester,StudentCharges.Code) then
                    GenJnl."Bal. Account No.":=ExamsByStage."G/L Account";
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Exam Fees" then begin
                    if ExamsByUnit.Get(StudentCharges.Programme,StudentCharges.Stage,ExamsByUnit."Unit Code",StudentCharges.Semester,
                    StudentCharges.Code) then
                    GenJnl."Bal. Account No.":=ExamsByUnit."G/L Account";
                    
                    end else if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                                (StudentCharges.Charge = true) then begin
                    if Charges.Get(StudentCharges.Code) then
                    GenJnl."Bal. Account No.":=Charges."G/L Account";
                    end;
                    
                    
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    if Prog.Get(StudentCharges.Programme) then begin
                    Prog.TestField(Prog."Department Code");
                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    end;
                    
                    
                    
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    GenJnl."Due Date":=DueDate;
                    GenJnl.Validate(GenJnl."Due Date");
                    if StudentCharges."Recovery Priority" <> 0 then
                    GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
                    else
                    GenJnl."Recovery Priority":=25;
                    GenJnl.Insert;
                    
                    //Distribute Money
                    if StudentCharges."Tuition Fee" = true then begin
                    if Stages.Get(StudentCharges.Programme,StudentCharges.Stage) then begin
                    if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                    Stages.TestField(Stages."Distribution Account");
                    StudentCharges.TestField(StudentCharges.Distribution);
                    if Cust.Get("No.") then begin
                    CustPostGroup.Get(Cust."Customer Posting Group");
                    
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=StudentCharges."Transacton ID";
                    //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
                    GenJnl."Account No.":=SettlementTypes."Tuition G/L Account";
                    GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Fee Distribution';
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    //GenJnl."Bal. Account No.":=Stages."Distribution Account";
                    
                    StudentCharges.CalcFields(StudentCharges."Settlement Type");
                    SettlementTypes.Get(StudentCharges."Settlement Type");
                    GenJnl."Bal. Account No.":=SettlementTypes."Tuition G/L Account";
                    
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    if Prog.Get(StudentCharges.Programme) then begin
                    Prog.TestField(Prog."Department Code");
                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    end;
                    
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    
                    GenJnl.Insert;
                    
                    end;
                    end;
                    end;
                    end else begin
                    //Distribute Charges
                    if StudentCharges.Distribution > 0 then begin
                    StudentCharges.TestField(StudentCharges."Distribution Account");
                    if Charges.Get(StudentCharges.Code) then begin
                    Charges.TestField(Charges."G/L Account");
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=StudentCharges."Transacton ID";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    GenJnl."Account No.":=StudentCharges."Distribution Account";
                    GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Fee Distribution';
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=Charges."G/L Account";
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    
                    if Prog.Get(StudentCharges.Programme) then begin
                    Prog.TestField(Prog."Department Code");
                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    GenJnl.Insert;
                    
                    end;
                    end;
                    end;
                    //End Distribution
                    
                    
                    StudentCharges.Recognized:=true;
                    StudentCharges.Modify;
                    //.......BY BKK
                    StudentCharges.Posted:=true;
                    StudentCharges.Modify;
                    
                    CReg.Posted:=true;
                    CReg.Modify;
                    
                    
                    //.....END BKK
                    end;
                    until StudentCharges.Next = 0;
                    
                    
                    /*
                    GenJnl.SETRANGE("Journal Template Name",'SALES');
                    GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
                    IF GenJnl.FIND('-') THEN BEGIN
                    REPEAT
                    GLPosting.RUN(GenJnl);
                    UNTIL GenJnl.NEXT = 0;
                    END;
                    
                    
                    GenJnl.RESET;
                    GenJnl.SETRANGE("Journal Template Name",'SALES');
                    GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
                    GenJnl.DELETEALL;
                    */
                    
                    //Post New
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
                    end;
                    
                    //Post New
                    
                    
                    "Application Method":="application method"::"Apply to Oldest";
                    Cust.Status:=Cust.Status::Current;
                    Cust.Modify;
                    
                    end;
                    
                    
                    //BILLING
                    
                    StudentPayments.Reset;
                    StudentPayments.SetRange(StudentPayments."Student No.","No.");
                    if StudentPayments.Find('-') then
                    StudentPayments.DeleteAll;
                    
                    
                    StudentPayments.Reset;
                    StudentPayments.SetRange(StudentPayments."Student No.","No.");
                    if AccPayment=true then begin
                     if Cust.Get("No.") then
                     Cust."Application Method":=Cust."application method"::"Apply to Oldest";
                     Cust. Modify;
                    end;
                    Page.Run(68788,StudentPayments);

                end;
            }
            action("Print Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Print Statement';
                Image = CustomerLedger;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;

                trigger OnAction()
                begin
                       Cust.Reset;
                      Cust.SetFilter(Cust."No.","No.") ;
                      if Cust.Find('-') then
                      Report.Run(51072,true,true,Cust);
                end;
            }
            action("NFM Statement")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Cust.Reset;
                    Cust.SetRange("No.",Rec."No.");
                    if Cust.FindFirst then
                    Report.Run(78092, true,false,Cust);
                end;
            }
            action("Simulate NFM Fees")
            {
                ApplicationArea = Basic;
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    WbPortal: Codeunit webportals;
                begin
                    Message('Debit Amount :: Credit Amount :: Balance '+WbPortal.GetFeesII("No."));
                end;
            }
            action(Picture)
            {
                ApplicationArea = Basic;
                Caption = 'Photo';
                Ellipsis = false;
                Image = Picture;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Student Picture";
                RunPageLink = "No."=field("No.");
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                group(SalesReports)
                {
                    Caption = 'Sales Reports';
                    Image = "Report";
                    action("Customer - Top 10 List")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - Top 10 List';
                        Image = "Report";
                        RunObject = Report "Customer - Top 10 List";
                        ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.';
                    }
                    action("Customer - Sales List")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - Sales List';
                        Image = "Report";
                        RunObject = Report "Customer - Sales List";
                        ToolTip = 'View customer sales in a period, for example, to report sales activity to customs and tax authorities.';
                    }
                    action("Sales Statistics")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Statistics';
                        Image = "Report";
                        RunObject = Report "Customer Sales Statistics";
                        ToolTip = 'View customers'' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.';
                    }
                }
                group(FinanceReports)
                {
                    Caption = 'Finance Reports';
                    Image = "Report";
                    action(Statement)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Statement';
                        Image = "Report";
                        RunObject = Codeunit "Customer Layout - Statement";
                        ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
                    }
                    action("Customer - Balance to Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - Balance to Date';
                        Image = "Report";
                        RunObject = Report "Customer - Balance to Date";
                        ToolTip = 'View, print, or save a customer''s balance on a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';
                    }
                    action("Customer - Trial Balance")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Trial Balance';
                        Image = "Report";
                        RunObject = Report "Customer - Trial Balance";
                        ToolTip = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.';
                    }
                    action("Customer - Detail Trial Bal.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - Detail Trial Bal.';
                        Image = "Report";
                        RunObject = Report "Customer - Detail Trial Bal.";
                        ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';
                    }
                    action("Customer - Summary Aging")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - Summary Aging';
                        Image = "Report";
                        RunObject = Report "Customer - Summary Aging Simp.";
                        ToolTip = 'View, print, or save a summary of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.';
                    }
                    action("<Household Reports>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Household Reports';
                        RunObject = Report "Houshold Balances";
                    }
                    action("Aged Accounts Receivable")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Aged Accounts Receivable';
                        Image = "Report";
                        RunObject = Report "Aged Accounts Receivable";
                        ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                    }
                    action("Customer - Payment Receipt")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Payment Receipt';
                        Image = "Report";
                        RunObject = Report "Customer - Payment Receipt";
                        ToolTip = 'View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.';
                    }
                }
            }
        }
    }

    var
        PictureExists: Boolean;
        StudentPayments: Record UnknownRecord61536;
        StudentCharges: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        ExamsByUnit: Record UnknownRecord61527;
        Charges: Record UnknownRecord61515;
        Receipt: Record UnknownRecord61538;
        ReceiptItems: Record UnknownRecord61539;
        GenSetUp: Record UnknownRecord61534;
        StudentCharges2: Record UnknownRecord61535;
        CourseReg: Record UnknownRecord61532;
        CurrentBill: Decimal;
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        PDate: Date;
        DocNo: Code[20];
        VendLedg: Record "Vendor Ledger Entry";
        DVendLedg: Record "Detailed Vendor Ledg. Entry";
        VATEntry: Record "VAT Entry";
        CReg: Record UnknownRecord61532;
        StudCharges: Record UnknownRecord61535;
        CustLed2: Record "Cust. Ledger Entry";
        Receipt2: Record UnknownRecord61538;
        Cont: Boolean;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CustLedg: Record "Cust. Ledger Entry";
        DueDate: Date;
        Sems: Record UnknownRecord61692;
        ChangeLog: Record "Change Log Entry";
        CurrentBal: Decimal;
        Prog: Record UnknownRecord61511;
        "Settlement Type": Record UnknownRecord61522;
        AccPayment: Boolean;
        SettlementType: Code[20];
        SettlementTypes: Record UnknownRecord61522;
        reportno: Code[20];


    procedure GetSelectionFilter(): Code[80]
    var
        Cust: Record Customer;
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Cust);
        CustCount := Cust.Count;
        if CustCount > 0 then begin
          Cust.Find('-');
          while CustCount > 0 do begin
            CustCount := CustCount - 1;
            Cust.MarkedOnly(false);
            FirstCust := Cust."No.";
            LastCust := FirstCust;
            More := (CustCount > 0);
            while More do
              if Cust.Next = 0 then
                More := false
              else
                if not Cust.Mark then
                  More := false
                else begin
                  LastCust := Cust."No.";
                  CustCount := CustCount - 1;
                  if CustCount = 0 then
                    More := false;
                end;
            if SelectionFilter <> '' then
              SelectionFilter := SelectionFilter + '|';
            if FirstCust = LastCust then
              SelectionFilter := SelectionFilter + FirstCust
            else
              SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
            if CustCount > 0 then begin
              Cust.MarkedOnly(true);
              Cust.Next;
            end;
          end;
        end;
        exit(SelectionFilter);
    end;


    procedure SetSelection(var Cust: Record Customer)
    begin
        CurrPage.SetSelectionFilter(Cust);
    end;


    procedure RunReport(ReportNumber: Integer;CustomerNumber: Code[20];reportno: Integer)
    var
        Customer: Record Customer;
    begin
        Cust.Reset;
        Cust.SetRange("No.",Rec."No.");
        if Cust.FindFirst then
        Report.Run(reportno, true,false,Cust);
    end;
}

