#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1130 "Delete Cost Entries"
{
    Caption = 'Delete Cost Entries';
    Permissions = TableData "G/L Entry"=rm;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Cost Register";"Cost Register")
        {
            DataItemTableView = sorting("No.") order(descending);
            column(ReportForNavId_5327; 5327)
            {
            }

            trigger OnAfterGetRecord()
            var
                CostEntry: Record "Cost Entry";
            begin
                Window.Update(1,"No.");

                if Closed then
                  Error(Text007,"No.");

                if Source = Source::Allocation then begin
                  CostEntry.SetCurrentkey("Allocated with Journal No.");
                  CostEntry.SetRange("Allocated with Journal No.","No.");
                  CostEntry.ModifyAll(Allocated,false);
                  CostEntry.ModifyAll("Allocated with Journal No.",0);
                end;

                CostEntry.Reset;
                CostEntry.SetRange("Entry No.","From Cost Entry No.","To Cost Entry No.");
                CostEntry.DeleteAll;
            end;

            trigger OnPostDataItem()
            var
                CostEntry: Record "Cost Entry";
            begin
                DeleteAll;
                Reset;
                SetRange(Source,Source::Allocation);
                if FindLast then begin
                  CostEntry.Get("To Cost Entry No.");
                  CostAccSetup.Get;
                  CostAccSetup."Last Allocation Doc. No." := CostEntry."Document No.";
                  CostAccSetup.Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("No.",CostRegister2."No.",CostRegister3."No.");
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
                    field(FromRegisterNo;CostRegister2."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Register No.';
                        Lookup = true;
                        TableRelation = "Cost Register" where (Closed=const(false));
                    }
                    field(ToRegisterNo;CostRegister3."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Register No.';
                        Editable = false;
                        TableRelation = "Cost Register" where (Closed=const(false));
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CostRegister2.FindLast;
            CostRegister3.FindLast;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        CostRegister: Record "Cost Register";
    begin
        if CostRegister2."No." > CostRegister3."No." then
          Error(Text000);

        if not Confirm(Text001,false,CostRegister2."No.",CostRegister3."No.") then
          Error('');

        if not Confirm(Text004) then
          Error('');

        CostRegister.FindLast;
        if CostRegister."No." > CostRegister3."No." then
          Error(StrSubstNo(CostRegisterHasBeenModifiedErr,CostRegister."No."));

        Window.Open(Text005 +
          Text006 );
    end;

    var
        Text000: label 'From Register No. must not be higher than To Register No..';
        Text001: label 'All corresponding cost entries and register entries will be deleted. Do you want to delete cost register %1 to %2?';
        Text004: label 'Are you sure?';
        Text005: label 'Delete cost register\';
        Text006: label 'Register  no.      #1######';
        Text007: label 'Register %1 can no longer be deleted because it is marked as closed.';
        CostRegister2: Record "Cost Register";
        CostRegister3: Record "Cost Register";
        CostAccSetup: Record "Cost Accounting Setup";
        Window: Dialog;
        CostRegisterHasBeenModifiedErr: label 'Another user has modified the cost register. The To Register No. field must be equal to %1.\Run the Delete Cost Entries batch job again.';


    procedure InitializeRequest(NewFromRegisterNo: Integer;NewToRegisterNo: Integer)
    begin
        CostRegister2."No." := NewFromRegisterNo;
        CostRegister3."No." := NewToRegisterNo;
    end;
}

