#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8639 "Copy Company Data"
{
    Caption = 'Copy Company Data';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Config. Line";
    SourceTableView = sorting("Line No.");

    layout
    {
        area(content)
        {
            field(NewCompanyName;NewCompanyName)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Copy from';
                ToolTip = 'Specifies the company to copy data from.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Clear(Company);
                    Company.SetFilter(Name,'<>%1',COMPANYNAME);
                    Company.Name := NewCompanyName;
                    if Page.RunModal(Page::Companies,Company) = Action::LookupOK then begin
                      NewCompanyName := Company.Name;
                      ValidateCompanyName;
                    end;
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ValidateCompanyName;
                end;
            }
            repeater(Control1)
            {
                field("Package Code";"Package Code")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = false;
                    ToolTip = 'Specifies the code of the package associated with the configuration. The code is filled in when you use the Assign Package function to select the package for the line type.';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the table that you want to use for the line type. After you select a table ID from the list of objects in the lookup table, the name of the table is automatically filled in the Name field.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the name of the line type.';
                }
                field(NoOfRecordsSourceTable;GetNoOfRecordsSourceTable)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of Records (Source Table)';
                    DrillDown = false;
                    ToolTip = 'Specifies how many records exist in the source table.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Copy Data")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Copy Data';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copy data from the selected company. This is useful, when you want to move from a test environment to a production environment, and want to copy data between the versions of the company.';

                trigger OnAction()
                begin
                    GetData;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterGroup := 2;
        SetRange("Company Filter",COMPANYNAME);
        FilterGroup := 0;
        SetRange("Line Type","line type"::Table);
        SetRange("Copying Available",true);
        SetRange("Licensed Table",true);
        SetRange("No. of Records",0);
        SetFilter("No. of Records (Source Table)",'<>0');
        if NewCompanyName <> '' then
          if NewCompanyName = COMPANYNAME then
            NewCompanyName := ''
          else
            if not Company.Get(NewCompanyName) then
              NewCompanyName := '';
        SetCompanyFilter;
    end;

    var
        Company: Record Company;
        ConfigMgt: Codeunit "Config. Management";
        NewCompanyName: Text[30];

    local procedure ValidateCompanyName()
    begin
        if NewCompanyName <> '' then begin
          Clear(Company);
          Company.SetFilter(Name,'<>%1',COMPANYNAME);
          Company.Name := NewCompanyName;
          Company.Find;
        end;
        SetCompanyFilter;
    end;

    local procedure GetData()
    var
        ConfigLine: Record "Config. Line";
    begin
        CurrPage.SetSelectionFilter(ConfigLine);
        FilterGroup := 2;
        ConfigLine.FilterGroup := 2;
        Copyfilter("Company Filter (Source Table)",ConfigLine."Company Filter (Source Table)");
        Copyfilter("Company Filter",ConfigLine."Company Filter");
        FilterGroup := 0;
        ConfigLine.FilterGroup := 0;
        ConfigLine := Rec;
        ConfigMgt.CopyDataDialog(NewCompanyName,ConfigLine);
    end;


    procedure SetCompanyFilter()
    begin
        FilterGroup := 2;
        SetRange("Company Filter (Source Table)",NewCompanyName);
        FilterGroup := 0;
    end;
}

