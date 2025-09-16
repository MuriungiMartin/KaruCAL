#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1801 "Assisted Setup"
{
    ApplicationArea = Basic;
    Caption = 'Assisted Setup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Assisted Setup";
    SourceTableView = sorting(Order,Visible)
                      where(Visible=filter(true),
                            "Assisted Setup Page ID"=filter(<>0));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Run;
                        CurrPage.Update(false);
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleText;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Run;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Start Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Start Setup';
                Image = Setup;
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Start setting up the selected functionality. You will be guided through one or more pages where you need to fill in information to get things up an running.';

                trigger OnAction()
                begin
                    Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle;
    end;

    trigger OnOpenPage()
    begin
        Initialize;
    end;

    var
        StyleText: Text;

    local procedure SetStyle()
    begin
        case Status of
          Status::"Not Completed":
            StyleText := 'Standard';
          Status::Completed:
            StyleText := 'Favorable';
          else
            StyleText := 'Standard';
        end;
    end;
}

