#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7053 "Implement Price Change"
{
    Caption = 'Implement Price Change';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Price Worksheet";"Sales Price Worksheet")
        {
            DataItemTableView = sorting("Starting Date","Ending Date","Sales Type","Sales Code","Currency Code","Item No.","Variant Code","Unit of Measure Code","Minimum Quantity");
            RequestFilterFields = "Item No.","Sales Type","Sales Code","Unit of Measure Code","Currency Code";
            column(ReportForNavId_5995; 5995)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"Item No.");
                Window.Update(2,"Sales Type");
                Window.Update(3,"Sales Code");
                Window.Update(4,"Currency Code");
                Window.Update(5,"Starting Date");

                SalesPrice.Init;
                SalesPrice.Validate("Item No.","Item No.");
                SalesPrice.Validate("Sales Type","Sales Type");
                SalesPrice.Validate("Sales Code","Sales Code");
                SalesPrice.Validate("Unit of Measure Code","Unit of Measure Code");
                SalesPrice.Validate("Variant Code","Variant Code");
                SalesPrice.Validate("Starting Date","Starting Date");
                SalesPrice.Validate("Ending Date","Ending Date");
                SalesPrice."Minimum Quantity" := "Minimum Quantity";
                SalesPrice."Currency Code" := "Currency Code";
                SalesPrice."Unit Price" := "New Unit Price";
                SalesPrice."Price Includes VAT" := "Price Includes VAT";
                SalesPrice."Allow Line Disc." := "Allow Line Disc.";
                SalesPrice."Allow Invoice Disc." := "Allow Invoice Disc.";
                SalesPrice."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                if SalesPrice."Unit Price" <> 0 then
                  if not SalesPrice.Insert(true) then
                    SalesPrice.Modify(true);
            end;

            trigger OnPostDataItem()
            begin
                Commit;
                if not DeleteWhstLine then
                  DeleteWhstLine := Confirm(Text005);
                if DeleteWhstLine then
                  DeleteAll;
                Commit;
                if SalesPrice.FindFirst then;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  Text007 +
                  Text008 +
                  Text009 +
                  Text010 +
                  Text011);
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
        Text000: label 'Updating Unit Prices...\\';
        Text005: label 'The item prices have now been updated in accordance with the suggested price changes.\\Do you want to delete the suggested price changes?';
        Text007: label 'Item No.               #1##########\';
        Text008: label 'Sales Type             #2##########\';
        Text009: label 'Sales Code             #3##########\';
        Text010: label 'Currency Code          #4##########\';
        Text011: label 'Starting Date          #5######';
        SalesPrice: Record "Sales Price";
        Window: Dialog;
        DeleteWhstLine: Boolean;


    procedure InitializeRequest(NewDeleteWhstLine: Boolean)
    begin
        DeleteWhstLine := NewDeleteWhstLine;
    end;
}

