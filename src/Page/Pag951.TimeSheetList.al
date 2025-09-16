#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 951 "Time Sheet List"
{
    ApplicationArea = Basic;
    Caption = 'Time Sheet List';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
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
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a comment about this document has been entered.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Time Sheets")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Time Sheets';
                Image = NewTimesheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Create Time Sheets";
                ToolTip = 'Create new time sheets.';
            }
            action(EditTimeSheet)
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
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
          CurrPage.Editable := UserSetup."Time Sheet Admin.";
        TimeSheetMgt.FilterTimeSheets(Rec,FieldNo("Owner User ID"));
    end;

    var
        UserSetup: Record "User Setup";
        TimeSheetMgt: Codeunit "Time Sheet Management";

    local procedure EditTimeSheet()
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        TimeSheetMgt.SetTimeSheetNo("No.",TimeSheetLine);
        Page.Run(Page::"Time Sheet",TimeSheetLine);
    end;
}

