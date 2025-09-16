#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10327 "Assign Tax Area to Vendor"
{
    Caption = 'Assign Tax Area to Vendor';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = County;
            column(ReportForNavId_1020000; 1020000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Tax Area Code" := TaxAreaCode;
                "Tax Liable" := TaxLiable;
                Modify;
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
                    field("Tax Liable";TaxLiable)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Tax Liable';
                        ToolTip = 'Specifies the tax area code that will be assigned.';
                    }
                    field("Tax Area Code";TaxAreaCode)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Tax Area Code';
                        TableRelation = "Tax Area";
                        ToolTip = 'Specifies the tax area code that will be assigned.';
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

    trigger OnPostReport()
    begin
        if not Vendor.Find then
          CurrReport.Quit;
        Vendor.Modify;
    end;

    var
        TaxLiable: Boolean;
        TaxAreaCode: Code[20];


    procedure InitializeRequest(NewTaxLiable: Boolean;NewTaxAreaCode: Code[20])
    begin
        TaxAreaCode := NewTaxAreaCode;
        TaxLiable := NewTaxLiable;
    end;


    procedure SetDefaultAreaCode(NewTaxAreaCode: Code[20])
    begin
        TaxAreaCode := NewTaxAreaCode;
        TaxLiable := true;
    end;
}

