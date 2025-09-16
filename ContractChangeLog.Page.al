#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6063 "Contract Change Log"
{
    Caption = 'Contract Change Log';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Contract Change Log";
    SourceTableView = sorting("Contract No.","Change No.")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contract Part";"Contract Part")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the part of the contract that was changed.';
                }
                field("Type of Change";"Type of Change")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of change on the contract.';
                }
                field("Field Description";"Field Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the field that was modified.';
                }
                field("New Value";"New Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contents of the modified field after the change has taken place.';
                }
                field("Old Value";"Old Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contents of the modified field before the change takes place.';
                }
                field("Date of Change";"Date of Change")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the change.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item on the service contract line, for which a log entry was created.';
                }
                field("Serv. Contract Line No.";"Serv. Contract Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract line for which a log entry was created.';
                }
                field("Time of Change";"Time of Change")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time of the change.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user ID linked to this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    local procedure GetCaption(): Text[80]
    var
        ServContract: Record "Service Contract Header";
    begin
        if not ServContract.Get("Contract Type","Contract No.") then
          exit(StrSubstNo('%1',"Contract No."));

        exit(StrSubstNo('%1 %2',"Contract No.",ServContract.Description));
    end;
}

