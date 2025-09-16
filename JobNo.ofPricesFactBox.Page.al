#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9098 "Job No. of Prices FactBox"
{
    Caption = 'Job Details - No. of Prices';
    PageType = CardPart;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Jobs;
                Caption = 'Job No.';
                ToolTip = 'Specifies the job number.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(NoOfResourcePrices;NoOfResourcePrices)
            {
                ApplicationArea = Jobs;
                Caption = 'Resource';
                ToolTip = 'Specifies prices for the resource.';

                trigger OnDrillDown()
                var
                    JobResPrice: Record "Job Resource Price";
                begin
                    JobResPrice.SetRange("Job No.","No.");

                    Page.Run(Page::"Job Resource Prices",JobResPrice);
                end;
            }
            field(NoOfItemPrices;NoOfItemPrices)
            {
                ApplicationArea = Jobs;
                Caption = 'Item';
                ToolTip = 'Specifies the total usage cost of items associated with this job.';

                trigger OnDrillDown()
                var
                    JobItPrice: Record "Job Item Price";
                begin
                    JobItPrice.SetRange("Job No.","No.");

                    Page.Run(Page::"Job Item Prices",JobItPrice);
                end;
            }
            field(NoOfAccountPrices;NoOfAccountPrices)
            {
                ApplicationArea = Jobs;
                Caption = 'G/L Account';
                ToolTip = 'Specifies the sum of values in the Job G/L Account Prices window.';

                trigger OnDrillDown()
                var
                    JobAccPrice: Record "Job G/L Account Price";
                begin
                    JobAccPrice.SetRange("Job No.","No.");

                    Page.Run(Page::"Job G/L Account Prices",JobAccPrice);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcNoOfRecords;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        NoOfResourcePrices := 0;
        NoOfItemPrices := 0;
        NoOfAccountPrices := 0;

        exit(Find(Which));
    end;

    trigger OnOpenPage()
    begin
        CalcNoOfRecords;
    end;

    var
        NoOfResourcePrices: Integer;
        NoOfItemPrices: Integer;
        NoOfAccountPrices: Integer;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Job Card",Rec);
    end;

    local procedure CalcNoOfRecords()
    var
        JobResourcePrice: Record "Job Resource Price";
        JobItemPrice: Record "Job Item Price";
        JobAccountPrice: Record "Job G/L Account Price";
    begin
        JobResourcePrice.Reset;
        JobResourcePrice.SetRange("Job No.","No.");
        NoOfResourcePrices := JobResourcePrice.Count;

        JobItemPrice.Reset;
        JobItemPrice.SetRange("Job No.","No.");
        NoOfItemPrices := JobItemPrice.Count;

        JobAccountPrice.Reset;
        JobAccountPrice.SetRange("Job No.","No.");
        NoOfAccountPrices := JobAccountPrice.Count;
    end;
}

