#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68420 "ACA-Grad. Charges (Unposted)"
{
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61535;
    SourceTableView = where(Posted=filter(No),
                            Recognized=filter(No),
                            Code=filter("GRADUATION DEG"|"GRADUATION DIP"|GOWN_HIRE|ALUMNI_FEE));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
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
            Description = 'Functions';
            action(validate)
            {
                ApplicationArea = Basic;
                Caption = 'Validate Graduation Charges';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                      if Confirm('Create charges for all unbilled Graduation applicants?', true)=false then exit;
                      GetFuncs();
                    Message('Charges Captured Successfully');
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post Graduation Charges';
                Image = PostApplication;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                      if Confirm('Post unposted graduation Charges?',true)=false then Error('Cancelled by '+Format(UserId));
                    GetFuncs();

                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;

                    GenSetUp.Get();

                    StudentCharges.Reset;
                    // Check if Unposted Graduation Charges Exists for posting
                    StudentCharges.SetRange(StudentCharges.Posted,false);
                    StudentCharges.SetRange(StudentCharges.Recognized,false);
                    StudentCharges.SetFilter(StudentCharges.Code,'%1|%2|%3|%4','GRADUATION DEG','GRADUATION DIP','GOWN_HIRE','ALUMNI_FEE');
                    if StudentCharges.Find('-') then begin
                    repeat

                    if Cust.Get(StudentCharges."Student No.") then;
                    DueDate:=StudentCharges.Date;

                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":=StudentCharges.Code;
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    //
                    if Cust.Get(StudentCharges."Student No.") then begin
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Account No.":=StudentCharges."Student No.";
                    end;

                    GenJnl.Amount:=StudentCharges.Amount;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=StudentCharges.Description;
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
                    if Charges.Get(StudentCharges.Code) then
                    GenJnl."Bal. Account No.":=Charges."G/L Account";
                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl."Shortcut Dimension 2 Code":=Cust."Global Dimension 2 Code";

                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    GenJnl."Due Date":=DueDate;
                    GenJnl.Validate(GenJnl."Due Date");
                    if StudentCharges."Recovery Priority" <> 0 then
                    GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
                    else
                    GenJnl."Recovery Priority":=25;
                    GenJnl.Insert;

                    StudentCharges.Recognized:=true;
                    StudentCharges.Posted:=true;
                    StudentCharges.Modify;

                    until StudentCharges.Next = 0;
                     end;
                    //Post New
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
                    end;
                end;
            }
        }
    }

    var
        StudentPayments: Record UnknownRecord61536;
        StudentCharges: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Charges: Record UnknownRecord61515;
        GenSetUp: Record UnknownRecord61534;
        StudentCharges2: Record UnknownRecord61535;
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        PDate: Date;
        DocNo: Code[20];
        StudCharges: Record UnknownRecord61535;
        CustLed2: Record "Cust. Ledger Entry";
        Cont: Boolean;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        CustLedg: Record "Cust. Ledger Entry";
        CurrentBal: Decimal;
        Prog: Record UnknownRecord61511;
        DueDate: Date;
        Charges2: Record UnknownRecord61515;
        found: Boolean;

    local procedure GetFuncs()
    begin
        Charges.Reset;
        Charges.SetFilter(Charges.Code,'%1|%2|%3|%4','GRADUATION DEG','GRADUATION DIP','GOWN_HIRE','ALUMNI_FEE');
        if Charges.Find('-') then begin
        repeat
          begin
             Cust.Reset;
             Cust.SetRange(Cust."Applied for Clearance",true);
             if Cust.Find('-') then begin
              repeat
                begin
                Clear(found);
                 Charges2.Reset;
                 Charges2.SetFilter(Charges2.Code,'%1|%2|%3|%4','GRADUATION DEG','GRADUATION DIP','GOWN_HIRE','ALUMNI_FEE');
                 if Charges2.Find('-') then begin
                  repeat
                    begin
                      CustLed2.Reset;
                      CustLed2.SetRange(CustLed2."Customer No.",Cust."No.");
                      CustLed2.SetRange(CustLed2."Bal. Account No.",Charges2."G/L Account");
                      if CustLed2.Find('-') then found:=true;
                    end;
                  until Charges2.Next=0;
                 end;

        if not found then begin
                  StudentCharges.Reset;
                  StudentCharges.SetRange(StudentCharges."Student No.",Cust."No.");
                  StudentCharges.SetRange(StudentCharges.Code,Charges.Code);
                  if not (StudentCharges.Find('-')) then begin
                  if ((Charges.Code='GRADUATION DEG') or (Charges.Code='GRADUATION DIP')) then begin
                  if Prog.Get(Cust."Current Programme") then begin //3
                  if Prog.Category=Prog.Category::Diploma then begin//2
                  if Charges.Code='GRADUATION DIP' then begin //1
                   StudentCharges.Init;
                   StudentCharges."Transacton ID":='';
                   StudentCharges.Validate(StudentCharges."Transacton ID");
                   StudentCharges."Student No.":=Cust."No.";
                   StudentCharges."Reg. Transacton ID":='';
                   StudentCharges.Code:=Charges.Code;
                   StudentCharges.Description:=Charges.Description;
                   StudentCharges.Amount:=Charges.Amount;
                   StudentCharges.Date:=Today;
                   StudentCharges.Charge:=true;
                   StudentCharges.Insert;
                   end;//1
                   end else //2
                  if Prog.Category=Prog.Category::Undergraduate then begin//2
                  if Charges.Code='GRADUATION DEG' then begin //1
                   StudentCharges.Init;
                   StudentCharges."Transacton ID":='';
                   StudentCharges.Validate(StudentCharges."Transacton ID");
                   StudentCharges."Student No.":=Cust."No.";
                   StudentCharges."Reg. Transacton ID":='';
                   StudentCharges.Code:=Charges.Code;
                   StudentCharges.Description:=Charges.Description;
                   StudentCharges.Amount:=Charges.Amount;
                   StudentCharges.Date:=Today;
                   StudentCharges.Charge:=true;
                   StudentCharges.Insert;
                   end;//1
                   end; //2
                   end; //3
                   end else if ((Charges.Code='GOWN_HIRE') or (Charges.Code='ALUMNI_FEE')) then begin
                   StudentCharges.Init;
                   StudentCharges."Transacton ID":='';
                   StudentCharges.Validate(StudentCharges."Transacton ID");
                   StudentCharges."Student No.":=Cust."No.";
                   StudentCharges."Reg. Transacton ID":='';
                   StudentCharges.Code:=Charges.Code;
                   StudentCharges.Description:=Charges.Description;
                   StudentCharges.Amount:=Charges.Amount;
                   StudentCharges.Date:=Today;
                   StudentCharges.Charge:=true;
                   StudentCharges.Insert;
                   end;
                  end;
                  end;
                end;
              until Cust.Next=0;
             end;
          end;
        until Charges.Next=0;
        end;
    end;
}

