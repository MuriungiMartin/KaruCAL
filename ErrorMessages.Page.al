#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 700 "Error Messages"
{
    Caption = 'Error Messages';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
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
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the table where the error occurred.';
                }
                field("Field Name";"Field Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the field where the error occurred.';
                }
                field("Additional Information";"Additional Information")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies more information than the information shown in the Description field.';
                }
                field("Support Url";"Support Url")
                {
                    ApplicationArea = Basic,Suite;
                    ExtendedDatatype = URL;
                    ToolTip = 'Specifies the URL of an external web site that offers additional support.';
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the record that is associated with this error message.';

                trigger OnAction()
                begin
                    PageManagement.PageRun("Record ID");
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
        [InDataSet]
        StyleText: Text[20];
        EnableOpenRelatedEntity: Boolean;


    procedure SetRecords(var TempErrorMessage: Record "Error Message" temporary)
    begin
        if TempErrorMessage.FindFirst then;
        if TempErrorMessage.IsTemporary then
          Copy(TempErrorMessage,true)
        else
          TempErrorMessage.CopyToTemp(Rec);
    end;

    local procedure SetStyle()
    begin
        case "Message Type" of
          "message type"::Error:
            StyleText := 'Attention';
          "message type"::Warning,
          "message type"::Information:
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

