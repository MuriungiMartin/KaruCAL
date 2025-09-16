#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1139 "Delete Cost Budget Entries"
{
    Caption = 'Delete Cost Budget Entries';
    Permissions = TableData "G/L Budget Entry"=rm;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Cost Budget Register";"Cost Budget Register")
        {
            DataItemTableView = sorting("No.") order(descending);
            column(ReportForNavId_6875; 6875)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");

                if Closed then
                  Error(Text007,"No.");

                if Source = Source::Allocation then begin
                  CostBudgetEntry.SetRange("Allocated with Journal No.","No.");
                  CostBudgetEntry.ModifyAll(Allocated,false);
                  CostBudgetEntry.ModifyAll("Allocated with Journal No.",0);
                end;

                CostBudgetEntry.SetRange("Entry No.","From Cost Budget Entry No.","To Cost Budget Entry No.");
                CostBudgetEntry.DeleteAll;
                CostBudgetEntry.Reset;
            end;

            trigger OnPostDataItem()
            var
                CostAccSetup: Record "Cost Accounting Setup";
            begin
                DeleteAll;
                Reset;
                SetRange(Source,Source::Allocation);

                if FindLast then begin
                  CostBudgetEntry.Get("To Cost Budget Entry No.");
                  CostAccSetup.Get;
                  CostAccSetup."Last Allocation Doc. No." := CostBudgetEntry."Document No.";
                  CostAccSetup.Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                // Sort descending. Registers are deleted backwards
                SetRange("No.",CostBudgetRegister2."No.",CostBudgetRegister3."No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromRegisterNo;CostBudgetRegister2."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Register No.';
                        Lookup = true;
                        TableRelation = "Cost Budget Register" where (Closed=const(false));
                    }
                    field(ToRegisterNo;CostBudgetRegister3."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Register No.';
                        Editable = false;
                        TableRelation = "Cost Budget Register" where (Closed=const(false));
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CostBudgetRegister2.FindLast;
            CostBudgetRegister3.FindLast;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if CostBudgetRegister2."No." > CostBudgetRegister3."No." then
          Error(Text000);

        if not Confirm(Text001,false,CostBudgetRegister2."No.",CostBudgetRegister3."No.") then
          Error('');

        if not Confirm(Text004) then
          Error('');

        Window.Open(Text005 +
          Text006 );
    end;

    var
        Text000: label 'From Register No. must not be higher than To Register No..';
        Text001: label 'All corresponding cost budget entries and budget register entries will be deleted. Do you want to delete cost budget register %1 to %2?';
        Text004: label 'Are you sure?';
        Text005: label 'Delete cost register\';
        Text006: label 'Register  no.      #1######';
        Text007: label 'Register %1 can no longer be deleted because it is marked as closed.';
        CostBudgetRegister2: Record "Cost Budget Register";
        CostBudgetRegister3: Record "Cost Budget Register";
        CostBudgetEntry: Record "Cost Budget Entry";
        Window: Dialog;


    procedure InitializeRequest(FromEntryNo: Integer;ToEntryNo: Integer)
    begin
        CostBudgetRegister2."No." := FromEntryNo;
        CostBudgetRegister3."No." := ToEntryNo;
    end;
}

