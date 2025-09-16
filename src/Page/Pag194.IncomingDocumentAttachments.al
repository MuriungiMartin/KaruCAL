#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 194 "Incoming Document Attachments"
{
    AutoSplitKey = true;
    Caption = 'Files';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Inc. Doc. Attachment Overview";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationControls = Name;
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the name of the record.';

                    trigger OnDrillDown()
                    begin
                        NameDrillDown;
                    end;
                }
                field("File Extension";"File Extension")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the file type of the attached file.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of the attached file.';
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Created By User Name";"Created By User Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Export)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'View File';
                Enabled = "Line No." <> 0;
                Image = Document;
                Scope = Repeater;
                ToolTip = 'View the file that is attached to the incoming document record.';

                trigger OnAction()
                begin
                    NameDrillDown;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxt;
    end;

    var
        StyleTxt: Text;


    procedure LoadDataIntoPart(IncomingDocument: Record "Incoming Document")
    begin
        DeleteAll;
        InsertSupportingAttachmentsFromIncomingDocument(IncomingDocument,Rec);
        CurrPage.Update(false);
    end;
}

