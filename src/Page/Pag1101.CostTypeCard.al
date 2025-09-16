#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1101 "Cost Type Card"
{
    Caption = 'Cost Type Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Cost Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic;
                }
                field("Combine Entries";"Combine Entries")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account Range";"G/L Account Range")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Center Code";"Cost Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Object Code";"Cost Object Code")
                {
                    ApplicationArea = Basic;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Balance to Allocate";"Balance to Allocate")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Classification";"Cost Classification")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Share";"Fixed Share")
                {
                    ApplicationArea = Basic;
                }
                field("Blank Line";"Blank Line")
                {
                    ApplicationArea = Basic;
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field("Modified Date";"Modified Date")
                {
                    ApplicationArea = Basic;
                }
                field("Modified By";"Modified By")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control39;Links)
            {
                Visible = false;
            }
            systempart(Control38;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cost Type")
            {
                Caption = '&Cost Type';
                Image = Costs;
                action("E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&ntries';
                    Image = Entries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Type No."=field("No.");
                    RunPageView = sorting("Cost Type No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                separator(Action4)
                {
                }
                action("&Balance")
                {
                    ApplicationArea = Basic;
                    Caption = '&Balance';
                    Image = Balance;
                    RunObject = Page "Cost Type Balance";
                    RunPageLink = "No."=field("No."),
                                  "Cost Center Filter"=field("Cost Center Filter"),
                                  "Cost Object Filter"=field("Cost Object Filter");
                }
            }
        }
        area(processing)
        {
            action("Cost Registers")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Registers';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cost Registers";
            }
            action("G/L Account")
            {
                ApplicationArea = Basic;
                Caption = 'G/L Account';
                Image = JobPrice;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Chart of Accounts";
            }
        }
        area(reporting)
        {
            action("Cost Acctg. P/L Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Acctg. P/L Statement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Acctg. Statement";
            }
            action("Cost Acctg. P/L Statement per Period")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Acctg. P/L Statement per Period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Acctg. Stmt. per Period";
            }
            action("Cost Acctg. P/L Statement with Budget")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Acctg. P/L Statement with Budget';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Cost Acctg. Statement/Budget";
            }
            action("Cost Acctg. Analysis")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Acctg. Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Acctg. Analysis";
            }
            action("Account Details")
            {
                ApplicationArea = Basic;
                Caption = 'Account Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Cost Types Details";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetRange("No.");
    end;
}

