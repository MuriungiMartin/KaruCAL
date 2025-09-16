#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69033 "ACA-Stds Transfer"
{
    PageType = Document;
    SourceTable = UnknownTable61612;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("New Programme";"New Programme")
                {
                    ApplicationArea = Basic;
                }
                field("New Student No";"New Student No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Image = Save;
                Promoted = true;

                trigger OnAction()
                begin
                    TestField(Posted,false);
                    TestField("New Student No");
                    TestField("New Programme");
                    if Cust2.Get("Student No") then begin
                    Cust2.CalcFields("Balance (LCY)");
                    
                    if not Cust.Get("New Student No") then begin
                    Cust.Init;
                    Cust."No.":="New Student No";
                    Cust.Name:=Cust2.Name;
                    Cust.Validate(Cust.Name);
                    Cust.Programme := Rec."New Programme";
                    Cust."Current Program":= Rec."New Programme";
                    Cust."Current Programme" := Rec."New Programme";
                    Cust."Phone No.":= Cust2."Phone No.";
                    Cust."E-Mail" := Cust2."E-Mail";
                    Cust."ID No":= Cust2."ID No";
                    Cust."Post Code" := Cust2."Post Code";
                    Cust.Address := Cust2.Address;
                    Cust."Address 2":= Cust2."Address 2";
                    Cust.City:= Cust2.City;
                    Cust."Date Of Birth":= Cust2."Date Of Birth";
                    Cust.Password :=Cust2.Password;
                    Cust."ID Card Expiry Year":= Cust2."ID Card Expiry Year";
                    Cust.Tribe := Cust2.Tribe;
                    Cust."Changed Password":= Cust2."Changed Password";
                    Cust."KNEC No" := Cust2."KNEC No";
                    Cust."Global Dimension 1 Code":=Cust2."Global Dimension 1 Code";
                    Cust."Customer Posting Group":=Cust2."Customer Posting Group";
                    Cust."Application Method":=Cust."application method"::"Apply to Oldest";
                    Cust.Status:=Cust.Status::Current;
                    Cust."Customer Type":=Cust."customer type"::Student;
                    Cust."Date Registered":=Cust2."Date Registered";
                    Cust.Insert(true);
                    end;
                    
                    
                    
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;
                    
                    
                    
                    CustL.Reset;
                    CustL.SetRange(CustL."Customer No.",Cust2."No.");
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
                    GenJnl."Account No.":=Cust2."No.";
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
                    GenJnl."Account No.":="New Student No";
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
                    Receipts.SetRange(Receipts."Student No.",Cust2."No.");
                    Receipts.SetRange(Receipts.Reversed,false);
                    if Receipts.Find('-') then begin
                    repeat
                    Receipts."Student No.":="New Student No";
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
                    Creg2.Reset;
                    Creg2.SetRange(Creg2."Student No.",Cust2."No.");
                    if Creg2.Find('+') then begin
                    Creg.Init;
                    Creg."Student No.":="New Student No";
                    Creg.Programme:="New Programme";
                    Creg.Semester :=Creg2.Semester;
                    Creg.Stage :=Creg2.Stage;
                    Creg."Settlement Type" :=Creg2."Settlement Type";
                    Creg."Registration Date":=Creg2."Registration Date";
                    Creg.Posted :=true;
                    Creg."User ID" :=UserId;
                    Creg.Session:=Creg2.Session;
                    Creg.Insert;
                    end;
                    Cust2.Status:=Cust2.Status::Transferred;
                    Cust2.Blocked:=Cust2.Blocked::All;
                    Cust2.Modify;
                    
                    Posted:=true;
                    UserId:=UserId;
                    Modify;
                    end;
                    
                    
                    Message('%1','Student transferred successfully.');

                end;
            }
        }
    }

    var
        Cust: Record Customer;
        Cust2: Record Customer;
        GenJnl: Record "Gen. Journal Line";
        Receipts: Record UnknownRecord61538;
        CustL: Record "Cust. Ledger Entry";
        Creg: Record UnknownRecord61532;
        Creg2: Record UnknownRecord61532;
}

