#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68760 "ACA-General Set-Up"
{
    PageType = Card;
    SourceTable = UnknownTable61534;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Student Nos.";"Student Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Registration Nos.";"Registration Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("'----------------------**************---------------------'";'----------------------**************---------------------')
                {
                    ApplicationArea = Basic;
                    Caption = '----------------------HOSTEL ALLOCATION POLICY---------------------';
                }
                field("Available Accom. Spaces (Male)";"Available Accom. Spaces (Male)")
                {
                    ApplicationArea = Basic;
                }
                field("Available Acc. Spaces(Female)";"Available Acc. Spaces(Female)")
                {
                    ApplicationArea = Basic;
                }
                field("% of Accomodation";"% of Accomodation")
                {
                    ApplicationArea = Basic;
                }
                field("% of Billed Fees/Balance";"% of Billed Fees/Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Nos.";"Receipt Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Tuition Accounts";"Tuition Accounts")
                {
                    ApplicationArea = Basic;
                }
                field("Class Allocation Nos.";"Class Allocation Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Defered Account";"Defered Account")
                {
                    ApplicationArea = Basic;
                }
                field("Over Payment Account";"Over Payment Account")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Nos.";"Transaction Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Pre-Payment Account";"Pre-Payment Account")
                {
                    ApplicationArea = Basic;
                }
                field("Cons. Marksheet Key2";"Cons. Marksheet Key2")
                {
                    ApplicationArea = Basic;
                }
                field("Bill Supplimentary Fee";"Bill Supplimentary Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Supplementary Fee Code";"Supplementary Fee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unallocated Rcpts Account";"Unallocated Rcpts Account")
                {
                    ApplicationArea = Basic;
                }
                field("Further Info Nos";"Further Info Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Condition Nos";"Medical Condition Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Attachment Nos";"Attachment Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Enquiry Nos";"Enquiry Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Application Fee";"Application Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Nos";"Clearance Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Proforma Nos";"Proforma Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Posting From";"Allow Posting From")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Posting To";"Allow Posting To")
                {
                    ApplicationArea = Basic;
                }
                field("Applications Date Line";"Applications Date Line")
                {
                    ApplicationArea = Basic;
                }
                field("Default Year";"Default Year")
                {
                    ApplicationArea = Basic;
                }
                field("Default Semester";"Default Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Default Intake";"Default Intake")
                {
                    ApplicationArea = Basic;
                }
                field("Default Academic Year";"Default Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Allow UnPaid Hostel Booking";"Allow UnPaid Hostel Booking")
                {
                    ApplicationArea = Basic;
                }
                field("Cons. Marksheet Key1";"Cons. Marksheet Key1")
                {
                    ApplicationArea = Basic;
                }
                field("Allowed Reg. Fees Perc.";"Allowed Reg. Fees Perc.")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Online Results Access";"Allow Online Results Access")
                {
                    ApplicationArea = Basic;
                }
                field("Base Date";"Base Date")
                {
                    ApplicationArea = Basic;
                }
                field("Helb Account";"Helb Account")
                {
                    ApplicationArea = Basic;
                }
                field("CDF Account";"CDF Account")
                {
                    ApplicationArea = Basic;
                }
                field("Hostel Incidents";"Hostel Incidents")
                {
                    ApplicationArea = Basic;
                }
                field("Supp Registration Date";"Supp Registration Date")
                {
                    ApplicationArea = Basic;
                }
                field("Supp Deadline";"Supp Deadline")
                {
                    ApplicationArea = Basic;
                }
                field("Supplementary Fee";"Supplementary Fee")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Supplementary Fee";"2nd Supplementary Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Special Exam Fee";"Special Exam Fee")
                {
                    ApplicationArea = Basic;
                }
                field(Registrar_Mail;Registrar_Mail)
                {
                    ApplicationArea = Basic;
                }
                field("Staff Clearance Nos";"Staff Clearance Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Fund Band Batch Nos";"Fund Band Batch Nos")
                {
                    ApplicationArea = Basic;
                }
            }
            group("ID Setup")
            {
                Caption = 'ID Setup';
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signature';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Action1102760018)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    /*
                    CReg.RESET;
                    CReg.SETRANGE(CReg."System Created",TRUE);
                    IF CReg.FIND('-') THEN
                    CReg.DELETEALL;
                    */
                    Evaluate(PDate,'01/09/08');
                    
                    SCharges.Reset;
                    SCharges.SetFilter(SCharges.Stage,'Y1S2..Y4S2');
                    SCharges.SetRange(SCharges.Recognized,false);
                    if SCharges.Find('-') then
                    SCharges.ModifyAll(SCharges.Date,PDate);
                    //SCharges.MODIFYALL(SCharges.Recognized,FALSE);

                end;
            }
            action("Temp Del")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    
                    //  CReg.DELETEALL;
                     // Cust.DELETEALL;
                     //SCharges.DELETEALL;
                     //StudUnit.DELETEALL;
                     //Prog.DELETEALL;
                     //Units.DELETEALL;
                    
                    // Cust.DELETEALL;
                    GLEntry.DeleteAll;
                    CustEntry.DeleteAll;
                    CustDet.DeleteAll;
                    BankL.DeleteAll;
                    vendL.DeleteAll;
                    vedDetailed.DeleteAll;
                    
                    
                    /*
                    ProgStage.DELETEALL;
                    //ProgSem.DELETEALL;
                    //Prog.SETRANGE(Prog."School Code",'003');
                    IF Prog.FIND('-') THEN BEGIN
                    REPEAT
                    
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y1S1';
                    ProgStage.Description:='Year 1 Semester1';
                    ProgStage.Remarks:='Pass, Proceed to Second Year';
                    ProgStage.INSERT;
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y1S2';
                    ProgStage.Description:='Year 1 Semester2';
                    ProgStage.Remarks:='Pass, Proceed to Second Year';
                    ProgStage.INSERT;
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y2S1';
                    ProgStage.Description:='Year 2 Semester1';
                    ProgStage.Remarks:='Pass, Proceed to Third Year';
                    ProgStage.INSERT;
                    
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y2S2';
                    ProgStage.Description:='Year 2 Semester2';
                    ProgStage.Remarks:='Pass, Proceed to Third Year';
                    ProgStage.INSERT;
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y3S1';
                    ProgStage.Description:='Year 3 Semester1';
                    ProgStage.Remarks:='Pass, Proceed to Forth Year';
                    ProgStage.INSERT;
                    
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y3S2';
                    ProgStage.Description:='Year 3 Semester2';
                    ProgStage.Remarks:='Pass, Proceed to Second Year';
                    ProgStage.INSERT;
                    
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y4S1';
                    ProgStage.Description:='Year 4 Semester1';
                    ProgStage.Remarks:='Pass ';
                    ProgStage.INSERT;
                    
                    ProgStage.INIT;
                    ProgStage."Programme Code":=Prog.Code;
                    ProgStage.Code:='Y4S2';
                    ProgStage.Description:='Year 4 Semester2';
                    ProgStage.Remarks:='Pass ';
                    ProgStage.INSERT;
                    
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem1 09/10';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem2 09/10';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 10/11';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem2 10/11';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 11/12';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem2 11/12';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 12/13';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem2 12/13';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 13/14';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem2 13/14';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 14/15';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem2 14/15';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 08/09';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem2 08/09';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 08/09';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 09/10';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 10/11';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 11/12';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 12/13';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 13/14';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem.Semester:='Sem1 15/16';
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem2 15/16';
                    ProgSem.INSERT;
                    ProgSem.INIT;
                    ProgSem."Programme Code":=Prog.Code;
                    ProgSem.Semester:='Sem3 15/16';
                    ProgSem.INSERT;
                    
                    UNTIL Prog.NEXT=0;
                    END;
                    
                    
                    JabBuff.RESET;
                    IF JabBuff.FIND('-') THEN BEGIN
                    REPEAT
                    JabBuff.Processed:=FALSE;
                    JabBuff.MODIFY;
                    UNTIL JabBuff.NEXT=0;
                    END;
                    */
                    //Admissions.DELETEALL;
                    //}
                    Message('Done');

                end;
            }
            action("Update Units")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    /*
                    CReg.RESET;
                    CReg.SETRANGE(CReg.Semester,'SEM2-2014/2015');
                    IF CReg.FIND('-') THEN BEGIN
                    REPEAT
                    CReg.VALIDATE(CReg."Registration Date");
                    UNTIL
                    CReg.NEXT=0;
                    END;
                    */
                    StudUnit.Reset;
                    if StudUnit.Find('-') then begin
                    repeat
                    StudUnit.Taken:=true;
                    StudUnit.Modify;
                    until StudUnit.Next=0;
                    end;
                    Message('Done');

                end;
            }
            action(UPD)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                     HMSP.DeleteAll;
                     Message('Done');
                end;
            }
            action("Process Raw Marks")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    RawMarks.Reset;
                    RawMarks.SetRange(RawMarks.Posted,false);
                    if RawMarks.Find('-') then begin
                    repeat
                    if not Cust.Get(RawMarks."Reg No") then begin
                    Cust.Init;
                    Cust."No.":=RawMarks."Reg No";
                    Cust.Name:=RawMarks.Name;
                    Cust."Customer Type":=Cust."customer type"::Student;
                    Cust."Customer Posting Group":='Customer';
                    Cust."Gen. Bus. Posting Group":='LOCAL';
                    Cust.Insert;
                    end;
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.",RawMarks."Reg No");
                    CReg.SetRange(CReg.Programme,RawMarks.Prog);
                    CReg.SetRange(CReg.Stage,RawMarks.Stage);
                    CReg.SetRange(CReg.Semester,RawMarks.Semester);
                    if not CReg.Find('-') then begin
                    CReg.Init;
                    CReg."Reg. Transacton ID":='RG-0001';
                    CReg."Student No.":=RawMarks."Reg No";
                    CReg.Programme:=RawMarks.Prog;
                    CReg.Stage:=RawMarks.Stage;
                    CReg."Intake Code":=RawMarks.Intake;
                    CReg.Session:=RawMarks.Session;
                    CReg.Semester:=RawMarks.Semester+' '+RawMarks."Academic year";
                    CReg."Settlement Type":=RawMarks."Stud Type";
                    CReg."Registration Date":=Today;
                    CReg."Academic Year":=RawMarks."Academic year" ;
                    CReg.Insert;
                    end;

                    for i:=1 to 8 do begin
                    RawMarks1.Reset;
                    RawMarks1.SetRange(RawMarks1."Entry No",RawMarks."Entry No");
                    if RawMarks1.Find('-') then begin
                    Units.Reset;
                    Units.SetRange(Units."Programme Code",RawMarks1.Prog);
                    Units.SetRange(Units."Stage Code",RawMarks1.Stage );
                    Units.SetRange(Units."Reserved Room",Format(i));
                    if Units.Find('-') then begin
                    StudUnit.Reset;
                    StudUnit.SetRange(StudUnit."Student No.",RawMarks1."Reg No");
                    StudUnit.SetRange(StudUnit.Unit,Units.Code);
                    if not StudUnit.Find('-') then begin
                    StudUnit.Init;
                    StudUnit.Programme:=RawMarks1.Prog;
                    StudUnit.Stage:=RawMarks1.Stage;
                    StudUnit.Unit:=Units.Code;
                    StudUnit.Semester:=RawMarks.Semester+' '+RawMarks."Academic year";
                    StudUnit."Reg. Transacton ID":='RG-0001';
                    StudUnit."Student No.":=RawMarks1."Reg No";
                    StudUnit."No. Of Units":=RawMarks1.Unit;
                    StudUnit.Taken:=true;
                    StudUnit.Insert;
                    end;
                    ExResults.Reset;
                    ExResults.SetRange(ExResults."Student No.",RawMarks1."Reg No");
                    ExResults.SetRange(ExResults.Unit,Units.Code);
                    if not ExResults.Find('-') then begin
                    ExResults.Init;
                    ExResults."Student No.":=RawMarks1."Reg No";
                    ExResults.Programme:=RawMarks1.Prog;
                    ExResults.Stage:=RawMarks1.Stage;
                    ExResults.Unit:=Units.Code;
                    ExResults.Semester:= RawMarks.Semester+' '+RawMarks."Academic year";
                    ExResults.ExamType:='EXAM';
                    ExResults."Reg. Transaction ID":='RG-0001';
                    ExResults.Exam:='EXAM';
                    if i=1 then begin
                    ExResults.Score:=RawMarks1.U1;
                    ExResults.Contribution:=RawMarks1.U1;
                    end;
                    if i=2 then begin
                    ExResults.Score:=RawMarks1.U2;
                    ExResults.Contribution:=RawMarks1.U2;
                    end;
                    if i=3 then begin
                    ExResults.Score:=RawMarks1.U3;
                    ExResults.Contribution:=RawMarks1.U3;
                    end;
                    if i=4 then begin
                    ExResults.Score:=RawMarks1.U4;
                    ExResults.Contribution:=RawMarks1.U4;
                    end;
                    if i=5 then begin
                    ExResults.Score:=RawMarks1.U5;
                    ExResults.Contribution:=RawMarks1.U5;
                    end;
                    if i=6 then begin
                    ExResults.Score:=RawMarks1.U6;
                    ExResults.Contribution:=RawMarks1.U6;
                    end;
                    if i=7 then begin
                    ExResults.Score:=RawMarks1.U7;
                    ExResults.Contribution:=RawMarks1.U7;
                    end;
                    if i=8 then begin
                    ExResults.Score:=RawMarks1.U8;
                    ExResults.Contribution:=RawMarks1.U8;
                    end;
                    ExResults.Insert;
                    end;
                    end;
                    end;

                    end;

                    until RawMarks.Next=0;
                    end;
                    Message('Done');
                end;
            }
        }
    }

    var
        CReg: Record UnknownRecord61532;
        SCharges: Record UnknownRecord61535;
        PDate: Date;
        StudUnit: Record UnknownRecord61549;
        Prog: Record UnknownRecord61511;
        Units: Record UnknownRecord61517;
        ProgStage: Record UnknownRecord61516;
        Cust: Record Customer;
        GLEntry: Record "G/L Entry";
        CustEntry: Record "Cust. Ledger Entry";
        CustDet: Record "Detailed Cust. Ledg. Entry";
        ProgSem: Record UnknownRecord61525;
        HMSP: Record UnknownRecord61402;
        RawMarks: Record UnknownRecord61691;
        RawMarks1: Record UnknownRecord61691;
        i: Integer;
        ExResults: Record UnknownRecord61548;
        Admissions: Record UnknownRecord61372;
        BankL: Record "Bank Account Ledger Entry";
        vendL: Record "Vendor Ledger Entry";
        vedDetailed: Record "Detailed Vendor Ledg. Entry";
}

