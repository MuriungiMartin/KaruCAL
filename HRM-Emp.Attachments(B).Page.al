#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68828 "HRM- Emp. Attachments (B)"
{
    Caption = 'HR Employee Attachments';
    DeleteAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Attachments';
    SourceTable = UnknownTable61224;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Document Description";"Document Description")
                {
                    ApplicationArea = Basic;
                }
                field(Attachment;Attachment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Attachment Imported';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Attachments)
            {
                Caption = 'Attachments';
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    Image = Open;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get("Employee No","Document Description") then

                        begin
                        if InteractTemplLanguage.Get(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") then
                          InteractTemplLanguage.OpenAttachment;
                        end;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;
                    Image = Create_Movement;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get("Employee No","Document Description") then
                        begin
                        if not InteractTemplLanguage.Get(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") then
                        begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := "Employee No";
                          InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                          InteractTemplLanguage.Description := "Document Description";
                        end;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.Update;
                        DocLink.Attachment:=DocLink.Attachment::Yes;
                        DocLink.Modify;
                        end;
                    end;
                }
                action("Copy & From")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy & From';
                    Ellipsis = true;
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get("Employee No","Document Description") then
                        begin

                        if InteractTemplLanguage.Get(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") then

                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.Update;
                        DocLink.Attachment:=DocLink.Attachment::Yes;
                        DocLink.Modify;
                        end;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get("Employee No","Document Description") then
                        begin
                        if not InteractTemplLanguage.Get(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") then
                        begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := "Employee No";
                          InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                          InteractTemplLanguage.Description := DocLink."Document Description";
                          InteractTemplLanguage.Insert;
                        end;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.Update;
                        DocLink.Attachment:=DocLink.Attachment::Yes;
                        DocLink.Modify;
                        end;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get("Employee No","Document Description") then
                        begin
                        if InteractTemplLanguage.Get(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") then
                          InteractTemplLanguage.ExportAttachment;
                        end;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;
                    Image = RemoveContacts;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get("Employee No","Document Description") then
                        begin
                        if InteractTemplLanguage.Get(DocLink."Employee No",DocLink."Language Code (Default)",DocLink."Document Description") then begin
                          InteractTemplLanguage.RemoveAttachment(true);
                          DocLink.Attachment:=DocLink.Attachment::No;
                          DocLink.Modify;
                        end;
                        end;
                    end;
                }
            }
        }
    }

    var
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
        DocLink: Record UnknownRecord61224;


    procedure GetDocument() Document: Text[200]
    begin
        Document:="Document Description";
    end;
}

