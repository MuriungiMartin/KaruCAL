#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1193 "Implement Res. Price Change"
{
    Caption = 'Implement Res. Price Change';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Resource Price Change";"Resource Price Change")
        {
            DataItemTableView = sorting(Type,Code,"Work Type Code","Currency Code");
            RequestFilterFields = Type,"Code","Currency Code";
            column(ReportForNavId_2141; 2141)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,Type);
                Window.Update(2,Code);
                Window.Update(3,"Work Type Code");
                Window.Update(4,"Currency Code");
                ResPrice.Type := Type;
                ResPrice.Code := Code;
                ResPrice."Work Type Code" := "Work Type Code";
                ResPrice."Currency Code" := "Currency Code";
                ResPrice."Unit Price" := "New Unit Price";
                if not ResPrice.Insert then
                  ResPrice.Modify;
                ConfirmDeletion := true;
            end;

            trigger OnPostDataItem()
            begin
                if ConfirmDeletion then begin
                  Commit;
                  if Confirm(Text006) then
                    DeleteAll;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  Text001 +
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Updating Resource Prices...\\';
        Text001: label 'Type                #1##########\';
        Text002: label 'Code                #2##########\';
        Text003: label 'Work Type Code      #3##########\';
        Text004: label 'Job No.             #4##########\';
        Text005: label 'Currency Code       #5##########\';
        Text006: label 'The resource prices have now been updated in accordance with the suggested price changes.\\Do you want to delete the suggested price changes?';
        ResPrice: Record "Resource Price";
        Window: Dialog;
        ConfirmDeletion: Boolean;
}

