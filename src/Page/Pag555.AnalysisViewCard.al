#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 555 "Analysis View Card"
{
    Caption = 'Analysis View Card';
    PageType = Card;
    SourceTable = "Analysis View";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Account Source";"Account Source")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SetGLAccountSource;
                    end;
                }
                field("Account Filter";"Account Filter")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccList: Page "G/L Account List";
                        CFAccList: Page "Cash Flow Account List";
                    begin
                        if "Account Source" = "account source"::"G/L Account" then begin
                          GLAccList.LookupMode(true);
                          if not (GLAccList.RunModal = Action::LookupOK) then
                            exit(false);

                          Text := GLAccList.GetSelectionFilter;
                        end else begin
                          CFAccList.LookupMode(true);
                          if not (CFAccList.RunModal = Action::LookupOK) then
                            exit(false);

                          Text := CFAccList.GetSelectionFilter;
                        end;

                        exit(true);
                    end;
                }
                field("Date Compression";"Date Compression")
                {
                    ApplicationArea = Basic;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Updated";"Last Date Updated")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Entry No.";"Last Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Budget Entry No.";"Last Budget Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Update on Posting";"Update on Posting")
                {
                    ApplicationArea = Basic;
                }
                field("Include Budgets";"Include Budgets")
                {
                    ApplicationArea = Basic;
                    Editable = GLAccountSource;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Dimension 1 Code";"Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 2 Code";"Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 3 Code";"Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 4 Code";"Dimension 4 Code")
                {
                    ApplicationArea = Basic;
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
            group("&Analysis")
            {
                Caption = '&Analysis';
                Image = AnalysisView;
                action("Filter")
                {
                    ApplicationArea = Basic;
                    Caption = 'Filter';
                    Image = "Filter";
                    RunObject = Page "Analysis View Filter";
                    RunPageLink = "Analysis View Code"=field(Code);
                }
            }
        }
        area(processing)
        {
            action("&Update")
            {
                ApplicationArea = Basic;
                Caption = '&Update';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "Update Analysis View";
            }
            action("Enable Update on Posting")
            {
                ApplicationArea = Basic;
                Caption = 'Enable Update on Posting';
                Image = Apply;

                trigger OnAction()
                begin
                    SetUpdateOnPosting(true);
                end;
            }
            action("Disable Update on Posting")
            {
                ApplicationArea = Basic;
                Caption = 'Disable Update on Posting';
                Image = UnApply;

                trigger OnAction()
                begin
                    SetUpdateOnPosting(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetGLAccountSource;
    end;

    trigger OnOpenPage()
    begin
        GLAccountSource := true;
    end;

    var
        GLAccountSource: Boolean;

    local procedure SetGLAccountSource()
    begin
        GLAccountSource := "Account Source" = "account source"::"G/L Account";
    end;
}

