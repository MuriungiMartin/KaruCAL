#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51539 "Post Billing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Post Billing.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Semester,Stage,"System Created",Programme;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bill_StudentsCaption;Bill_StudentsCaptionLbl)
            {
            }
            column(Customer__No__Caption;Customer.FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;Customer.FieldCaption(Name))
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=field("Student No.");
                DataItemTableView = sorting("No.") where(Blocked=filter(" "));
                column(ReportForNavId_6836; 6836)
                {
                }
                column(Customer__No__;"No.")
                {
                }
                column(Customer_Name;Name)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    
                    //Billing
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;
                    
                    // "Settlement Type".GET("ACA-Course Registration"."Settlement Type");
                    // "Settlement Type".TESTFIELD("Settlement Type"."Tuition G/L Account");
                    
                    
                    
                    GenSetUp.Get();
                    GenSetUp.TestField(GenSetUp."Pre-Payment Account");
                    
                    //Charge Student if not charged
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.","No.");
                    StudentCharges.SetRange(StudentCharges.Recognized,false);
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
                    Clear(Cust);
                    Cust.Reset;
                    if Cust.Get("No.") then begin
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Account No.":="No.";
                    end;
                    
                    GenJnl.Amount:=StudentCharges.Amount;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=StudentCharges.Description+' '+StudentCharges.Semester;
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
                    
                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                       (StudentCharges.Charge = false) then begin
                    //StudentCharges.CALCFIELDS(StudentCharges."Settlement Type");
                    
                    //GenJnl."Bal. Account No.":="Settlement Type"."Tuition G/L Account";
                    
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
                    
                    GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account"
                    end else if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                                (StudentCharges.Charge = false) then begin
                    GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";
                    
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
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    
                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    GenJnl."Due Date":=DueDate;
                    GenJnl.Validate(GenJnl."Due Date");
                    if StudentCharges."Recovery Priority" <> 0 then
                    GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
                    else
                    GenJnl."Recovery Priority":=25;
                    //IF GenJnl."Bal. Account No." = '' THEN ERROR(GenJnl."Account No."+', Doc. '+GenJnl."Document No."+', No. 1');
                    if GenJnl.Amount>0 then
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
                    GenJnl."Posting Date":=Today;//StudentCharges.Date;
                    GenJnl."Document No.":=StudentCharges."Transacton ID";
                    //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
                    //IF "Settlement Type".GET(StudentCharges."Settlement Type") THEN
                    //GenJnl."Account No.":="Settlement Type"."Tuition G/L Account";
                    
                    GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Fee Distribution';
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=Stages."Distribution Account";
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount>0 then
                    //IF GenJnl."Bal. Account No." = '' THEN ERROR(GenJnl."Account No."+', Doc. '+GenJnl."Document No."+', No. 2');
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
                    GenJnl."Posting Date":=StudentCharges.Date;
                    GenJnl."Document No.":=StudentCharges."Transacton ID";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    //if "Settlement Type".get()
                    GenJnl."Account No.":=StudentCharges."Distribution Account";
                    GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Fee Distribution';
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=Charges."G/L Account";
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    
                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    
                    //IF GenJnl."Bal. Account No." = '' THEN ERROR(GenJnl."Account No."+', Doc. '+GenJnl."Document No."+', No. 3');
                    if GenJnl.Amount>0 then
                    GenJnl.Insert;
                    
                    end;
                    end;
                    end;
                    //End Distribution
                    
                    
                    StudentCharges.Recognized:=true;
                    StudentCharges.Modify;
                    
                    until StudentCharges.Next = 0;
                    
                    
                    /*
                    GenJnl.SETRANGE("Journal Template Name",'SALES');
                    GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
                    IF GenJnl.FIND('-') THEN BEGIN
                    REPEAT
                    GLPosting.RUN(GenJnl);
                    UNTIL GenJnl.NEXT = 0;
                    END;
                    
                    //Billing
                    
                    
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
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post B",GenJnl);
                    end;
                    
                    //Post New
                    Cust.CalcFields(Balance);
                    if Cust.Status=Cust.Status::"New Admission" then begin
                    if ((Cust.Balance=0) or (Cust.Balance<0)) then begin
                    Cust.Status:=Cust.Status::Current;
                    end else begin
                    Cust.Status:=Cust.Status::"New Admission";
                    end;
                    end else begin
                    Cust.Status:=Cust.Status::Current;
                    end;
                    Cust.Modify;
                    
                    end;
                    
                    
                    //BILLING
                    
                    
                    
                    /* MADE FOR FEE STRACTURE CORRECTION
                    GenJnl.INIT;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=TODAY;
                    GenJnl."Document No.":='Tution Correction';
                    //GenJnl."Document Type":=0;
                    GenJnl.VALIDATE(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='General';
                    GenJnl."Journal Batch Name":='BAL CORR';
                    GenJnl."Account Type":=GenJnl."Account Type"::Customer;
                    //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
                    //IF "Settlement Type".GET(StudentCharges."Settlement Type") THEN
                    GenJnl."Account No.":=Customer."No.";
                    
                    GenJnl.Amount:=-5000;
                    GenJnl.VALIDATE(GenJnl."Account No.");
                    GenJnl.VALIDATE(GenJnl.Amount);
                    GenJnl.Description:="Course Registration".Stage+' Billing Correction';
                    GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                    //IF "Settlement Type".GET(StudentCharges."Settlement Type") THEN
                    
                    GenJnl."Bal. Account No.":='300003';
                    GenJnl.VALIDATE(GenJnl."Bal. Account No.");
                    IF StudentCharges."Transaction Type" = StudentCharges."Transaction Type"::"Stage Fees" THEN BEGIN
                    IF Stages.GET(StudentCharges.Programme,StudentCharges.Stage) THEN BEGIN
                    GenJnl."Shortcut Dimension 2 Code":=Stages.Department;
                    END;
                    
                    END ELSE IF StudentCharges."Transaction Type" = StudentCharges."Transaction Type"::"Unit Fees" THEN BEGIN
                    IF Units.GET(StudentCharges.Programme,StudentCharges.Stage,StudentCharges.Unit) THEN BEGIN
                    Units.TESTFIELD(Units.Department);
                    GenJnl."Shortcut Dimension 2 Code":=Units.Department;
                    END;
                    END;
                    GenJnl.VALIDATE(GenJnl."Shortcut Dimension 2 Code");
                    //IF GenJnl.Amount>0 THEN
                    GenJnl.INSERT;
                    */
                    StudHost.Reset;
                    StudHost.SetRange(StudHost.Student,Customer."No.");
                    StudHost.SetRange(StudHost.Billed,false);
                    if StudHost.Find('-') then begin
                    repeat
                    StudHost.Billed:=true;
                    StudHost."Billed Date":=Today;
                    until StudHost.Next=0;
                    end;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                   if Prog.Get("ACA-Course Registration".Programme) then
                   Prog.TestField(Prog."Department Code");
                   if Cust.Get("ACA-Course Registration"."Student No.") then
;
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

    var
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
        "Settlement Type": Record UnknownRecord61522;
        Prog: Record UnknownRecord61511;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bill_StudentsCaptionLbl: label 'Bill Students';
        StudHost: Record "ACA-Students Hostel Rooms";
}

