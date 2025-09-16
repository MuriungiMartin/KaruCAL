#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 553 "VAT Rate Change Log Entries"
{
    Caption = 'Tax Rate Change Log Entries';
    Editable = false;
    PageType = List;
    SourceTable = "VAT Rate Change Log Entry";
    SourceTableView = sorting("Entry No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Record Identifier";Format("Record ID"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Record Identifier';
                }
                field("Old Gen. Prod. Posting Group";"Old Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general product posting group before the Tax rate change conversion.';
                }
                field("New Gen. Prod. Posting Group";"New Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new general product posting group after the tax rate change conversion.';
                }
                field("Old VAT Prod. Posting Group";"Old VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax product posting group before the Tax rate change conversion.';
                }
                field("New VAT Prod. Posting Group";"New VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new Tax product posting group after the Tax rate change conversion.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description for the Tax rate change conversion.';
                }
                field(Converted;Converted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the Tax rate change conversion.';
                }
                field("Converted Date";"Converted Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the Tax rate change log entry was created.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Show)
                {
                    ApplicationArea = Basic;
                    Caption = '&Show';
                    Ellipsis = true;
                    Image = View;
                    Promoted = true;

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesLine: Record "Sales Line";
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        ServiceHeader: Record "Service Header";
                        ServiceLine: Record "Service Line";
                        PageManagement: Codeunit "Page Management";
                        RecRef: RecordRef;
                    begin
                        if Format("Record ID") = '' then
                          exit;
                        if not RecRef.Get("Record ID") then
                          Error(Text0002);
                        case "Table ID" of
                          Database::"Sales Header",
                          Database::"Purchase Header",
                          Database::"Gen. Journal Line",
                          Database::Item,
                          Database::"G/L Account",
                          Database::"Item Category",
                          Database::"Item Charge",
                          Database::Resource:
                            PageManagement.PageRunModal(RecRef);
                          Database::"Sales Line":
                            begin
                              RecRef.SetTable(SalesLine);
                              SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");
                              PageManagement.PageRunModal(SalesHeader);
                            end;
                          Database::"Purchase Line":
                            begin
                              RecRef.SetTable(PurchaseLine);
                              PurchaseHeader.Get(PurchaseLine."Document Type",PurchaseLine."Document No.");
                              PageManagement.PageRunModal(PurchaseHeader);
                            end;
                          Database::"Service Line":
                            begin
                              RecRef.SetTable(ServiceLine);
                              ServiceHeader.Get(ServiceLine."Document Type",ServiceLine."Document No.");
                              PageManagement.PageRunModal(ServiceHeader);
                            end;
                          else
                            Message(Text0001);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Table Caption")
    end;

    var
        Text0001: label 'Search for the pages to see this entry.';
        Text0002: label 'The related entry has been posted or deleted.';
}

