#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68631 "HMS Bed Card"
{
    Caption = 'Bed Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Fixed Asset";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Main Asset/Component";"Main Asset/Component")
                {
                    ApplicationArea = Basic;
                }
                field("Component of Main Asset";"Component of Main Asset")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Search Description";"Search Description")
                {
                    ApplicationArea = Basic;
                }
                field("Responsible Employee";"Responsible Employee")
                {
                    ApplicationArea = Basic;
                }
                field(Inactive;Inactive)
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
            }
            part(DepreciationBook;"FA Depreciation Books Subform")
            {
                SubPageLink = "FA No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("FA Class Code";"FA Class Code")
                {
                    ApplicationArea = Basic;
                }
                field("FA Subclass Code";"FA Subclass Code")
                {
                    ApplicationArea = Basic;
                }
                field("FA Location Code";"FA Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budgeted Asset";"Budgeted Asset")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Maintenance)
            {
                Caption = 'Maintenance';
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Maintenance Vendor No.";"Maintenance Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Under Maintenance";"Under Maintenance")
                {
                    ApplicationArea = Basic;
                }
                field("Next Service Date";"Next Service Date")
                {
                    ApplicationArea = Basic;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic;
                }
                field(Insured;Insured)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bed")
            {
                Caption = '&Bed';
                action("Depreciation &Books")
                {
                    ApplicationArea = Basic;
                    Caption = 'Depreciation &Books';
                    Image = DepreciationBooks;
                    RunObject = Page "FA Depreciation Books";
                    RunPageLink = "FA No."=field("No.");
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "FA Ledger Entries";
                    RunPageLink = "FA No."=field("No.");
                    RunPageView = sorting("FA No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Error Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Error Ledger Entries';
                    RunObject = Page "FA Error Ledger Entries";
                    RunPageLink = "Canceled from FA No."=field("No.");
                    RunPageView = sorting("Canceled from FA No.");
                }
                action("Main&tenance Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Main&tenance Ledger Entries';
                    Image = MaintenanceLedgerEntries;
                    RunObject = Page "Maintenance Ledger Entries";
                    RunPageLink = "FA No."=field("No.");
                    RunPageView = sorting("FA No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("Fixed Asset"),
                                  "No."=field("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5600),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Picture)
                {
                    ApplicationArea = Basic;
                    Caption = 'Picture';
                    RunObject = Page "Fixed Asset Picture";
                    RunPageLink = "No."=field("No.");
                }
                action("Maintenance &Registration")
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintenance &Registration';
                    Image = MaintenanceRegistrations;
                    RunObject = Page "Maintenance Registration";
                    RunPageLink = "FA No."=field("No.");
                }
                action("M&ain Bed Components")
                {
                    ApplicationArea = Basic;
                    Caption = 'M&ain Bed Components';
                    RunObject = Page "Main Asset Components";
                    RunPageLink = "Main Asset No."=field("No.");
                }
                action("C&opy Bed")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&opy Bed';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        CopyFA: Report "Copy Fixed Asset";
                    begin
                        CopyFA.SetFANo("No.");
                        CopyFA.RunModal;
                    end;
                }
                separator(Action39)
                {
                    Caption = '';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Fixed Asset Statistics";
                    RunPageLink = "FA No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Ma&in Bed Statistics")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ma&in Bed Statistics';
                    RunObject = Page "Main Asset Statistics";
                    RunPageLink = "FA No."=field("No.");
                }
                action("FA Posting Types Overview")
                {
                    ApplicationArea = Basic;
                    Caption = 'FA Posting Types Overview';
                    RunObject = Page "FA Posting Types Overview";
                }
            }
            group("&Depr. Book")
            {
                Caption = '&Depr. Book';
                action(Action58)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';

                    trigger OnAction()
                    begin
                        //CurrPage.DepreciationBook.PAGE.ShowFALedgEntries;
                    end;
                }
                action(Action59)
                {
                    ApplicationArea = Basic;
                    Caption = 'Error Ledger Entries';

                    trigger OnAction()
                    begin
                        //CurrPage.DepreciationBook.PAGE.ShowFAErrorLedgEntries;
                    end;
                }
                action("Maintenance Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintenance Ledger Entries';
                    Image = MaintenanceLedgerEntries;

                    trigger OnAction()
                    begin
                        //CurrPage.DepreciationBook.PAGE.ShowMaintenanceLedgEntries;
                    end;
                }
                separator(Action61)
                {
                    Caption = '';
                }
                action(Action62)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //CurrPage.DepreciationBook.PAGE.ShowStatistics;
                    end;
                }
                action("Main &Bed Statistics")
                {
                    ApplicationArea = Basic;
                    Caption = 'Main &Bed Statistics';

                    trigger OnAction()
                    begin
                        //CurrPage.DepreciationBook.PAGE.ShowMainAssetStatistics;
                    end;
                }
            }
        }
    }
}

