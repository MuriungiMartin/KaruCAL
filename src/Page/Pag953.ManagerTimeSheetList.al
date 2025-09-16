#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 953 "Manager Time Sheet List"
{
    ApplicationArea = Basic;
    Caption = 'Manager Time Sheet List';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Time Sheet Header";
    SourceTableView = sorting("Resource No.","Starting Date");
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of a time sheet.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the starting date for a time sheet.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ending date for a time sheet.';
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the resource for the time sheet.';
                }
                field("Open Exists";"Open Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies if there are time sheet lines with the status Open.';
                }
                field("Submitted Exists";"Submitted Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies if there are time sheet lines with the status Submitted.';
                }
                field("Rejected Exists";"Rejected Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies whether there are time sheet lines with the status Rejected.';
                }
                field("Approved Exists";"Approved Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies whether there are time sheet lines with the status Approved.';
                }
                field("Posted Exists";"Posted Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies whether there are time sheet lines with the status Posted.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies that a comment about this document has been entered.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Edit Time Sheet")
            {
                ApplicationArea = Jobs;
                Caption = '&Edit Time Sheet';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open the time sheet in edit mode.';

                trigger OnAction()
                begin
                    EditTimeSheet;
                end;
            }
        }
        area(navigation)
        {
            group("&Time Sheet")
            {
                Caption = '&Time Sheet';
                Image = Timesheet;
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Time Sheet Comment Sheet";
                    RunPageLink = "No."=field("No."),
                                  "Time Sheet Line No."=const(0);
                }
                action("Posting E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posting E&ntries';
                    Image = PostingEntries;
                    RunObject = Page "Time Sheet Posting Entries";
                    RunPageLink = "Time Sheet No."=field("No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the resource ledger entries that have been posted in connection with the.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
          CurrPage.Editable := UserSetup."Time Sheet Admin.";
        TimeSheetMgt.FilterTimeSheets(Rec,FieldNo("Approver User ID"));
    end;

    var
        UserSetup: Record "User Setup";
        TimeSheetMgt: Codeunit "Time Sheet Management";

    local procedure EditTimeSheet()
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        TimeSheetMgt.SetTimeSheetNo("No.",TimeSheetLine);
        Page.Run(Page::"Manager Time Sheet",TimeSheetLine);
    end;
}

