#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1115 "Cost Budget Entries"
{
    Caption = 'Cost Budget Entries';
    DataCaptionFields = "Cost Type No.","Budget Name";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Cost Budget Entry";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Date;Date)
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
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("System-Created Entry";"System-Created Entry")
                {
                    ApplicationArea = Basic;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                }
                field("Allocation ID";"Allocation ID")
                {
                    ApplicationArea = Basic;
                }
                field(Allocated;Allocated)
                {
                    ApplicationArea = Basic;
                }
                field("Allocated with Journal No.";"Allocated with Journal No.")
                {
                    ApplicationArea = Basic;
                }
                field("Allocation Description";"Allocation Description")
                {
                    ApplicationArea = Basic;
                }
                field("Last Modified By User";"Last Modified By User")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetCostBudgetRegNo(CurrRegNo);
        Insert(true);
        CurrRegNo := GetCostBudgetRegNo;
        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Budget Name" := CostBudgetName.Name;
        if CostBudgetName.Name <> "Budget Name" then
          CostBudgetName.Get("Budget Name");
        if GetFilter("Cost Type No.") <> '' then
          "Cost Type No." := GetFirstCostType(GetFilter("Cost Type No."));
        if GetFilter("Cost Center Code") <> '' then
          "Cost Center Code" := GetFirstCostCenter(GetFilter("Cost Center Code"));
        if GetFilter("Cost Object Code") <> '' then
          "Cost Object Code" := GetFirstCostObject(GetFilter("Cost Object Code"));
        Date := GetFirstDate(GetFilter(Date));
        "Last Modified By User" := UserId;
    end;

    trigger OnOpenPage()
    begin
        if GetFilter("Budget Name") = '' then
          CostBudgetName.Init
        else begin
          Copyfilter("Budget Name",CostBudgetName.Name);
          CostBudgetName.FindFirst;
        end;
    end;

    var
        CostBudgetName: Record "Cost Budget Name";
        CurrRegNo: Integer;


    procedure SetCurrRegNo(RegNo: Integer)
    begin
        CurrRegNo := RegNo;
    end;


    procedure GetCurrRegNo(): Integer
    begin
        exit(CurrRegNo);
    end;
}

