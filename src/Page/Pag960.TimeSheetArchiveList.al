#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 960 "Time Sheet Archive List"
{
    ApplicationArea = Basic;
    Caption = 'Time Sheet Archive List';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Time Sheet Header Archive";
    SourceTableView = sorting("Resource No.","Starting Date");
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the archived time sheet.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the start date for the archived time sheet.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the end date for an archived time sheet.';
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the list of resource numbers associated with an archived time sheet.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&View Time Sheet")
            {
                ApplicationArea = Jobs;
                Caption = '&View Time Sheet';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open the time sheet.';

                trigger OnAction()
                begin
                    ViewTimeSheet;
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
                    RunObject = Page "Time Sheet Arc. Comment Sheet";
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
        TimeSheetMgt.FilterTimeSheetsArchive(Rec,FieldNo("Owner User ID"));
    end;

    var
        UserSetup: Record "User Setup";
        TimeSheetMgt: Codeunit "Time Sheet Management";

    local procedure ViewTimeSheet()
    var
        TimeSheetLineArchive: Record "Time Sheet Line Archive";
    begin
        TimeSheetMgt.SetTimeSheetArchiveNo("No.",TimeSheetLineArchive);
        Page.Run(Page::"Time Sheet Archive",TimeSheetLineArchive);
    end;
}

