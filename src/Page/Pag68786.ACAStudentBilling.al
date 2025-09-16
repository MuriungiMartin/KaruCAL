#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68786 "ACA-Student Billing"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = Document;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student),
                            Blocked=const(" "));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.(*)';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payments By";"Payments By")
                {
                    ApplicationArea = Basic;
                }
                field("Membership No";"Membership No")
                {
                    ApplicationArea = Basic;
                }
                field(Citizenship;Citizenship)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("No Of Creidts";"No Of Creidts")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field(Religion;Religion)
                {
                    ApplicationArea = Basic;
                }
                field("Customer Posting Group";"Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group';
                }
                field(Blocked;Blocked)
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

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        /*
                        DtldCustLedgEntry.SETRANGE("Customer No.","No.");
                        COPYFILTER("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        COPYFILTER("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        */
                        Copyfilter("Currency Filter",DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);

                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Method";"Application Method")
                {
                    ApplicationArea = Basic;
                }
                field("In Current Sem";"In Current Sem")
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
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Telex No.";"Telex No.")
                {
                    ApplicationArea = Basic;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Sponsor)
            {
                Caption = 'Sponsor';
                Editable = false;
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Application Method1";"Application Method")
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
                action("Tremester registration")
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
            group(ActionGroup1000000062)
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
                separator(Action1000000082)
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
                separator(Action1000000087)
                {
                    Caption = '';
                }
                separator(Action1000000089)
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
                separator(Action1000000092)
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
                separator(Action1000000094)
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
            action("Post Transfers")
            {
                ApplicationArea = Basic;
                Caption = 'Post Transfers';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;
                    
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.","No.");
                    StudentCharges.SetRange(StudentCharges.Transfered,false);
                    StudentCharges.SetRange(StudentCharges.Transfer,true);
                    if StudentCharges.Find('-') then begin
                    StudentCharges.TestField(StudentCharges."Transfer Amount");
                    StudentCharges.TestField(StudentCharges."Reg. Transaction ID");
                    if StudentCharges."Transfer Amount" > StudentCharges."Amount Paid" then
                    Error('Transfer amount cannot be greater than the amount paid.');
                    
                    GenSetUp.Get();
                    
                    Receipt.Init;
                    Receipt."Receipt No.":='';
                    Receipt.Validate(Receipt."Receipt No.");
                    Receipt."Student No.":="No.";
                    Receipt.Date:=Today;
                    Receipt."Payment Mode":=Receipt."payment mode"::PDQ;
                    Receipt.Amount:=StudentCharges."Transfer Amount";
                    Receipt."Payment By":='';
                    Receipt.Insert;
                    
                    Receipt.Reset;
                    Receipt.SetRange(Receipt."Student No.","No.");
                    if Receipt.Find('+') then begin
                    
                    repeat
                    
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=Receipt."Receipt No.";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    
                    if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                    if Stages.Get(StudentCharges.Programme,StudentCharges.Stage) then
                    GenJnl."Account No.":=Stages."G/L Account";
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                    if Units.Get(StudentCharges.Programme,StudentCharges.Stage,StudentCharges.Unit) then
                    GenJnl."Account No.":=Units."G/L Account";
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Exam Fees" then begin
                    if ExamsByStage.Get(StudentCharges.Programme,StudentCharges.Stage,StudentCharges.Semester,StudentCharges.Code) then
                    GenJnl."Account No.":=ExamsByStage."G/L Account";
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Exam Fees" then begin
                    if ExamsByUnit.Get(StudentCharges.Programme,StudentCharges.Stage,ExamsByUnit."Unit Code",StudentCharges.Semester,
                    StudentCharges.Code) then
                    GenJnl."Account No.":=ExamsByUnit."G/L Account";
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges then begin
                    if Charges.Get(StudentCharges.Code) then
                    GenJnl."Account No.":=Charges."G/L Account";
                    
                    end;
                    
                    GenJnl.Amount:=StudentCharges."Transfer Amount";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=StudentCharges.Description + '-' + 'Transfer';
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=GenSetUp."Defered Account";
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    
                    if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                    if Stages.Get(StudentCharges.Programme,StudentCharges.Stage) then begin
                    GenJnl."Shortcut Dimension 2 Code":=Stages.Department;
                    end;
                    
                    end else if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                    if Units.Get(StudentCharges.Programme,StudentCharges.Stage,StudentCharges.Unit) then begin
                    GenJnl."Shortcut Dimension 2 Code":=Units.Department;
                    end;
                    end;
                    
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    
                    
                    GenJnl.Insert;
                    
                    
                    
                    /*
                    //Transfer to new course
                    CourseReg.RESET;
                    CourseReg.SETRANGE(CourseReg."Reg. Transacton ID",StudentCharges."Reg. Transaction ID");
                    IF CourseReg.FIND('-') THEN BEGIN
                    */
                    StudentCharges2.Reset;
                    StudentCharges2.SetRange(StudentCharges2."Transacton ID",StudentCharges."Reg. Transaction ID");
                    if StudentCharges2.Find('-') then begin
                    
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=Receipt."Receipt No.";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    GenJnl."Account No.":=GenSetUp."Defered Account";
                    
                    GenJnl.Amount:=StudentCharges."Transfer Amount";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=StudentCharges.Description + '-' + 'Transfer';
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
                    
                    /*
                    IF CourseReg."Register for" = CourseReg."Register for"::Stage THEN BEGIN
                    IF Stages.GET(CourseReg.Programme,CourseReg.Stage) THEN
                    GenJnl."Bal. Account No.":=Stages."G/L Account";
                    
                    END ELSE IF CourseReg."Register for" = CourseReg."Register for"::"Unit/Subject" THEN BEGIN
                    IF Units.GET(CourseReg.Programme,CourseReg.Stage,CourseReg.Unit) THEN
                    GenJnl."Bal. Account No.":=Units."G/L Account";
                    
                    END;
                    */
                    
                    if StudentCharges2."Transaction Type" = StudentCharges2."transaction type"::"Stage Fees" then begin
                    if Stages.Get(StudentCharges2.Programme,StudentCharges2.Stage) then
                    GenJnl."Bal. Account No.":=Stages."G/L Account";
                    
                    end else if StudentCharges2."Transaction Type" = StudentCharges2."transaction type"::"Unit Fees" then begin
                    if Units.Get(StudentCharges2.Programme,StudentCharges2.Stage,StudentCharges2.Unit) then
                    GenJnl."Bal. Account No.":=Units."G/L Account";
                    
                    end;
                    
                    
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    if StudentCharges2."Transaction Type" = StudentCharges2."transaction type"::"Stage Fees" then begin
                    if Stages.Get(StudentCharges2.Programme,StudentCharges2.Stage) then begin
                    GenJnl."Shortcut Dimension 2 Code":=Stages.Department;
                    end;
                    
                    end else if StudentCharges2."Transaction Type" = StudentCharges2."transaction type"::"Unit Fees" then begin
                    if Units.Get(StudentCharges2.Programme,StudentCharges2.Stage,StudentCharges2.Unit) then begin
                    GenJnl."Shortcut Dimension 2 Code":=Units.Department;
                    end;
                    end;
                    
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    
                    
                    GenJnl.Insert;
                    
                    end;
                    
                    
                    StudentCharges.Transfered:=true;
                    StudentCharges.Modify;
                    
                    StudentCharges2.Reset;
                    StudentCharges2.SetRange(StudentCharges2."Transacton ID",StudentCharges."Reg. Transaction ID");
                    if StudentCharges2.Find('-') then begin
                    StudentCharges2."Amount Paid":=StudentCharges2."Amount Paid"+StudentCharges."Transfer Amount";
                    StudentCharges2.Modify;
                    end;
                    
                    until StudentCharges.Next = 0;
                    
                    end;
                    
                    //Post
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnl);
                    end;
                    
                    
                    end;

                end;
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
                    StudentCharges.SetRange(StudentCharges.Posted,false);
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
                    StudentCharges.SetRange(StudentCharges.Posted,false);
                    if StudentCharges.Find('-') then begin
                    
                    repeat
                    
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
                    GenJnl.Description:=StudentCharges.Description;
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
            action("Aged Accounts Receivable")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View, print, or save an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';

                trigger OnAction()
                begin
                    RunReport(Report::"Aged Accounts Receivable","No.");
                end;
            }
            action("Customer Labels")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Labels';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Create mailing labels with the customers'' names and addresses. The report can be used to send sales letters, for example.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Labels","No.");
                end;
            }
            action("Customer Account Detail")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Account Detail';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ToolTip = 'View the detailed account activity for each customer for any period of time. The report lists all activity with running account balances, or only open items or only closed items with totals of either. The report can also show the application of payments to invoices.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Account Detail","No.");
                end;
            }
            action("Cash Applied")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cash Applied';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View how the cash received from customers has been applied to documents. The report includes the number of the document and type of document to which the payment has been applied.';

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetRange("Customer No.","No.");
                    Report.Run(Report::"Cash Applied",true,true,CustLedgerEntry);
                end;
            }
            action("Open Customer Entries")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open Customer Entries';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ToolTip = 'View the aged remaining balances for each customer. Customer transactions are listed by date or due date.';

                trigger OnAction()
                begin
                    RunReport(Report::"Open Customer Entries","No.");
                end;
            }
            action("Customer/Item Statistics")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer/Item Statistics';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View statistics about what items have been purchased by which customers.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer/Item Statistics","No.");
                end;
            }
            action("Customer Jobs (Cost)")
            {
                ApplicationArea = Jobs;
                Caption = 'Customer Jobs (Cost)';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View jobs and job costs by customer. The report only includes jobs that are marked as completed.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Jobs (Cost)","No.");
                end;
            }
            action("Customer Jobs (Price)")
            {
                ApplicationArea = Jobs;
                Caption = 'Customer Jobs (Price)';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View jobs and job prices by customer. The report only includes jobs that are marked as completed.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Jobs (Price)","No.");
                end;
            }
            action("Report Statement")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Statement';
                Image = "Report";
                RunObject = Codeunit "Customer Layout - Statement";
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Total Billed","Total Paid");
        CurrentBill:="Total Billed"-"Total Paid";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Customer Type":="customer type"::Student;
        "Date Registered":=Today;
    end;

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
        SettlementTypes: Record UnknownRecord61522;
        AccPayment: Boolean;
        SettlementType: Code[20];


    procedure RunReport(ReportNumber: Integer;CustomerNumber: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("No.",CustomerNumber);
        Report.RunModal(ReportNumber,true,true,Customer);
    end;
}

