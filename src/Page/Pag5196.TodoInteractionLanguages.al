#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5196 "To-do Interaction Languages"
{
    Caption = 'To-do Interaction Languages';
    PageType = List;
    SourceTable = "To-do Interaction Language";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the language code for the interaction template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the interaction template that you have chosen for the to-do.';
                }
                field("""Attachment No."" > 0";"Attachment No." > 0)
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    Caption = 'Attachment';

                    trigger OnAssistEdit()
                    begin
                        if "Attachment No." = 0 then
                          CreateAttachment(("To-do No." = '') or Todo.Closed)
                        else
                          OpenAttachment(("To-do No." = '') or Todo.Closed);
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
            group(Attachment)
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
                        OpenAttachment(("To-do No." = '') or Todo.Closed);
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
                        CreateAttachment(("To-do No." = '') or Todo.Closed);
                    end;
                }
                action("Copy &from")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &from';
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

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordsFound: Boolean;
    begin
        RecordsFound := Find(Which);
        CurrPage.Editable := ("To-do No." <> '');
        if Todo.Get("To-do No.") then
          CurrPage.Editable := not Todo.Closed;
        exit(RecordsFound);
    end;

    var
        Todo: Record "To-do";
}

