#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9819 "User Setup FactBox"
{
    Caption = 'User Setup FactBox';
    Editable = false;
    PageType = CardPart;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Allow Posting From";"Allow Posting From")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post to the company.';
                }
                field("Allow Posting To";"Allow Posting To")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last date on which the user is allowed to post to the company.';
                }
                field("Register Time";"Register Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to register the user''s time usage defined as the time spent from when the user logs in to when the user logs out.';
                }
                field("Time Sheet Admin.";"Time Sheet Admin.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if a user is a time sheet administrator. A time sheet administrator can access any time sheet and then edit, change, or delete it.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;
}

