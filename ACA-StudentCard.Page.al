#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68751 "ACA-Student Card"
{
    Editable = true;
    PageType = Card;
    SaveValues = true;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student),
                            Status=filter(Registration|Current|Defered|Transferred),
                            Blocked=const(" "));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = true;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.(*)';
                    Editable = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name(*)';
                    Editable = false;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID No(*)';
                    Editable = false;
                }
                field("KNEC No";"KNEC No")
                {
                    ApplicationArea = Basic;
                    Caption = 'KCSE No';
                    Editable = false;
                }
                field("Passport No";"Passport No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Birth Cert";"Birth Cert")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Registered(*)';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if ("ID No" = '') and ("Passport No" = '') and ("KNEC No" = '') and ("Birth Cert" = '') then
                        Message('You must specify either ID No, Passport No, KNEC No OR Birth Cert. No');
                    end;
                }
                field("Accredited Centre no.";"Accredited Centre no.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payments By";"Payments By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("HELB No.";"HELB No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Religion;Religion)
                {
                    ApplicationArea = Basic;
                    Caption = 'Religion';
                    Editable = false;
                }
                field("Application Method";"Application Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Citizenship;Citizenship)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(District;District)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin

                        districtname:='';
                        districtrec.SetRange(districtrec.Code,District);
                        if districtrec.Find('-') then
                        districtname:=districtrec.Description;
                    end;
                }
                field(districtname;districtname)
                {
                    ApplicationArea = Basic;
                    Caption = 'District Name';
                    Editable = false;
                }
                field("Customer Posting Group";"Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group(*)';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if ("ID No" = '') and ("Passport No" = '') and ("KNEC No" = '') and ("Birth Cert" = '') then
                        Error('You must specify either ID No, Passport No, KNEC No OR Birth Cert. No');
                        
                        /*
                        IF (Address = '') THEN
                        ERROR('You must specify the student Adrress.');
                        
                        IF ("Phone No." = '') THEN
                        ERROR('You must specify the student Phone number.');
                        
                        IF  ("E-Mail" = '') THEN
                        ERROR('You must specify the student E-Mail adrress.');
                        */

                    end;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Lib Membership";"Lib Membership")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Can Use Library";"Can Use Library")
                {
                    ApplicationArea = Basic;
                    Caption = 'Exists in Library';
                    Editable = false;
                }
                field("Status Change Date";"Status Change Date")
                {
                    ApplicationArea = Basic;
                }
                field("Deferement Period";"Deferement Period")
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("Confirmed Ok";"Confirmed Ok")
                {
                    ApplicationArea = Basic;
                    Caption = 'Online Confirmed';
                }
                field(sms_Password;sms_Password)
                {
                    ApplicationArea = Basic;
                }
                field(Password;Password)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Programme Registration")
            {
                Caption = 'Programme Registration';
                part(Control1000000005;"ACA-Course Registration New")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Next Of Kin")
            {
                Caption = 'Next Of Kin';
                part(Control1000000020;"ACA-Student Kin")
                {
                    SubPageLink = "Student No"=field("No.");
                }
            }
            group("Sponsors Details")
            {
                Caption = 'Sponsors Details';
                part(Control1000000055;"ACA-Student Sponsors Details")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Education History")
            {
                Caption = 'Education History';
                part(Control1000000056;"ACA-Student Education History")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Disciplinary Details")
            {
                Caption = 'Disciplinary Details';
                part(Control1000000057;"ACA-Student Disciplinary Det.")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Course Registration")
            {
                Caption = 'Course Registration';
                part(Control1102760002;"ACA-Student Units")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Units Booking")
            {
                Caption = 'Units Booking';
            }
            group(Exemptions)
            {
                Caption = 'Exemptions';
                part(Control1102760003;"ACA-Std Units Exemptions")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Contact Details")
            {
                Caption = 'Contact Details';
                Editable = true;
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Guardian/Sponsor Address';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postal Code/City';
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
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Graduation Details")
            {
                Caption = 'Graduation Details';
                Editable = true;
                field("Gown 1";"Gown 1")
                {
                    ApplicationArea = Basic;
                }
                field("Gown 2";"Gown 2")
                {
                    ApplicationArea = Basic;
                }
                field("Gown 3";"Gown 3")
                {
                    ApplicationArea = Basic;
                }
                field("Gown Status";"Gown Status")
                {
                    ApplicationArea = Basic;
                }
                field("Date Issued";"Date Issued")
                {
                    ApplicationArea = Basic;
                }
                field("Date Returned";"Date Returned")
                {
                    ApplicationArea = Basic;
                }
                field("Certificate Status";"Certificate Status")
                {
                    ApplicationArea = Basic;
                }
                field("Date Collected";"Date Collected")
                {
                    ApplicationArea = Basic;
                }
                field("Certificate No.";"Certificate No.")
                {
                    ApplicationArea = Basic;
                }
                field("ID Card Expiry Year";"ID Card Expiry Year")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                Editable = true;
                field("Transfer to No.";"Transfer to No.")
                {
                    ApplicationArea = Basic;
                }
                field("Barcode Picture";"Barcode Picture")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer to";"Transfer to")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1000000004)
            {
                Caption = 'Barcode';
                field(Barcode;"Barcode Picture")
                {
                    ApplicationArea = Basic;
                    Caption = 'Barcode';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Student)
            {
                Caption = 'Student';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Customer),
                                  "No."=field("No.");
                }
                action("Registration Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registration Details';
                    RunObject = Page "ACA-Student Registration";
                    RunPageLink = "No."=field("No.");
                }
                separator(Action1102760026)
                {
                }
                action(Register)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CalcFields("Balance (LCY)");
                        if "Balance (LCY)" > 0 then
                        //ERROR('You cannot register a student with a balance.');



                        CourseReg.Reset;
                        CourseReg.SetRange(CourseReg."Student No.","No.");
                        if CourseReg.Find('+') then begin
                        CourseReg.Registered:=true;
                        CourseReg.Modify;
                        end;
                    end;
                }
                action("De-Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'De-Register';

                    trigger OnAction()
                    begin
                        CourseReg.Reset;
                        CourseReg.SetRange(CourseReg."Student No.","No.");
                        if CourseReg.Find('+') then begin
                        CourseReg.Registered:=false;
                        CourseReg.Modify;
                        end;
                    end;
                }
                separator(Action1102760025)
                {
                }
                action("Mark As Alluminae")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark As Alluminae';

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to mark this students as an alluminae?',true) = true then begin
                        Status:=Status::Alumni;
                        Modify;
                        end;
                    end;
                }
                separator(Action1102760001)
                {
                }
            }
        }
        area(processing)
        {
            action("Student ID Card")
            {
                ApplicationArea = Basic;
                Caption = 'Student ID Card';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Stud.Reset;
                    Stud.SetRange(Stud."No.","No.");
                    if Stud.Find('+') then begin
                    Report.Run(39006250,true,false,Stud);
                    //REPORT.RUN(39006253,TRUE,FALSE,CourseReg);
                    end;
                end;
            }
            action("Transfer Student Accounts")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Student Accounts';
                Image = TransferFunds;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TestField("Transfer to No.");
                    TestField("Transfer to");
                    CalcFields("Balance (LCY)");
                    if not Cust.Get("Transfer to No.") then begin
                    Cust.Init;
                    Cust."No.":="Transfer to No.";
                    Cust.Name:=Name;
                    Cust.Validate(Cust.Name);
                    Cust."Global Dimension 1 Code":="Global Dimension 1 Code";
                    Cust."Customer Posting Group":="Customer Posting Group";
                    Cust."Application Method":=Cust."application method"::"Apply to Oldest";
                    Cust.Status:=Cust.Status::Current;
                    Cust."Customer Type":=Cust."customer type"::Student;
                    Cust."Date Registered":="Date Registered";
                    Cust.Insert(true);
                    end;
                    
                    
                    
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;
                    
                    
                    
                    CustL.Reset;
                    CustL.SetRange(CustL."Customer No.","No.");
                    if CustL.Find('-') then begin
                    repeat
                    CustL.CalcFields(CustL.Amount);
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=CustL."Posting Date";
                    GenJnl."Document No.":=CustL."Document No.";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":="No.";
                    GenJnl.Amount:=CustL.Amount*-1;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=CustL.Description;
                    //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::Customer;
                    //GenJnl."Bal. Account No.":="Transfer to No.";
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    /*
                    CReg.RESET;
                    CReg.SETRANGE(CReg."Student No.","No.");
                    IF CReg.FIND('+') THEN BEGIN
                    */
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;
                    
                    
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=CustL."Posting Date";
                    GenJnl."Document No.":=CustL."Document No.";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":="Transfer to No.";
                    GenJnl.Amount:=CustL.Amount;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=CustL.Description;
                    //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::Customer;
                    //GenJnl."Bal. Account No.":="Transfer to No.";
                    //GenJnl.VALIDATE(GenJnl."Bal. Account No.");
                    //GenJnl."Shortcut Dimension 2 Code":="Transfer to";
                    //GenJnl.VALIDATE(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;
                    
                    until CustL.Next=0;
                    end;
                    
                    Receipts.Reset;
                    Receipts.SetRange(Receipts."Student No.","No.");
                    Receipts.SetRange(Receipts.Reversed,false);
                    if Receipts.Find('-') then begin
                    repeat
                    Receipts."Student No.":="Transfer to No.";
                    Receipts.Modify;
                    until Receipts.Next=0;
                    end;
                    
                    
                    
                    //Post
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnl);
                    end;
                    
                    
                    
                    Status:=Status::Transferred;
                    Blocked:=Blocked::All;
                    Modify;
                    
                    
                    
                    Message('%1','Student transferred successfully.');

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Customer Type":="customer type"::Student;
        "Date Registered":=Today;
        "Customer Posting Group":='Student';
        "Global Dimension 1 Code":='ACADEMIC';
        "Application Method":="application method"::"Apply to Oldest";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //IF Name = '' THEN
        //ERROR('You must finish entry of the record.');;
        OnAfterGetCurrRecord;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if Name = '' then
;

    var
        EducationHistory: Record UnknownRecord61529;
        EnrollmentEducationHistory: Record UnknownRecord61355;
        StudentGuardian: Record UnknownRecord61530;
        EnrollmentGuardian: Record UnknownRecord61353;
        StudentKin: Record UnknownRecord61528;
        EnrollmentNextofKin: Record UnknownRecord61352;
        CourseRegistration: Record UnknownRecord61532;
        Enrollment: Record UnknownRecord61348;
        PictureExists: Boolean;
        StudentRec: Record Customer;
        CourseReg: Record UnknownRecord61532;
        districtname: Text[50];
        districtrec: Record UnknownRecord61365;
        Cust: Record Customer;
        GenJnl: Record "Gen. Journal Line";
        PDate: Date;
        CReg: Record UnknownRecord61532;
        Prog: Record UnknownRecord61511;
        TransInv: Boolean;
        TransRec: Boolean;
        Receipts: Record UnknownRecord61538;
        CustL: Record "Cust. Ledger Entry";
        Stud: Record Customer;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        districtname:='';
        districtrec.SetRange(districtrec.Code,District);
        if districtrec.Find('-') then
        districtname:=districtrec.Description;
    end;
}

