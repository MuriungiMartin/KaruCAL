#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68927 "HRM-Posted Leave Applic. List"
{
    CardPageID = "HRM-Posted Leave Applic.";
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61125;
    SourceTableView = where(Status=filter(Posted));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Return Date";"Return Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Reliever Name";"Reliever Name")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004;Outlook)
            {
            }
        }
    }

    actions
    {
    }

    var
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ApprovalEntries: Page "Approval Entries";
        ApprovalComments: Page "Approval Comments";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application";
        HRLeaveApp: Record UnknownRecord61063;


    procedure TESTFIELDS()
    begin
                                        TestField("Leave Type");
                                      //  TESTFIELD("Days Applied");
                                      //  TESTFIELD("Start Date");
                                      //  TESTFIELD(Reliever);
                                      //  TESTFIELD(Supervisor);
    end;
}

