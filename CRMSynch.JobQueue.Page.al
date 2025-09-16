#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5373 "CRM Synch. Job Queue"
{
    Caption = 'Microsoft Dynamics CRM Synch. Job Queue';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Job Queue Entry";
    SourceTableView = sorting(Priority,"Last Ready State");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Last Ready State";"Last Ready State")
                {
                    ApplicationArea = Suite;
                    Caption = 'Date';
                    ToolTip = 'Specifies the date and time when the Microsoft Dynamics CRM synchronization job was set to Ready and sent to the job queue.';
                }
                field("Error Message";"Error Message")
                {
                    ApplicationArea = Suite;
                    Style = Attention;
                    StyleExpr = StatusIsError;
                    ToolTip = 'Specifies the latest error message that was received from the job queue entry. You can view the error message if the Status field is set to Error. The field can contain up to 250 characters.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditJob)
            {
                ApplicationArea = Suite;
                Caption = 'Edit Job';
                Image = Edit;
                RunObject = Page "Job Queue Entry Card";
                RunPageOnRec = true;
                ShortCutKey = 'Return';
                ToolTip = 'Change the settings for the job queue entry.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StatusIsError := Status = Status::Error;
    end;

    trigger OnOpenPage()
    begin
        SetRange(Status,Status::Error);
        SetRange("Object ID to Run",Codeunit::"Integration Synch. Job Runner");
    end;

    var
        [InDataSet]
        StatusIsError: Boolean;
}

