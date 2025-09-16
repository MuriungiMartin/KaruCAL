#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 357 "Copy Company"
{
    Caption = 'Copy Company';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company;Company)
        {
            DataItemTableView = sorting(Name);
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CopyCompany(Name,NewCompanyName);
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
                group(Control2)
                {
                    field("New Company Name";NewCompanyName)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Company Name';
                        NotBlank = true;
                        ToolTip = 'Specifies the name of the new company. The name can have a maximum of 30 characters. If the database collation is case-sensitive, you can have one company called COMPANY and another called Company. However, if the database is case-insensitive, you cannot create companies with names that differ only by case.';
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

    var
        NewCompanyName: Text[30];


    procedure GetCompanyName(): Text[30]
    begin
        exit(NewCompanyName);
    end;
}

