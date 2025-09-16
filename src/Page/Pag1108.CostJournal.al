#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1108 "Cost Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Cost Journal';
    DataCaptionFields = "Journal Template Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Cost Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CostJnlBatchName;CostJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CostJnlMgt.LookupName(CostJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CostJnlMgt.CheckName(CostJnlBatchName,Rec);

                    CurrPage.SaveRecord;
                    CostJnlMgt.SetName(CostJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;
            }
            repeater(Control7)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Type No.";"Cost Type No.")
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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bal. Cost Type No.";"Bal. Cost Type No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Cost Center Code";"Bal. Cost Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Cost Object Code";"Bal. Cost Object Code")
                {
                    ApplicationArea = Basic;
                }
                field(LineBalance;Balance)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("G/L Entry No.";"G/L Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Control21)
            {
                fixed(Control22)
                {
                    group("Cost Type Name")
                    {
                        Caption = 'Cost Type Name';
                        field(CostTypeName;CostTypeName)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Bal. Cost Type Name")
                    {
                        Caption = 'Bal. Cost Type Name';
                        field(BalCostTypeName;BalCostTypeName)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Bal. Cost Type Name';
                            Editable = false;
                        }
                    }
                    group(Control27)
                    {
                        Caption = 'Balance';
                        field(Balance;LineBalance + Balance - xRec.Balance)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Balance';
                            Editable = false;
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance;TotalBalance + Balance - xRec.Balance)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total Balance';
                            Editable = false;
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&ost")
            {
                Caption = 'P&ost';
                Image = PostOrder;
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"CA Jnl.-Post",Rec);
                        CostJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        SetRange("Journal Template Name","Journal Template Name");
                        SetRange("Journal Batch Name","Journal Batch Name");
                        Report.Run(Report::"Cost Acctg. Journal",true,false,Rec);
                    end;
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"CA Jnl.-Post+Print",Rec);
                        CostJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateLineBalance;
    end;

    trigger OnAfterGetRecord()
    begin
        xRec := Rec;
    end;

    trigger OnInit()
    begin
        BalanceVisible := true;
        TotalBalanceVisible := true;
        TotalBalance := 0;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        xRec := Rec;
        UpdateLineBalance;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CostJnlBatchName := "Journal Batch Name";
          CostJnlMgt.OpenJnl(CostJnlBatchName,Rec);
          exit;
        end;
        CostJnlMgt.TemplateSelection(Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        CostJnlMgt.OpenJnl(CostJnlBatchName,Rec);
    end;

    var
        CostType: Record "Cost Type";
        CostJnlMgt: Codeunit CostJnlManagement;
        CostJnlBatchName: Code[10];
        CostTypeName: Text[50];
        BalCostTypeName: Text[50];
        LineBalance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;

    local procedure UpdateLineBalance()
    begin
        // Update Balance
        CostJnlMgt.CalcBalance(Rec,xRec,LineBalance,TotalBalance,ShowBalance,ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;

        // Cost type and bal. Cost Type
        if CostType.Get("Cost Type No.") then
          CostTypeName := CostType.Name
        else
          CostTypeName := '';

        if CostType.Get("Bal. Cost Type No.") then
          BalCostTypeName := CostType.Name
        else
          BalCostTypeName := '';
    end;
}

