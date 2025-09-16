#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 240 "Business Unit List"
{
    ApplicationArea = Basic;
    Caption = 'Business Unit List';
    CardPageID = "Business Unit Card";
    Editable = false;
    PageType = List;
    SourceTable = "Business Unit";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Companies;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Currencies;
                }
                field("Currency Exchange Rate Table";"Currency Exchange Rate Table")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Data Source";"Data Source")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Consolidate;Consolidate)
                {
                    ApplicationArea = Basic;
                }
                field("Consolidation %";"Consolidation %")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Exch. Rate Gains Acc.";"Exch. Rate Gains Acc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Exch. Rate Losses Acc.";"Exch. Rate Losses Acc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Residual Account";"Residual Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field("File Format";"File Format")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&xch. Rates")
            {
                Caption = 'E&xch. Rates';
                Image = ManualExchangeRate;
                action("Average Rate (Manual)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Average Rate (Manual)';
                    Ellipsis = true;
                    Image = ManualExchangeRate;

                    trigger OnAction()
                    begin
                        ChangeExchangeRate.SetCaption(Text000);
                        ChangeExchangeRate.SetParameter("Currency Code","Income Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Income Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                action("Closing Rate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closing Rate';
                    Ellipsis = true;
                    Image = Close;

                    trigger OnAction()
                    begin
                        ChangeExchangeRate.SetCaption(Text001);
                        ChangeExchangeRate.SetParameter("Currency Code","Balance Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Balance Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                action("Last Closing Rate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Closing Rate';
                    Image = Close;

                    trigger OnAction()
                    begin
                        ChangeExchangeRate.SetCaption(Text002);
                        ChangeExchangeRate.SetParameter("Currency Code","Last Balance Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Last Balance Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
            }
            group("&Reports")
            {
                Caption = '&Reports';
                Image = "Report";
                action(Eliminations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Eliminations';
                    Ellipsis = true;
                    Image = "Report";
                    RunObject = Report "G/L Consolidation Eliminations";
                }
                action("Trial B&alance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trial B&alance';
                    Ellipsis = true;
                    Image = "Report";
                    RunObject = Report "Consolidated Trial Balance";
                }
                action("Trial &Balance (4)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trial &Balance (4)';
                    Ellipsis = true;
                    Image = "Report";
                    RunObject = Report "Consolidated Trial Balance (4)";
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Test Database")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Database';
                    Ellipsis = true;
                    Image = TestDatabase;
                    RunObject = Report "Consolidation - Test Database";
                }
                action("T&est File")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&est File';
                    Ellipsis = true;
                    Image = TestFile;
                    RunObject = Report "Consolidation - Test File";
                }
                separator(Action43)
                {
                }
                action("Import Database")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Database';
                    Ellipsis = true;
                    Image = ImportDatabase;
                    RunObject = Report "Import Consolidation from DB";
                }
                action("I&mport File")
                {
                    ApplicationArea = Basic;
                    Caption = 'I&mport File';
                    Ellipsis = true;
                    Image = Import;
                    RunObject = Report "Import Consolidation from File";
                }
            }
        }
    }

    var
        Text000: label 'Average Rate (Manual)';
        Text001: label 'Closing Rate';
        Text002: label 'Last Closing Rate';
        ChangeExchangeRate: Page "Change Exchange Rate";


    procedure GetSelectionFilter(): Text
    var
        BusUnit: Record "Business Unit";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(BusUnit);
        exit(SelectionFilterManagement.GetSelectionFilterForBusinessUnit(BusUnit));
    end;
}

