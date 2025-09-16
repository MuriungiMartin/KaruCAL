#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5784 "Filters to Get Source Docs."
{
    Caption = 'Filters to Get Source Docs.';
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Source Filter";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ShowRequestForm;ShowRequestForm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Filter Request';
                }
                field("Do Not Fill Qty. to Handle";"Do Not Fill Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that inventory quantities are assigned when you get outbound source document lines for shipment.';
                }
            }
            repeater(Control1)
            {
                Editable = true;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that identifies the filter record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of filter combinations in the Source Document Filter Card window to retrieve lines from source documents.';
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
        area(processing)
        {
            action(Run)
            {
                ApplicationArea = Basic;
                Caption = '&Run';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GetSourceBatch: Report "Get Source Documents";
                begin
                    case RequestType of
                      Requesttype::Receive:
                        begin
                          GetSourceBatch.SetOneCreatedReceiptHeader(WhseReceiptHeader);
                          SetFilters(GetSourceBatch,WhseReceiptHeader."Location Code");
                        end;
                      Requesttype::Ship:
                        begin
                          GetSourceBatch.SetOneCreatedShptHeader(WhseShptHeader);
                          SetFilters(GetSourceBatch,WhseShptHeader."Location Code");
                          GetSourceBatch.SetSkipBlocked(true);
                        end;
                    end;

                    GetSourceBatch.SetSkipBlockedItem(true);
                    GetSourceBatch.UseRequestPage(ShowRequestForm);
                    GetSourceBatch.RunModal;
                    if GetSourceBatch.NotCancelled then
                      CurrPage.Close;
                end;
            }
            action(Modify)
            {
                ApplicationArea = Basic;
                Caption = '&Modify';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SourceDocFilterCard: Page "Source Document Filter Card";
                begin
                    TestField(Code);
                    case RequestType of
                      Requesttype::Receive:
                        SourceDocFilterCard.SetOneCreatedReceiptHeader(WhseReceiptHeader);
                      Requesttype::Ship:
                        SourceDocFilterCard.SetOneCreatedShptHeader(WhseShptHeader);
                    end;
                    SourceDocFilterCard.SetRecord(Rec);
                    SourceDocFilterCard.SetTableview(Rec);
                    SourceDocFilterCard.RunModal;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowRequestForm := "Show Filter Request";
    end;

    trigger OnOpenPage()
    begin
        DataCaption := CurrPage.Caption;
        FilterGroup := 2;
        if GetFilter(Type) <> '' then
          DataCaption := DataCaption + ' - ' + GetFilter(Type);
        FilterGroup := 0;
        CurrPage.Caption(DataCaption);
    end;

    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        DataCaption: Text[250];
        ShowRequestForm: Boolean;
        RequestType: Option Receive,Ship;


    procedure SetOneCreatedShptHeader(WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        RequestType := Requesttype::Ship;
        WhseShptHeader := WhseShptHeader2;
    end;


    procedure SetOneCreatedReceiptHeader(WhseReceiptHeader2: Record "Warehouse Receipt Header")
    begin
        RequestType := Requesttype::Receive;
        WhseReceiptHeader := WhseReceiptHeader2;
    end;
}

