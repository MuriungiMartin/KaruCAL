#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 958 "Time Sheet Posting Entries"
{
    Caption = 'Time Sheet Posting Entries';
    DataCaptionFields = "Time Sheet No.";
    Editable = false;
    PageType = List;
    SourceTable = "Time Sheet Posting Entry";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Time Sheet No.";"Time Sheet No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of a time sheet.';
                }
                field("Time Sheet Line No.";"Time Sheet Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of a time sheet line.';
                }
                field("Time Sheet Date";"Time Sheet Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date for which time usage information was entered in a time sheet.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description that is contained in the details about the time sheet line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of hours that have been posted for that date in the time sheet.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the document number that was generated or created for the time sheet during posting.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date of the posted document.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the time sheet posting entry.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("&Navigate")
            {
                ApplicationArea = Jobs;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

