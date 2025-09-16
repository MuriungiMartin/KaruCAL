#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6670 "Returns-Related Documents"
{
    Caption = 'Returns-Related Documents';
    PageType = List;
    SourceTable = "Returns-Related Document";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                    begin
                        Clear(CopyDocMgt);
                        case "Document Type" of
                          "document type"::"Sales Order":
                            SalesHeader.Get(SalesHeader."document type"::Order,"No.");
                          "document type"::"Sales Invoice":
                            SalesHeader.Get(SalesHeader."document type"::Invoice,"No.");
                          "document type"::"Sales Return Order":
                            SalesHeader.Get(SalesHeader."document type"::"Return Order","No.");
                          "document type"::"Sales Credit Memo":
                            SalesHeader.Get(SalesHeader."document type"::"Credit Memo","No.");
                          "document type"::"Purchase Order":
                            PurchHeader.Get(PurchHeader."document type"::Order,"No.");
                          "document type"::"Purchase Invoice":
                            PurchHeader.Get(PurchHeader."document type"::Invoice,"No.");
                          "document type"::"Purchase Return Order":
                            PurchHeader.Get(PurchHeader."document type"::"Return Order","No.");
                          "document type"::"Purchase Credit Memo":
                            PurchHeader.Get(PurchHeader."document type"::"Credit Memo","No.");
                        end;

                        if "Document Type" in ["document type"::"Sales Order".."document type"::"Sales Credit Memo"] then
                          CopyDocMgt.ShowSalesDoc(SalesHeader)
                        else
                          CopyDocMgt.ShowPurchDoc(PurchHeader);
                    end;
                }
            }
        }
    }

    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
}

