#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68788 "ACA-Student Payments Form"
{
    PageType = Card;
    SourceTable = UnknownTable61536;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Mode";"Payment Mode")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        "Transaction Date":=Today;
                        ApplicationEnable :=true;

                        if "Payment Mode"<>"payment mode"::Cash then
                        "Amount to payEnable" :=false;

                        if (("Payment Mode"="payment mode"::"Banker's Cheque") or ("Payment Mode"="payment mode"::"Bank Slip") or
                        ("Payment Mode"="payment mode"::Cheque) or ("Payment Mode"="payment mode"::"Money Order") or
                        ("Payment Mode"="payment mode"::Cash)) or ("Payment Mode"="payment mode"::"Direct Bank Deposit")then begin
                        "Cheque NoEnable" :=true;
                        "Drawer NameEnable" :=true;
                        //CurrForm."Drawer's Bank".ENABLED:=TRUE;
                        //CurrForm."Drawer's Branch Code".ENABLED:=TRUE;
                        "Bank No.Enable" :=true;
                        "Amount to payEnable" :=true;
                        "Bank Slip DateEnable" :=true;
                        "Unref. Entry No.Enable" :=false;

                        if BankRec.Get("Bank No.") then
                        "Drawer Name":=BankRec.Contact;

                        end else begin

                        "Cheque NoEnable" :=false;
                        "Drawer NameEnable" :=false;
                        //CurrForm."Drawer's Bank".ENABLED:=FALSE;
                        //CurrForm."Drawer's Branch Code".ENABLED:=FALSE;
                        //CurrForm."Bank No.".ENABLED:=FALSE;
                        "Amount to payEnable" :=false;
                        "Bank Slip DateEnable" :=false;
                        "Unref. Entry No.Enable" :=false;
                        "Staff Invoice No.Enable" :=false;
                        "Staff DescriptionEnable" :=false;


                        end;

                        if "Payment Mode"="payment mode"::Unreferenced then begin
                        "Bank No.Enable" :=false;
                        "Unref. Entry No.Enable" :=true;
                        "Bank No.":='';
                        ApplicationEnable :=false;

                        end;


                        if "Payment Mode" = "payment mode"::"Staff Invoice" then
                        "Amount to payEnable" :=true;

                        if "Payment Mode"="payment mode"::"Money Order" then
                        "Bank No.":='BFS';



                        if "Payment Mode"="payment mode"::"Applies to Overpayment" then begin
                        "Applies to Doc NoEnable" :=false;
                        "Apply to OverpaymentEnable" :=true;
                        end else
                        "Apply to OverpaymentEnable" :=false;

                        if "Payment Mode"="payment mode"::"Staff Invoice" then begin
                        "Staff Invoice No.Enable" :=true;
                        "Staff DescriptionEnable" :=true;
                        "Bank No.Enable" :=false;
                        "Bank No.Enable" :=false;
                        "Amount to payEnable" :=false;
                        end else begin
                        "Bank No.Enable" :=true;
                        "Bank No.Enable" :=true;
                        "Amount to payEnable" :=true;

                        end;

                        if "Payment Mode"="payment mode"::Weiver then begin
                        "Bank No.Enable" :=false;
                        "Bank No.Enable" :=false;
                        "Amount to payEnable" :=true;
                        "Payment ByEnable" :=true;
                        end;
                        if (("Payment Mode"="payment mode"::CDF) or ("Payment Mode"="payment mode"::HELB)) then begin
                        "Bank No.Enable" :=false;
                        "Bank No.Enable" :=false;
                        "Amount to payEnable" :=true;
                        "Payment ByEnable" :=true;
                        "CDF AccountEnable" :=true;
                        "CDF DescriptionEnable" :=true;
                        end;
                    end;
                }
                field("Cheque No";"Cheque No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Slip/Cheque No.';
                    Enabled = "Cheque NoEnable";
                }
                field("Amount to pay";"Amount to pay")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Slip Date";"Bank Slip Date")
                {
                    ApplicationArea = Basic;
                    Enabled = "Bank Slip DateEnable";
                }
                field("Bank No.";"Bank No.")
                {
                    ApplicationArea = Basic;
                }
                field("Payment By";"Payment By")
                {
                    ApplicationArea = Basic;
                    Enabled = "Payment ByEnable";
                }
                field("Drawer Name";"Drawer Name")
                {
                    ApplicationArea = Basic;
                    Enabled = "Drawer NameEnable";
                }
                field("CDF Account";"CDF Account")
                {
                    ApplicationArea = Basic;
                    Enabled = "CDF AccountEnable";
                }
                field("CDF Description";"CDF Description")
                {
                    ApplicationArea = Basic;
                    Enabled = "CDF DescriptionEnable";
                }
                field("Staff Invoice No.";"Staff Invoice No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = "Staff Invoice No.Enable";
                }
                field("Staff Description";"Staff Description")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = "Staff DescriptionEnable";
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Over Paid Amount";"Over Paid Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pre-paid Amount';
                    Editable = false;
                }
                field(TempBalance;TempBalance)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Applies to Doc No";"Applies to Doc No")
                {
                    ApplicationArea = Basic;
                    Enabled = "Applies to Doc NoEnable";
                }
                field("Apply to Overpayment";"Apply to Overpayment")
                {
                    ApplicationArea = Basic;
                    Enabled = "Apply to OverpaymentEnable";
                }
                field("Unref. Entry No.";"Unref. Entry No.")
                {
                    ApplicationArea = Basic;
                    Enabled = "Unref. Entry No.Enable";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action(Posts)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F2';

                trigger OnAction()
                begin
                    Validate("Cheque No");
                    if Posted then Error('Already Posted');
                    TestField("Transaction Date");

                    if Confirm('Do you want to post the transaction?',true) = false then begin
                    exit;
                    end;

                    if (("Payment Mode"="payment mode"::"Bank Slip") or ("Payment Mode"="payment mode"::Cheque)) then begin
                    TestField("Bank Slip Date");
                    TestField("Bank No.");
                    end;
                    CustLedg.Reset;
                    CustLedg.SetRange(CustLedg."Customer No.","Student No.");
                    //CustLedg.SETRANGE(CustLedg."Apply to",TRUE);
                    CustLedg.SetRange(CustLedg.Open,true);
                    CustLedg.SetRange(CustLedg.Reversed,false);
                    if CustLedg.Find('-') then begin
                    repeat
                    TotalApplied:=TotalApplied+CustLedg."Amount Applied";
                    until CustLedg.Next = 0;
                    end;

                    if "Amount to pay" > TotalApplied then begin
                    if Confirm('There is an overpayment. Do you want to continue?',false) = false then begin
                    exit;
                    end;

                    end;


                    if Cust.Get("Student No.") then begin
                    Cust."Application Method":=Cust."application method"::"Apply to Oldest";
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

                    if Cust.Get("Student No.") then

                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;

                    GenSetUp.Get();


                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;

                    GenSetUp.TestField(GenSetUp."Pre-Payment Account");



                    //Charge Student if not charged
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.","Student No.");
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
                    GenJnl."Document No.":=Rec."Cheque No";//StudentCharges."Transacton ID";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    //
                    if Cust.Get("Student No.") then begin
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Account No.":="Student No.";
                    end;

                    GenJnl.Amount:=StudentCharges.Amount;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=StudentCharges.Description;
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";

                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                       (StudentCharges.Charge = false) then begin
                    GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";

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

                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    if cust2.Get("Student No.") then;
                    if cust2."Global Dimension 2 Code"  = '' then
                      cust2."Global Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    if cust2."Global Dimension 2 Code"<>'' then begin

                    GenJnl."Shortcut Dimension 2 Code":=cust2."Global Dimension 2 Code"
                    end
                    else
                      GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                      if cust2."Global Dimension 2 Code" = ''   then
                       Error('Department code is missing!')

                    //else
                    //GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");


                    GenJnl."Due Date":=DueDate;
                    GenJnl.Validate(GenJnl."Due Date");
                    if StudentCharges."Recovery Priority" <> 0 then
                    GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
                    else
                    GenJnl."Recovery Priority":=25;
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;

                    //Distribute Money
                    if StudentCharges."Tuition Fee" = true then begin
                    if Stages.Get(StudentCharges.Programme,StudentCharges.Stage) then begin
                    if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                    Stages.TestField(Stages."Distribution Account");
                    StudentCharges.TestField(StudentCharges.Distribution);
                    if Cust.Get("Student No.") then begin
                    CustPostGroup.Get(Cust."Customer Posting Group");

                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=Rec."Cheque No";//StudentCharges."Transacton ID";
                    //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    GenSetUp.TestField(GenSetUp."Pre-Payment Account");
                    GenJnl."Account No.":=GenSetUp."Pre-Payment Account";
                    GenJnl.Amount:=StudentCharges.Amount * (StudentCharges.Distribution/100);
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Fee Distribution';
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=Stages."Distribution Account";
                    GenJnl.Validate(GenJnl."Bal. Account No.");

                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
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
                    GenJnl."Document No.":=Rec."Cheque No";//StudentCharges."Transacton ID";
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

                    //Stages.TESTFIELD(Stages.Department);
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;

                    end;
                    end;
                    end;
                    //End Distribution


                    StudentCharges.Recognized:=true;
                    StudentCharges.Modify;

                    until StudentCharges.Next = 0;



                    //Post New
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2",GenJnl);
                    end;

                    //Post New



                    end;


                    //BILLING

                    "Last No":='';
                    "No. Series Line".Reset;
                     BankRec.Get("Bank No.");
                     BankRec.TestField(BankRec."Receipt No. Series");
                     "No. Series Line".SetRange("No. Series Line"."Series Code",BankRec."Receipt No. Series");
                     if "No. Series Line".Find('-')  then
                       begin

                          "Last No":=IncStr("No. Series Line"."Last No. Used");
                         "No. Series Line"."Last No. Used":=IncStr("No. Series Line"."Last No. Used");
                         "No. Series Line".Modify;
                        end;


                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;



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
                    //Cust.MODIFY;


                    if "Payment Mode"="payment mode"::"Applies to Overpayment" then
                    Error('Overpayment must be applied manualy.');


                    /////////////////////////////////////////////////////////////////////////////////
                    //Receive payments
                    if "Payment Mode"<>"payment mode"::"Applies to Overpayment" then begin

                    //Over Payment
                    TotalApplied:=0;

                    CustLedg.Reset;
                    CustLedg.SetRange(CustLedg."Customer No.","Student No.");
                    //CustLedg.SETRANGE(CustLedg."Apply to",TRUE);
                    CustLedg.SetRange(CustLedg.Open,true);
                    CustLedg.SetRange(CustLedg.Reversed,false);
                    if CustLedg.Find('-') then begin
                    repeat
                    TotalApplied:=TotalApplied+CustLedg."Amount Applied";
                    until CustLedg.Next = 0;
                    end;

                    CReg.Reset;
                    CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                    //CReg.SETRANGE(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
                    CReg.SetRange(CReg."Student No.","Student No.");
                    if CReg.Find('+') then
                    CourseReg:=CReg."Reg. Transacton ID";





                    Receipt.Init;
                    Receipt."Receipt No.":="Last No";
                    //Receipt.VALIDATE(Receipt."Receipt No.");
                    Receipt."Student No.":="Student No.";
                    Receipt.Date:="Transaction Date";
                    Receipt."KCA Rcpt No":="KCA Receipt No";
                    Receipt."Bank Slip Date":="Bank Slip Date";
                    Receipt."Bank Slip/Cheque No":="Cheque No";
                    Receipt.Validate("Bank Slip/Cheque No");
                    Receipt."Bank Account":="Bank No.";
                    if "Payment Mode"="payment mode"::"Bank Slip" then
                    Receipt."Payment Mode":=Receipt."payment mode"::"Bank Slip" else
                    if "Payment Mode"="payment mode"::Cheque then
                    Receipt."Payment Mode":=Receipt."payment mode"::Cheque else
                    if "Payment Mode"="payment mode"::Cash then
                    Receipt."Payment Mode":=Receipt."payment mode"::Cash else
                    Receipt."Payment Mode":="Payment Mode";
                    Receipt.Amount:="Amount to pay";
                    Receipt."Payment By":="Payment By";
                    Receipt."Transaction Date":=Today;
                    Receipt."Transaction Time":=Time;
                    Receipt."User ID":=UserId;
                    Receipt."Reg ID":=CourseReg;
                    Receipt.Insert;

                    Receipt.Reset;
                    if Receipt.Find('+') then begin


                    CustLedg.Reset;
                    CustLedg.SetRange(CustLedg."Customer No.","Student No.");
                    //CustLedg.SETRANGE(CustLedg."Apply to",TRUE);
                    CustLedg.SetRange(CustLedg.Open,true);
                    CustLedg.SetRange(CustLedg.Reversed,false);
                    if CustLedg.Find('-') then begin

                    GenSetUp.Get();


                    end;

                    end;

                    //Bank Entry
                    if BankRec.Get("Bank No.") then
                    BankName:=BankRec.Name;

                    if ("Payment Mode"<>"payment mode"::Unreferenced) and ("Payment Mode"<>"payment mode"::"Staff Invoice")
                    and ("Payment Mode"<>"payment mode"::Weiver) and ("Payment Mode"<>"payment mode"::CDF)
                    and ("Payment Mode"<>"payment mode"::HELB)then begin

                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Bank Slip Date";
                    GenJnl."Document No.":="Last No";
                    GenJnl."External Document No.":="Cheque No";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"Bank Account";
                    GenJnl."Account No.":="Bank No.";
                    GenJnl.Amount:="Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=Format("Payment Mode")+'-'+Format("Bank Slip Date")+'-'+BankName;
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::Customer;
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Bal. Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Bal. Account No.":="Student No.";


                    GenJnl.Validate(GenJnl."Bal. Account No.");

                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;
                    end;
                    if "Payment Mode"="payment mode"::Unreferenced then begin
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Bank Slip Date";
                    GenJnl."Document No.":="Last No";
                    GenJnl."External Document No.":="Drawer Name";
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":='UNREF';
                    GenJnl.Amount:="Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=Cust.Name;
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::Customer;
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Bal. Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Bal. Account No.":="Student No.";

                    GenJnl."Applies-to Doc. No.":="Unref Document No.";
                    GenJnl.Validate(GenJnl."Applies-to Doc. No.");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;

                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");


                    end;
                    // Tripple - T...Staff Invoice
                    if "Payment Mode"="payment mode"::"Staff Invoice" then begin
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Bank Slip Date";
                    GenJnl."Document No.":="Last No";
                    GenJnl."External Document No.":='';
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":="Student No.";
                    GenJnl.Amount:=-"Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Staff Invoice No. '+"Staff Invoice No.";
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    GenJnl."Bal. Account No.":='200012';

                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;


                    end;
                    // Tripple - T...CDF
                    if "Payment Mode"="payment mode"::CDF then begin
                    GenSetUp.TestField(GenSetUp."CDF Account");
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Bank Slip Date";
                    GenJnl."Document No.":="Last No";
                    GenJnl."External Document No.":='CDF';
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":="Student No.";
                    GenJnl.Amount:=-"Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:="CDF Description";
                    //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                    //GenJnl."Bal. Account No.":=;
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;

                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Bank Slip Date";
                    GenJnl."Document No.":="Last No";
                    GenJnl."External Document No.":='CDF';
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                    GenJnl."Account No.":=GenSetUp."CDF Account";
                    GenJnl.Amount:="Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:="Student No.";

                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    ProgrammeSetUp.TestField(ProgrammeSetUp."Department Code");
                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;


                    end;


                    if "Payment Mode"="payment mode"::HELB then begin
                    GenSetUp.TestField(GenSetUp."Helb Account");
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Bank Slip Date";
                    GenJnl."Document No.":="Last No";
                    GenJnl."External Document No.":='';
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":="Student No.";
                    GenJnl.Amount:=-"Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='HELB';
                    GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=GenSetUp."Helb Account";
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","Student No.");
                    CReg.SetRange(CReg.Reversed,false) ;
                    if CReg.Find('+') then begin
                    if ProgrammeSetUp.Get(CReg.Programme) then begin
                    GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                    end;
                    end;

                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;


                    end;

                    //Post

                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin

                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2",GenJnl);
                    Modify;
                    end;

                    // Hostel Allocations
                    StudHostel.Reset;
                    StudHostel.SetRange(StudHostel.Student,"Student No.");
                    StudHostel.SetRange(StudHostel.Billed,false);
                    if StudHostel.Find('-') then begin
                    StudHostel.Billed:=true;
                    StudHostel.Modify;
                    Receipts.Reset;
                    if Receipts.Get("Last No") then begin
                    Receipts."Room No":=StudHostel."Space No";
                    Receipts.Modify;
                    end;

                    HostLedg.Reset;
                    HostLedg.SetRange(HostLedg."Space No",StudHostel."Space No");
                    HostLedg.SetRange(HostLedg."Hostel No",StudHostel."Hostel No");
                    if HostLedg.Find('-') then begin
                    HostLedg.Status:=HostLedg.Status::"Partially Occupied";
                    HostLedg.Modify;
                    end;
                    end;


                    CurrPage.Close;
                    Receipts.Reset;
                    Receipts.SetCurrentkey(Receipts."Receipt No.");
                    Receipts.SetRange(Receipts."Receipt No.","Last No");
                    if Receipts.Find('-') then
                    Report.Run(51524,false,false,Receipts);


                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //"Bank No.":='';

        if "Payment Mode"<>"payment mode"::Cash then
        "Amount to payEnable" :=false;

        if (("Payment Mode"="payment mode"::"Banker's Cheque") or ("Payment Mode"="payment mode"::"Bank Slip") or
        ("Payment Mode"="payment mode"::Cheque)) then begin
        "Cheque NoEnable" :=true;
        "Drawer NameEnable" :=true;
        //CurrForm."Drawer's Bank".ENABLED:=TRUE;
        //CurrForm."Drawer's Branch Code".ENABLED:=TRUE;
        "Bank No.Enable" :=true;
        "Amount to payEnable" :=true;
        "Bank Slip DateEnable" :=true;

        end else begin

        "Cheque NoEnable" :=false;
        "Drawer NameEnable" :=false;
        //CurrForm."Drawer's Bank".ENABLED:=FALSE;
        //CurrForm."Drawer's Branch Code".ENABLED:=FALSE;
        //CurrForm."Bank No.".ENABLED:=FALSE;
        "Amount to payEnable" :=false;

        end;


        if "Payment Mode"="payment mode"::Cash then
        "Amount to payEnable" :=true ;

        if "Payment Mode"="payment mode"::"Applies to Overpayment" then begin
        "Applies to Doc NoEnable" :=false;
        "Apply to OverpaymentEnable" :=true;
        end else
        "Apply to OverpaymentEnable" :=false;

        //"Payment Mode":="Payment Mode"::"Bank Slip";
        //VALIDATE("Payment Mode");
        //"Bank No.":='CONS SAVNG';
        "Transaction Date":=Today;

        "Cheque NoEnable" :=true;
        "Drawer NameEnable" :=true;
        "Bank No.Enable" :=true;
        "Amount to payEnable" :=true;
        "Bank Slip DateEnable" :=true;

        if "Payment Mode" = "payment mode"::Weiver then begin
        "Bank No.Enable" :=false;
        "Amount to payEnable" :=true;
        "Bank Slip DateEnable" :=true;

        end;

        if "Payment Mode" = "payment mode"::CDF then begin
        "Bank No.Enable" :=false;
        "Amount to payEnable" :=true;
        "Bank Slip DateEnable" :=true;
        "CDF AccountEnable" :=true;
        "CDF DescriptionEnable" :=true;
        end;
    end;

    trigger OnInit()
    begin
        "Payment ByEnable" := true;
        "Staff DescriptionEnable" := true;
        "Staff Invoice No.Enable" := true;
        "Unref. Entry No.Enable" := true;
        ApplicationEnable := true;
        "CDF DescriptionEnable" := true;
        "CDF AccountEnable" := true;
        "Apply to OverpaymentEnable" := true;
        "Applies to Doc NoEnable" := true;
        "Bank Slip DateEnable" := true;
        "Bank No.Enable" := true;
        "Drawer NameEnable" := true;
        "Cheque NoEnable" := true;
        "Amount to payEnable" := true;
    end;

    trigger OnOpenPage()
    begin
        "Cheque NoEnable" :=false;
        "Drawer NameEnable" :=false;
        //CurrForm."Drawer's Bank".ENABLED:=FALSE;
        //CurrForm."Drawer's Branch Code".ENABLED:=FALSE;
        "Amount to payEnable" :=false;
        "Applies to Doc NoEnable" :=false;
        "Apply to OverpaymentEnable" :=false;
        "Bank Slip DateEnable" :=false;
        "Bank No.Enable" :=false;
        "Unref. Entry No.Enable" :=false;
        "Staff Invoice No.Enable" :=false;
        "Staff DescriptionEnable" :=false;
        "CDF AccountEnable" :=false;
        "CDF DescriptionEnable" :=false;
    end;

    var
        cust2: Record Customer;
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
        TotalApplied: Decimal;
        Sems: Record UnknownRecord61692;
        DueDate: Date;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CReg: Record UnknownRecord61532;
        CustLedg: Record "Cust. Ledger Entry";
        StudentPay: Record UnknownRecord61536;
        ProgrammeSetUp: Record UnknownRecord61511;
        CourseReg: Code[20];
        LastReceiptNo: Code[20];
        "No. Series Line": Record "No. Series Line";
        "Last No": Code[20];
        Prog: Record UnknownRecord61511;
        BankRec: Record "Bank Account";
        [InDataSet]
        "Amount to payEnable": Boolean;
        [InDataSet]
        "Cheque NoEnable": Boolean;
        [InDataSet]
        "Drawer NameEnable": Boolean;
        [InDataSet]
        "Bank No.Enable": Boolean;
        [InDataSet]
        "Bank Slip DateEnable": Boolean;
        [InDataSet]
        "Applies to Doc NoEnable": Boolean;
        [InDataSet]
        "Apply to OverpaymentEnable": Boolean;
        [InDataSet]
        "CDF AccountEnable": Boolean;
        [InDataSet]
        "CDF DescriptionEnable": Boolean;
        [InDataSet]
        ApplicationEnable: Boolean;
        [InDataSet]
        "Unref. Entry No.Enable": Boolean;
        [InDataSet]
        "Staff Invoice No.Enable": Boolean;
        [InDataSet]
        "Staff DescriptionEnable": Boolean;
        [InDataSet]
        "Payment ByEnable": Boolean;
        StudHostel: Record "ACA-Students Hostel Rooms";
        HostLedg: Record "ACA-Hostel Ledger";
        BankName: Text[100];
}

