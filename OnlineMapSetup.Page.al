#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 800 "Online Map Setup"
{
    ApplicationArea = Basic;
    Caption = 'Online Map Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Online Map Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TermsOfUseLbl;TermsOfUseLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink('http://go.microsoft.com/fwlink/?LinkID=248686');
                    end;
                }
                field(PrivacyStatementLbl;PrivacyStatementLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink('http://go.microsoft.com/fwlink/?LinkID=248686');
                    end;
                }
            }
            group(Settings)
            {
                Caption = 'Settings';
                field("Map Parameter Setup Code";"Map Parameter Setup Code")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = "Online Map Parameter Setup";
                    ToolTip = 'Specifies the map parameter code that is set up in the Online Map Parameter Setup window.';
                }
                field("Distance In";"Distance In")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Distance in';
                    ToolTip = 'Specifies if distances in your online map should be shown in miles or kilometers.';
                }
                field(Route;Route)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Route (Quickest/Shortest)';
                    ToolTip = 'Specifies whether to use the quickest or shortest route for calculation.';
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
        area(processing)
        {
            action("&Parameter Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Parameter Setup';
                Image = EditList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Online Map Parameter Setup";
                ToolTip = 'Define which online map will be displayed when you call a map from a card, and what language will be used in maps and route directions.';
            }
        }
    }

    trigger OnOpenPage()
    var
        OnlineMapMgt: Codeunit "Online Map Management";
    begin
        Reset;
        if not Get then begin
          OnlineMapMgt.SetupDefault;
          Get;
        end;
    end;

    var
        TermsOfUseLbl: label 'Microsoft Bing Maps Services Agreement.';
        PrivacyStatementLbl: label 'Microsoft Bing Maps Privacy Statement.';
}

