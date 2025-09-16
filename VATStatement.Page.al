#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 317 "VAT Statement"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'VAT Statement';
    MultipleNewLines = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "VAT Statement Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentStmtName;CurrentStmtName)
            {
                ApplicationArea = Basic;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the Tax statement.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(VATStmtManagement.LookupName(GetRangemax("Statement Template Name"),CurrentStmtName,Text));
                end;

                trigger OnValidate()
                begin
                    VATStmtManagement.CheckName(CurrentStmtName,Rec);
                    CurrentStmtNameOnAfterValidate;
                end;
            }
            repeater(Control1)
            {
                field("Row No.";"Row No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number that identifies this row.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the VAT statement line.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what the VATstatement line will include.';
                }
                field("Account Totaling";"Account Totaling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an account interval or a series of account numbers.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccountList: Page "G/L Account List";
                    begin
                        GLAccountList.LookupMode(true);
                        if not (GLAccountList.RunModal = Action::LookupOK) then
                          exit(false);
                        Text := GLAccountList.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a general posting type that will be used with the VAT statement.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a tax business posting group code for the VAT statement.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a tax product posting group code for the VAT Statement.';
                }
                field("Amount Type";"Amount Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Tax statement line shows the Tax amounts, or the base amounts on which the Tax is calculated.';
                }
                field("Row Totaling";"Row Totaling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a row-number interval or a series of row numbers.';
                }
                field("Calculate with";"Calculate with")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to reverse the sign of tax entries when it performs calculations.';
                }
                field(Control22;Print)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the VAT statement line will be printed on the report that contains the finished VAT statement. A check mark in the field means that the line will be printed.';
                }
                field("Print with";"Print with")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether amounts on the VAT statement will be printed with their original sign or with the sign reversed.';
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a new page should begin immediately after this line when the VAT statement is printed. To start a new page after this line, place a check mark in the field.';
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
            group("VAT &Statement")
            {
                Caption = 'VAT &Statement';
                Image = Suggest;
                action("P&review")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'P&review';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "VAT Statement Preview";
                    RunPageLink = "Statement Template Name"=field("Statement Template Name"),
                                  Name=field("Statement Name");
                    ToolTip = 'Preview the VAT statement.';
                }
            }
        }
        area(reporting)
        {
            action("VAT Statement")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'VAT Statement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'View a statement of posted Tax and calculates the duty liable to the customs authorities for the selected period.';

                trigger OnAction()
                begin
                    ReportPrint.PrintVATStmtLine(Rec);
                end;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Print)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Print the information in the window. A print request window opens where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintVATStmtLine(Rec);
                    end;
                }
                action("Calc. and Post Tax Settlement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calc. and Post Tax Settlement';
                    Ellipsis = true;
                    Image = SettleOpenTransactions;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Calc. and Post VAT Settlement";
                    ToolTip = 'Close open Tax entries and transfers purchase and sales Tax amounts to the Tax settlement account.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        StmtSelected: Boolean;
    begin
        OpenedFromBatch := ("Statement Name" <> '') and ("Statement Template Name" = '');
        if OpenedFromBatch then begin
          CurrentStmtName := "Statement Name";
          VATStmtManagement.OpenStmt(CurrentStmtName,Rec);
          exit;
        end;
        VATStmtManagement.TemplateSelection(Page::"VAT Statement",Rec,StmtSelected);
        if not StmtSelected then
          Error('');
        VATStmtManagement.OpenStmt(CurrentStmtName,Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        VATStmtManagement: Codeunit VATStmtManagement;
        CurrentStmtName: Code[10];
        OpenedFromBatch: Boolean;

    local procedure CurrentStmtNameOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        VATStmtManagement.SetName(CurrentStmtName,Rec);
        CurrPage.Update(false);
    end;
}

