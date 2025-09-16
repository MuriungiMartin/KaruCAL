#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68342 "HRM-Rules & Regulations"
{
    PageType = Worksheet;
    SourceTable = UnknownTable61287;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Rules & Regulations";"Rules & Regulations")
                {
                    ApplicationArea = Basic;
                }
                field(Attachement;Attachement)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
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
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code,"Language Code (Default)") then
                          InteractTemplLanguage.OpenAttachment;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := Code;
                          InteractTemplLanguage."Language Code" := "Language Code (Default)";
                          InteractTemplLanguage.Description := "Rules & Regulations";
                        end;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.Update;
                        Attachement:=Attachement::Yes;
                        Modify;
                    end;
                }
                action("Copy &from")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &from';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := Code;
                          InteractTemplLanguage."Language Code" := "Language Code (Default)";
                          InteractTemplLanguage.Description := "Rules & Regulations";
                          InteractTemplLanguage.Insert;
                          Commit;
                        end;
                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.Update;
                        Attachement:=Attachement::Yes;
                        Modify;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := Code;
                          InteractTemplLanguage."Language Code" := "Language Code (Default)";
                          InteractTemplLanguage.Description := "Rules & Regulations";
                          InteractTemplLanguage.Insert;
                        end;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.Update;
                        Attachement:=Attachement::Yes;
                        Modify;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code,"Language Code (Default)") then
                          InteractTemplLanguage.ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.RemoveAttachment(true);
                          Attachement:=Attachement::No;
                          Modify;
                        end;
                    end;
                }
            }
        }
    }

    var
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
}

