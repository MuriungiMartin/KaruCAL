#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 962 "Manager Time Sheet Arc. List"
{
    ApplicationArea = Basic;
    Caption = 'Manager Time Sheet Arc. List';
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
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Time Sheet Arc. Comment Sheet";
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
                    ToolTip = 'View the resource ledger entries that have been posted in connection with the.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
          CurrPage.Editable := UserSetup."Time Sheet Admin.";
        TimeSheetMgt.FilterTimeSheetsArchive(Rec,FieldNo("Approver User ID"));
    end;

    var
        UserSetup: Record "User Setup";
        TimeSheetMgt: Codeunit "Time Sheet Management";

    local procedure EditTimeSheet()
    var
        TimeSheetLineArchive: Record "Time Sheet Line Archive";
    begin
        TimeSheetMgt.SetTimeSheetArchiveNo("No.",TimeSheetLineArchive);
        Page.Run(Page::"Manager Time Sheet Archive",TimeSheetLineArchive);
    end;
}

