#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68147 "ACA-Students Hostels"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student));

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
                field("<Old Registration Number>";"Old Student Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Old Registration Number';
                    Editable = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Emergency Contact";"Emergency Contact")
                {
                    ApplicationArea = Basic;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Hostel Black Listed";"Hostel Black Listed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Black Listed Reason";"Black Listed Reason")
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
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Debit Amount (LCY)";"Debit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Credit Amount (LCY)";"Credit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.","No.");
                        Copyfilter("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter",DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1102760004;"ACA-Stud. Hostel Rooms")
            {
                SubPageLink = Student=field("No."),
                              Gender=field(Gender);
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
                action("Black List Student")
                {
                    ApplicationArea = Basic;
                    Caption = 'Black List Student';
                    Image = Archive;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Do you really want Black List Student?') then begin
                        TestField("Black Listed Reason");
                        "Hostel Black Listed":=true;
                        "Black Listed By":=UserId;
                        Modify;
                        end;
                    end;
                }
                separator(Action1102755004)
                {
                }
                action("Send Email")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    var
                        SendMail: Codeunit webportals;
                        RptFileName: Text;
                        MailBody: Text;
                        ObjHostel: Record "ACA-Students Hostel Rooms";
                        ObjCust: Record Customer;
                        KUCCPSImports: Record UnknownRecord70082;
                        hostelrooms: Record "ACA-Students Hostel Rooms";
                    begin
                        //send hostel email
                        ObjCust.Reset;
                        ObjCust.SetRange("No.",hostelrooms.Student);
                        if ObjCust.FindFirst then begin
                          ObjHostel.Reset;
                          ObjHostel.SetRange(Student,ObjCust."No.");
                          ObjHostel.SetRange(Student,hostelrooms.Semester);
                          if ObjHostel.FindFirst then begin
                                  MailBody:='This is to notify you that you have been allocated accommodation at the university. '+
                        'You have been allocated Block '+ObjHostel."Hostel No"+', Room no: '+ObjHostel."Room No"+', Space: '+ObjHostel."Space No"+
                        'Kindly collect the keys and other items from the Hostel manager on the reporting day. Fill the attached form and present it to the hostel manager';
                        RptFileName:='D:\'+'Room Agreement_'+DelChr(ObjHostel.Student,'=','/')+'.pdf';

                        if Exists(RptFileName) then
                          Erase(RptFileName);
                        Report.SaveAsPdf(Report::"Resident Room Agreement",RptFileName,ObjCust);
                              SendMail.SendEmailEasy_WithAttachment('Dear ',ObjCust.Name,MailBody,'','Karatina University','Hostel Manager',ObjCust."E-Mail",'HOSTEL ALLOCATION BLOCK',RptFileName,RptFileName);
                        if Exists(RptFileName) then
                          Erase(RptFileName);
                            end;
                          end;
                    end;
                }
                action("Revoke Student BlackList")
                {
                    ApplicationArea = Basic;
                    Caption = 'Revoke Student BlackList';
                    Image = ReverseLines;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Do you really want Revoke Black List Student?') then begin
                        TestField("Hostel Black Listed",true);
                        "Hostel Black Listed":=false;
                        "Black Listed By":=UserId;
                        Modify;
                        end;
                    end;
                }
                separator(Action1102755006)
                {
                }
            }
        }
        area(processing)
        {
            action("Post Charges")
            {
                ApplicationArea = Basic;
                Caption = 'Post Charges';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                      if Confirm('Do You Really Want to Post The Room Charges') then begin
                      StudentHostel.Reset;
                      StudentHostel.SetRange(StudentHostel.Student,"No.");
                      StudentHostel.SetRange(StudentHostel.Billed,false) ;
                      if StudentHostel.Find('-') then
                      begin
                         repeat;
                         StudentCharges.Validate(StudentCharges."Transacton ID");
                         StudentCharges.Init;
                         StudentCharges.Validate(StudentCharges."Transacton ID");
                         StudentCharges."Student No.":="No.";
                         StudentCharges."Transaction Type":=StudentCharges."transaction type"::Charges;
                         StudentCharges.Description:='Hostel Charges '+StudentHostel."Space No";
                         StudentCharges.Amount:=StudentHostel."Accomodation Fee";
                         StudentCharges.Date:=StudentHostel."Allocation Date";
                         StudentCharges.Insert(true);
                         StudentHostel.Billed:=true;
                         StudentHostel."Billed Date":=Today;
                         StudentHostel.Modify;
                         until StudentHostel.Next=0;
                      end;
                      Message('Hostel Charges Posted Successfully');
                     end;
                end;
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
        StudentCharge: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        LineNo: Integer;
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
        GenJnlLine: Record "Gen. Journal Line";
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
        StudentHostel: Record "ACA-Students Hostel Rooms";
        StudentCharges: Record UnknownRecord61535;
        Rooms: Record "ACA-Hostel Ledger";
        StudentHostel2: Record "ACA-Students Hostel Rooms";


    procedure "Post Charges"()
    begin
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'PAYMENTS');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",'CHARGES');
        if GenJnlLine.Find('-') then begin
          GenJnlLine.DeleteAll
        end;

          StudentHostel.Reset;
          StudentHostel.SetRange(StudentHostel.Student,"No.");
          StudentHostel.SetRange(StudentHostel.Cleared,false);
          if StudentHostel.Find('-') then begin
            repeat
            StudentHostel.TestField(StudentHostel.Semester);
            StudentHostel.TestField(StudentHostel."Space No");
            if StudentHostel.Charges>0 then begin
              LineNo:=LineNo+1000;
              GenJnlLine.Init;
              GenJnlLine."Journal Template Name":='PAYMENTS';
              GenJnlLine."Journal Batch Name":='CHARGES';
              GenJnlLine."Line No.":=LineNo;
              GenJnlLine."Account Type":=GenJnlLine."account type"::Customer;
              GenJnlLine."Account No.":="No.";
              GenJnlLine.Validate(GenJnlLine."Account No.");
              GenJnlLine."Posting Date":=Today;
              GenJnlLine."Document Type":=GenJnlLine."document type"::Invoice;
              GenJnlLine."Document No.":=StudentHostel."Space No" +' '+ StudentHostel."Room No";
             //GenJnlLine."External Document No.":="Cheque No";
              GenJnlLine.Amount:=StudentHostel.Charges;
              GenJnlLine.Validate(GenJnlLine.Amount);
              GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
              GenJnlLine."Bal. Account No.":='300007';
              GenJnlLine.Description:=Name;
              GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
              GenJnlLine."Shortcut Dimension 1 Code":='ACADEMIC';
             //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
             //GenJnlLine."Document No.":="Doc No";
             if GenJnlLine.Amount<>0 then
               GenJnlLine.Insert;
            end;
            until StudentHostel.Next=0;
          end;

        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'PAYMENTS');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",'CHARGES');
        if GenJnlLine.Find('-') then begin
           Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
        end;
    end;
}

