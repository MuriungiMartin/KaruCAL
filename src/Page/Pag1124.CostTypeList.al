#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1124 "Cost Type List"
{
    Caption = 'Cost Type List';
    CardPageID = "Cost Type Card";
    DataCaptionFields = "Search Name";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Cost Type";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
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
                field("Cost Classification";"Cost Classification")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account Range";"G/L Account Range")
                {
                    ApplicationArea = Basic;
                }
                field("Net Change";"Net Change")
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
                field("Combine Entries";"Combine Entries")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Amount";"Budget Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = Basic;
                }
                field("Blank Line";"Blank Line")
                {
                    ApplicationArea = Basic;
                }
                field("Balance to Allocate";"Balance to Allocate")
                {
                    ApplicationArea = Basic;
                }
                field("Balance at Date";"Balance at Date")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Visible = false;
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
            group("&Cost Type")
            {
                Caption = '&Cost Type';
                Image = Costs;
                action("Cost E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost E&ntries';
                    Image = CostEntries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Type No."=field("No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(CorrespondingGLAccounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Corresponding &G/L Accounts';
                    Image = CompareCosttoCOA;
                    RunObject = Page "Chart of Accounts";
                    RunPageLink = "No."=field(filter("G/L Account Range"));
                }
                separator(Action35)
                {
                }
                action("&Balance")
                {
                    ApplicationArea = Basic;
                    Caption = '&Balance';
                    Image = Balance;
                    RunObject = Page "Cost Type Balance";
                    RunPageOnRec = true;
                    ShortCutKey = 'F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("I&ndent Cost Types")
                {
                    ApplicationArea = Basic;
                    Caption = 'I&ndent Cost Types';
                    Image = IndentChartofAccounts;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CostAccMgt.ConfirmIndentCostTypes;
                    end;
                }
                action("Get Cost Types from &Chart of Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Cost Types from &Chart of Accounts';
                    Image = ChartOfAccounts;

                    trigger OnAction()
                    begin
                        CostAccMgt.GetCostTypesFromChartOfAccount;
                    end;
                }
                action("&Register Cost Types in Chart of Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = '&Register Cost Types in Chart of Accounts';
                    Image = LinkAccount;

                    trigger OnAction()
                    begin
                        CostAccMgt.LinkCostTypesToGLAccountsYN;
                    end;
                }
            }
            action("Cost Registers")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Registers';
                Image = GLRegisters;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Cost Registers";
            }
            action(GLAccount)
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
        NameIndent := 0;
    end;

    var
        CostAccMgt: Codeunit "Cost Account Mgt";
        [InDataSet]
        NameIndent: Integer;


    procedure SetSelection(var CostType: Record "Cost Type")
    begin
        CurrPage.SetSelectionFilter(CostType);
    end;


    procedure GetSelectionFilter(): Text
    var
        CostType: Record "Cost Type";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CostType);
        exit(SelectionFilterManagement.GetSelectionFilterForCostType(CostType));
    end;
}

