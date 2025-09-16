#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10328 "Assign Tax Area to Location"
{
    Caption = 'Assign Tax Area to Location';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Location;Location)
        {
            RequestFilterFields = "Code",Name;
            column(ReportForNavId_1020000; 1020000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Tax Area Code" := TaxAreaCode;
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
                    field("Tax Area Code";TaxAreaCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tax Area Code';
                        TableRelation = "Tax Area";
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
        if not Location.Find then
          CurrReport.Quit;
        Location.Modify;
    end;

    var
        TaxAreaCode: Code[20];


    procedure InitializeRequest(NewTaxAreaCode: Code[20])
    begin
        TaxAreaCode := NewTaxAreaCode;
    end;


    procedure SetDefaultAreaCode(NewTaxAreaCode: Code[20])
    begin
        TaxAreaCode := NewTaxAreaCode;
    end;
}

