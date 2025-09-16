#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68973 "ACA-Student Clearance(Cleared)"
{
    Caption = 'Student Clearance(Cleared)';
    CardPageID = "ACA-Clearance View Card Unedit";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student),
                            "Clearance Status"=filter(=Cleared));

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
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Semester";"Clearance Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Academic Year";"Clearance Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
                {
                    ApplicationArea = Basic;
                }
                field("Programme End Date";"Programme End Date")
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
            group(Student)
            {
                Caption = 'Student';
                action(printForm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Clearance Form';
                    Image = PrintVoucher;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                         if "Clearance Status"="clearance status"::open then Error('Initiate the clearance process before printing the clearance form');
                        ACAClearanceApprovalEntries.Reset;
                        ACAClearanceApprovalEntries.SetRange("Student ID","No.");
                        if ACAClearanceApprovalEntries.Find('-') then
                        Report.Run(51675,true,false,ACAClearanceApprovalEntries);
                    end;
                }
                action(revClearance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reverse Clearance';
                    Image = ReverseLines;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ClearLevela: Record UnknownRecord61754;
                        ClearTemplates: Record UnknownRecord61755;
                        ClearDepTemplates: Record UnknownRecord61756;
                        ClearStandardApp: Record UnknownRecord61757;
                        cust: Record Customer;
                        ClearEntries: Record UnknownRecord61758;
                    begin
                        if Confirm('Reverse the clearance process?',false)=false then Error('Cancelled!');
                        if Confirm('This will cancel for all approvers. Continue?',false)=false then Error('Cancelled!');
                        // Delete Clearance entries
                        clearEnt.Reset;
                        clearEnt.SetRange(clearEnt."Student ID","No.");
                        if clearEnt.Find('-') then clearEnt.DeleteAll;
                        if cust.Get("No.") then begin
                        cust."Clearance Status":=cust."clearance status"::open;
                        cust.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                action("Clearance Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Entries';
                    Image = Entries;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Clearance Entries View";
                    RunPageLink = "Student ID"=field("No.");
                }
                action("Mark As Alluminae")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark As Alluminae';
                    Image = Status;

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to mark this students as an alluminae?',true) = true then begin
                        Status:=Status::Alumni;
                        Modify;
                        end;
                    end;
                }
                action("Student ID Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Card';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        stud.Reset;
                        stud.SetRange(stud."No.","No.");
                        if stud.Find('+') then
                        Report.Run(51729,true,false,stud);
                    end;
                }
            }
        }
    }

    var
        clearEnt: Record UnknownRecord61758;
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
        CustL: Record "Cust. Ledger Entry";
        Stages3: Record UnknownRecord61516;
        Units3: Record UnknownRecord61517;
        ExamsByStage3: Record UnknownRecord61526;
        ExamsByUnit3: Record UnknownRecord61527;
        Charges3: Record UnknownRecord61515;
        Receipt3: Record UnknownRecord61538;
        stud: Record Customer;
        ACAClearanceApprovalEntries: Record UnknownRecord61758;


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
}

