#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78002 "Special Exams Details List"
{
    ApplicationArea = Basic;
    DelayedInsert = true;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable78002;
    SourceTableView = where(Category=filter(Special));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Programme';
                    Editable = true;
                }
                field("Special Exam Reason";"Special Exam Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Unit Description";"Unit Description")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Marks";"Exam Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cost Per Exam";"Cost Per Exam")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Academic Year";"Current Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Academic Year';
                    Editable = true;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Semester';
                    Editable = true;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Stage';
                    Editable = true;
                }
                field(Occurances;Occurances)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Status";"Approval Status")
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
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //IF ApprovalMgmt.CheckspecialExamWorkflowEnabled(Rec) THEN BEGIN
                     ApprovalMgmt.SendSpecialExamApprovalRequest(Rec);
                     // END;
                end;
            }
            action("Approvals&")
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    Approvalentries: Page "Approval Entries";
                    ObjApprov: Record "Approval Entry";
                begin
                    //DocumentType:=DocumentType::"Payment Voucher";
                    ObjApprov.Reset;
                    ObjApprov.SetRange("Table ID",Database::"Aca-Special Exams Details");
                    //ObjApprov.SETRANGE("Document No.",Rec."Student No.");
                    if ObjApprov.FindSet then begin
                      Clear(Approvalentries);
                      Approvalentries.SetTableview(ObjApprov);
                      Approvalentries.Run();
                      end;
                end;
            }
        }
    }

    var
        ApprovalMgmt: Codeunit "Export F/O Consolidation";
        WorkflowManagement: Codeunit "Workflow Management";
        WrkflowEvent: Codeunit "Workflow Event Handling";
}

