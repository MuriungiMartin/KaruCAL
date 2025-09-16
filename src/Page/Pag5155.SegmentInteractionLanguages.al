#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5155 "Segment Interaction Languages"
{
    Caption = 'Segment Interaction Languages';
    DataCaptionExpression = Caption;
    PageType = List;
    SourceTable = "Segment Interaction Language";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Language Code";"Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which language to use for the attachment.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the Segment Interaction Language. This field will not be displayed in the Word attachment.';
                }
                field(Subject;Subject)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the subject text. The text in the field is used as the subject in e-mails and Word documents.';
                }
                field(AttachmentText;AttachmentText)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Attachment';
                    ToolTip = 'Specifies if the attachment that is linked to the segment line is inherited or unique.';

                    trigger OnAssistEdit()
                    begin
                        if "Attachment No." = 0 then
                          CreateAttachment
                        else
                          OpenAttachment;

                        CurrPage.Update;
                    end;
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
        area(navigation)
        {
            group("&Attachment")
            {
                Caption = '&Attachment';
                Image = Attachments;
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    Image = Edit;
                    ShortCutKey = 'Return';
                    ToolTip = 'Open the attachment.';

                    trigger OnAction()
                    begin
                        OpenAttachment;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;
                    Image = New;
                    ToolTip = 'Create an attachment.';

                    trigger OnAction()
                    begin
                        CreateAttachment;
                    end;
                }
                action("Copy &From")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &From';
                    Ellipsis = true;
                    Image = Copy;
                    ToolTip = 'Copy from an attachment.';

                    trigger OnAction()
                    begin
                        CopyFromAttachment;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import an attachment.';

                    trigger OnAction()
                    begin
                        ImportAttachment;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;
                    ToolTip = 'Export an attachment.';

                    trigger OnAction()
                    begin
                        ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;
                    ToolTip = 'Remove an attachment.';

                    trigger OnAction()
                    begin
                        RemoveAttachment(true);
                    end;
                }
            }
        }
    }
}

