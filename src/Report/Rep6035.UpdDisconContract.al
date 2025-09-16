#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6035 "Upd. Disc.% on Contract"
{
    Caption = 'Upd. Disc.% on Contract';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Contract Line";"Service Contract Line")
        {
            RequestFilterFields = "Contract Type","Contract No.";
            column(ReportForNavId_6062; 6062)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SuspendStatusCheck(true);
                if "Line Discount %" + DiscountPct <= 0 then
                  Validate("Line Discount %",0)
                else
                  Validate("Line Discount %","Line Discount %" + DiscountPct);
                Modify(true);
                i := i + 1;
            end;

            trigger OnPostDataItem()
            begin
                if i > 0 then begin
                  UpdateContractAnnualAmount(false);
                  Message(Text000);
                end
            end;

            trigger OnPreDataItem()
            begin
                if DiscountPct = 0 then
                  CurrReport.Break;
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
                    field(DiscountPct;DiscountPct)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Add/Subtract Discount %';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if DiscountPct = 0 then
          Error(Text001);
    end;

    var
        Text000: label 'Service contract lines have been updated.';
        DiscountPct: Decimal;
        i: Integer;
        Text001: label 'You must enter a value in the "Add/Subtract Discount ''%''" field.';


    procedure InitializeRequest(DiscountPercent: Decimal)
    begin
        DiscountPct := DiscountPercent;
    end;
}

