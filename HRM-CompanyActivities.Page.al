#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68355 "HRM-Company Activities"
{
    PageType = Worksheet;
    SourceTable = UnknownTable61294;

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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Day;Day)
                {
                    ApplicationArea = Basic;
                }
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                }
                field(Attachement;Attachement)
                {
                    ApplicationArea = Basic;
                }
                field(Responsibility;Responsibility)
                {
                    ApplicationArea = Basic;
                }
                field(Costs;Costs)
                {
                    ApplicationArea = Basic;
                }
                field(Control1000000022;Post)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
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
            group(Participants)
            {
                Caption = 'Participants';
                action(Employees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees';
                    RunObject = Page "HRM-Activity Employess";
                }
            }
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
                          InteractTemplLanguage.Description := Description;
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
                          InteractTemplLanguage.Description := Description;
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
                          InteractTemplLanguage.Description := Description;
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
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GenJournal.Reset;
                    GenJournal.SetRange(GenJournal."Journal Template Name",'GENERAL');
                    GenJournal.SetRange(GenJournal."Journal Batch Name",'COMP ACT.');
                    GenJournal.DeleteAll;

                    CompanyAct.Reset;
                    CompanyAct.SetRange(CompanyAct.Post,true);
                    CompanyAct.SetRange(CompanyAct.Posted,false);

                    if CompanyAct.Find('-') then begin
                    PostingGroups.Reset;
                    if PostingGroups.Find('-') then begin

                    repeat
                    GenJournal.Init;
                    GenJournal."Journal Template Name":='GENERAL';
                    GenJournal."Journal Batch Name":='COMP ACT.';
                    GenJournal."Line No.":=GenJournal."Line No."+LineNo;
                    GenJournal."Account Type":=GenJournal."account type"::"G/L Account";
                    GenJournal."Account No.":=PostingGroups."Comp. Act. Debit Account";
                    GenJournal."Posting Date":=WorkDate;
                    GenJournal."Document No.":=CompanyAct.Code+'-'+Format(CompanyAct.Day);
                    GenJournal."Bal. Account Type":=GenJournal."account type"::"Bank Account";
                    GenJournal."Bal. Account No.":=PostingGroups."Comp. Act. Credit Account";
                    GenJournal.Description:=CompanyAct.Description +'-'+ Format(CompanyAct.Day);
                    GenJournal.Amount:=CompanyAct.Costs;
                    GenJournal.Validate(GenJournal.Amount);
                    GenJournal.Insert;

                    CompanyAct.Posted:=true;
                    CompanyAct.Modify;
                    LineNo:=LineNo+10000;
                    until CompanyAct.Next = 0;
                    end;
                    end;

                    GenJournal.Reset;
                    GenJournal.SetRange(GenJournal."Journal Template Name",'GENERAL');
                    GenJournal.SetRange(GenJournal."Journal Batch Name",'COMP ACT.');
                    if GenJournal.Find('-') then
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJournal);

                    //MESSAGE('%1','Posting Completed Successfully');
                end;
            }
        }
    }

    var
        GenJournal: Record "Gen. Journal Line";
        LineNo: Integer;
        CompanyAct: Record UnknownRecord61294;
        PostingGroups: Record UnknownRecord61327;
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
}

