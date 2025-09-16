#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5989 "Service Item Log"
{
    ApplicationArea = Basic;
    Caption = 'Service Item Log';
    DataCaptionExpression = GetCaptionHeader;
    Editable = false;
    PageType = List;
    SourceTable = "Service Item Log";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the event associated with the service item.';
                    Visible = ServiceItemNoVisible;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to this entry.';
                    Visible = false;
                }
                field("ServLogMgt.ServItemEventDescription(""Event No."")";ServLogMgt.ServItemEventDescription("Event No."))
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the event regarding service item that has taken place.';
                }
                field(After;After)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the field modified after the event takes place.';
                }
                field(Before;Before)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the previous value of the field, modified after the event takes place.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document type of the service item associated with the event, such as contract, order, or quote.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the event associated with the service item.';
                }
                field("Change Date";"Change Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the event.';
                }
                field("Change Time";"Change Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time of the event.';
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Delete Service Item Log")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Service Item Log';
                    Ellipsis = true;
                    Image = Delete;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Delete Service Item Log",true,false,Rec);
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        ServiceItemNoVisible := true;
    end;

    var
        ServLogMgt: Codeunit ServLogManagement;
        [InDataSet]
        ServiceItemNoVisible: Boolean;

    local procedure GetCaptionHeader(): Text[250]
    var
        ServItem: Record "Service Item";
    begin
        if GetFilter("Service Item No.") <> '' then begin
          ServiceItemNoVisible := false;
          if ServItem.Get("Service Item No.") then
            exit("Service Item No." + ' ' + ServItem.Description);

          exit("Service Item No.");
        end;

        ServiceItemNoVisible := true;
        exit('');
    end;
}

