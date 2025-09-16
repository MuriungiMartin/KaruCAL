#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77721 "ACA-Course Reg. Reservour"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77721;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Reg. Transacton ID";"Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Session;Session)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stopped';

                    trigger OnValidate()
                    begin
                        //Reversing := TRUE;
                    end;
                }
                field("Stopage Reason";"Stopage Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Special Exam Exists";"Special Exam Exists")
                {
                    ApplicationArea = Basic;
                    Caption = 'Special Exams';
                    Editable = false;
                    Enabled = false;
                }
                field("Semester Total Units Taken";"Semester Total Units Taken")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Semester Passed Units";"Semester Passed Units")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Semester Failed Units";"Semester Failed Units")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Registration Date";"Registration Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reg. Date';
                    Editable = true;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Visible = true;
                }
                field("Units Taken";"Units Taken")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Total Paid";"Total Paid")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Total Billed";"Total Billed")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Class Code";"Class Code")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Options;Options)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Status";"Exam Status")
                {
                    ApplicationArea = Basic;
                }
                field(Registered;Registered)
                {
                    ApplicationArea = Basic;
                }
                field(Transfered;Transfered)
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
            group("Trimester Activities")
            {
                Caption = 'Trimester Activities';
                Description = 'Activities in a Trimester';
                Image = LotInfo;
                action("Student Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Units';
                    Image = BOMRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Student Units Reservour";
                    RunPageLink = "Student No."=field("Student No."),
                                  Semester=field(Semester),
                                  Programme=field(Programme),
                                  Reversed=filter(false);
                }
                action("Student Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Charges';
                    Image = ReceivableBill;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "ACA-Student Charges Reservour";
                    RunPageLink = "Student No."=field("Student No."),
                                  "Reg. Transacton ID"=field("Reg. Transacton ID");
                    RunPageView = where(Posted=filter(false));
                }
                action("Posted Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Charges';
                    Image = PostedVendorBill;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "ACA-Student Charges Reservour";
                    RunPageLink = "Student No."=field("Student No."),
                                  "Reg. Transacton ID"=field("Reg. Transacton ID");
                    RunPageView = where(Posted=filter(true));
                }
                action(SuppExams)
                {
                    ApplicationArea = Basic;
                    Caption = 'Supplementary Examinations';
                    Image = RegisteredDocs;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Supp. Exams Details List";
                    RunPageLink = "Student No."=field("Student No.");
                    RunPageView = where(Category=filter(Supplementary));
                }
                action(SpecialExamsReg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Special Examination Reg.';
                    Image = RegisterPick;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Special Exams Details List";
                    RunPageLink = "Student No."=field("Student No.");
                    RunPageView = where("Total Marks"=filter(1));
                }
                action(RevStopped)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reverse Stopped';
                    Image = AllocatedCapacity;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Restore deleted semester?',true)= false then Error('Action cancelled!');
                        ACACourseRegReservour.Reset;
                        ACACourseRegReservour.SetRange("Student No.",Rec."Student No.");
                        ACACourseRegReservour.SetRange(Stage,Rec.Stage);
                        ACACourseRegReservour.SetRange("Academic Year",Rec."Academic Year");
                        ACACourseRegReservour.SetRange(Programme,Rec.Programme);
                        ACACourseRegReservour.SetRange("Reg. Transacton ID",Rec."Reg. Transacton ID");
                        ACACourseRegReservour.SetRange("Register for",Rec."Register for");
                        ACACourseRegReservour.SetRange("Student Type",Rec."Student Type");
                        ACACourseRegReservour.SetRange("Entry No.",Rec."Entry No.");
                        ACACourseRegReservour.SetRange(Semester,Rec.Semester);
                        if ACACourseRegReservour.Find('-') then begin
                          repeat
                            begin
                              ACACourseRegistration.Reset;
                        // // //    ACACourseRegistration.SETRANGE("Reg. Transacton ID",ACACourseRegReservour."Reg. Transacton ID");
                        // // //    ACACourseRegistration.SETRANGE("Student No.",ACACourseRegReservour."Student No.");
                        // // //    ACACourseRegistration.SETRANGE(Programme,ACACourseRegReservour.Programme);
                        // // //    ACACourseRegistration.SETRANGE(Semester,ACACourseRegReservour.Semester);
                        // // //    ACACourseRegistration.SETRANGE(Stage,ACACourseRegReservour.Stage);
                              ACACourseRegistration.SetRange("Student No.",Rec."Student No.");
                              ACACourseRegistration.SetRange(Stage,Rec.Stage);
                              ACACourseRegistration.SetRange("Academic Year",Rec."Academic Year");
                              ACACourseRegistration.SetRange(Programme,Rec.Programme);
                              ACACourseRegistration.SetRange("Reg. Transacton ID",Rec."Reg. Transacton ID");
                              ACACourseRegistration.SetRange("Register for",Rec."Register for");
                              ACACourseRegistration.SetRange("Student Type",Rec."Student Type");
                              ACACourseRegistration.SetRange("Entry No.",Rec."Entry No.");
                              ACACourseRegistration.SetRange(Semester,Rec.Semester);
                            if not ACACourseRegistration.Find('-') then begin
                            ACACourseRegistration.Init;
                            ACACourseRegistration."Reg. Transacton ID":=ACACourseRegReservour."Reg. Transacton ID";
                        ACACourseRegistration."Student No.":=ACACourseRegReservour."Student No.";
                        ACACourseRegistration.Programme:=ACACourseRegReservour.Programme;
                        ACACourseRegistration.Semester:=ACACourseRegReservour.Semester;
                        ACACourseRegistration."Register for":=ACACourseRegReservour."Register for";
                        ACACourseRegistration.Validate(Stage,ACACourseRegReservour.Stage);
                        ACACourseRegistration."Student Type":=ACACourseRegReservour."Student Type";
                        ACACourseRegistration."Entry No.":=ACACourseRegReservour."Entry No.";
                        ACACourseRegistration."Settlement Type":=ACACourseRegReservour."Settlement Type";
                        ACACourseRegistration."Registration Date":=ACACourseRegReservour."Registration Date";
                        ACACourseRegistration.Remarks:=ACACourseRegReservour.Remarks;
                        ACACourseRegistration."Attending Classes":=ACACourseRegReservour."Attending Classes";
                        //ACACourseRegistration.Posted:=ACACourseRegReservour.Posted;
                        ACACourseRegistration.Posted:=true;
                        ACACourseRegistration."Stoppage Reason":=ACACourseRegReservour."Stopage Reason";
                        ACACourseRegistration."User ID":=ACACourseRegReservour."User ID";
                        ACACourseRegistration.Reversed:=ACACourseRegReservour.Reversed;
                        ACACourseRegistration."Admission No.":=ACACourseRegReservour."Admission No.";
                        ACACourseRegistration."Academic Year":=ACACourseRegReservour."Academic Year";
                        ACACourseRegistration."Admission Type":=ACACourseRegReservour."Admission Type";
                        ACACourseRegistration.Options:=ACACourseRegReservour.Options;
                        ACACourseRegistration."Registration Status":=ACACourseRegReservour."Registration Status";
                        ACACourseRegistration."Intake Code":=ACACourseRegReservour."Intake Code";
                        ACACourseRegistration."Exam Status":=ACACourseRegReservour."Exam Status";
                        ACACourseRegistration."Semester Average":=ACACourseRegReservour."Semester Average";
                        ACACourseRegistration."Cummulative Average":=ACACourseRegReservour."Cummulative Average";
                        ACACourseRegistration."Year Of Study":=ACACourseRegReservour."Year Of Study";

                            ACACourseRegistration.Insert;
                            ACACourseRegistration.Validate(Stage);
                            end;
                          end;
                          until ACACourseRegReservour.Next=0;
                          end;
                          Message('Reversal successfull!');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetCurrentkey("Student No.",Stage);
        if Cust.Get("Student No.") then
;

    trigger OnInit()
    begin
        SetCurrentkey("Student No.",Stage);
    end;

    trigger OnOpenPage()
    begin
        SetCurrentkey("Student No.",Stage);
    end;

    var
        Cust: Record Customer;
        ACACourseRegistration: Record UnknownRecord61532;
        ACACourseRegReservour: Record UnknownRecord77721;
}

