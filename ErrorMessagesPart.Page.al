#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 701 "Error Messages Part"
{
    Caption = 'Error Messages';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Error Message";
    SourceTableTemporary = true;
    SourceTableView = sorting("Message Type",ID)
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Message Type";"Message Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the message is an error, a warning, or information.';
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Field Name";"Field Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the field where the error occurred.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = true;
                    Enabled = EnableOpenRelatedEntity;
                    StyleExpr = StyleText;
                    ToolTip = 'Specifies the message.';

                    trigger OnDrillDown()
                    begin
                        PageManagement.PageRun("Record ID");
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenRelatedRecord)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open Related Record';
                Enabled = EnableOpenRelatedEntity;
                Image = View;
                ToolTip = 'Open the record that is associated with this error message.';

                trigger OnAction()
                begin
                    PageManagement.PageRun("Record ID");
                end;
            }
            action(ViewDetails)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'View Details';
                Image = ViewDetails;
                ToolTip = 'Show more information about this error message.';

                trigger OnAction()
                begin
                    Page.Run(Page::"Error Messages",Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableActions;
    end;

    trigger OnAfterGetRecord()
    begin
        SetStyle;
    end;

    var
        PageManagement: Codeunit "Page Management";
        RecordIDToHighlight: RecordID;
        [InDataSet]
        StyleText: Text[20];
        EnableOpenRelatedEntity: Boolean;


    procedure SetRecords(var TempErrorMessage: Record "Error Message" temporary)
    begin
        Reset;
        DeleteAll;

        TempErrorMessage.Reset;
        if TempErrorMessage.FindFirst then
          Copy(TempErrorMessage,true);
    end;


    procedure GetStyleOfRecord(RecordVariant: Variant;var StyleExpression: Text)
    var
        RecordRef: RecordRef;
    begin
        if not RecordVariant.IsRecord then
          exit;

        RecordRef.GetTable(RecordVariant);
        RecordIDToHighlight := RecordRef.RecordId;
        CurrPage.Activate(true);

        if HasErrorMessagesRelatedTo(RecordVariant) then
          StyleExpression := 'Attention'
        else
          StyleExpression := 'None';
    end;

    local procedure SetStyle()
    var
        RecID: RecordID;
    begin
        RecID := "Record ID";

        case "Message Type" of
          "message type"::Error:
            if RecID = RecordIDToHighlight then
              StyleText := 'Unfavorable'
            else
              StyleText := 'Attention';
          "message type"::Warning,
          "message type"::Information:
            if RecID = RecordIDToHighlight then
              StyleText := 'Strong'
            else
              StyleText := 'None';
        end;
    end;

    local procedure EnableActions()
    var
        RecID: RecordID;
    begin
        RecID := "Record ID";
        EnableOpenRelatedEntity := RecID.TableNo <> 0;
    end;
}

